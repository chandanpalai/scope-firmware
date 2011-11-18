--*****************************************************************************
-- (c) Copyright 2009 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
--
--*****************************************************************************
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor             : Xilinx
-- \   \   \/     Version            : 3.9
--  \   \         Application        : MIG
--  /   /         Filename           : memc13_infrastructure.vhd
-- /___/   /\     Date Last Modified : $Date: 2011/06/02 07:16:59 $
-- \   \  /  \    Date Created       : Jul 03 2009
--  \___\/\___\
--
--Device           : Spartan-6
--Design Name      : DDR/DDR2/DDR3/LPDDR
--Purpose          : Clock generation/distribution and reset synchronization
--Reference        :
--Revision History : By Ali Lown to merge into the rest of the design without
--                   duplicating excessively
--*****************************************************************************
library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

entity memc13_infrastructure is
generic
  (
    C_INCLK_PERIOD     : integer := 2500;
    C_RST_ACT_LOW      : integer := 1;
    C_INPUT_CLK_TYPE   : string  := "DIFFERENTIAL";
    C_CLKOUT0_DIVIDE   : integer := 1;
    C_CLKOUT1_DIVIDE   : integer := 1;
    C_CLKOUT2_DIVIDE   : integer := 16;
    C_CLKOUT3_DIVIDE   : integer := 8;
    C_CLKFBOUT_MULT   : integer := 2;
    C_DIVCLK_DIVIDE   : integer := 1

  );
port
(
    sys_rst_i       : in std_logic;
    mcb_drp_clk     : in std_logic;
    clk0            : in std_logic;
    clk_2x_0        : in std_logic;
    clk_2x_180      : in std_logic;
    locked          : in std_logic;

    rst0            : out std_logic;
    async_rst       : out std_logic;

    sysclk1_2x      : out std_logic;
    sysclk1_2x_180  : out std_logic;
    sysclk3_2x      : out std_logic;
    sysclk3_2x_180  : out std_logic;


    pll_ce1_0        : out std_logic;
    pll_ce1_90       : out std_logic;
    pll_ce3_0        : out std_logic;
    pll_ce3_90       : out std_logic;

    pll_lock        : out std_logic

);
end entity;
architecture syn of memc13_infrastructure is

  -- # of clock cycles to delay deassertion of reset. Needs to be a fairly
  -- high number not so much for metastability protection, but to give time
  -- for reset (i.e. stable clock cycles) to propagate through all state
  -- machines and to all control signals (i.e. not all control signals have
  -- resets, instead they rely on base state logic being reset, and the effect
  -- of that reset propagating through the logic). Need this because we may not
  -- be getting stable clock cycles while reset asserted (i.e. since reset
  -- depends on PLL/DCM lock status)

  constant RST_SYNC_NUM   : integer := 25;
  constant CLK_PERIOD_NS  : real := (real(C_INCLK_PERIOD)) / 1000.0;
  constant CLK_PERIOD_INT : integer := C_INCLK_PERIOD/1000;


  signal   clkfbout_clkfbin    : std_logic;
  signal   rst_tmp             : std_logic;
  signal   sys_rst             : std_logic;
  signal   rst0_sync_r         : std_logic_vector(RST_SYNC_NUM-1 downto 0);
  signal   powerup_pll_locked  : std_logic;
  signal   syn_clk0_powerup_pll_locked : std_logic;
  signal   pll_lock_out         : std_logic;
  signal   bufpll_mcb1_locked   : std_logic;
  signal   bufpll_mcb3_locked   : std_logic;

  attribute max_fanout : string;
  attribute syn_maxfan : integer;
  attribute KEEP : string;
  attribute max_fanout of rst0_sync_r : signal is "10";
  attribute syn_maxfan of rst0_sync_r : signal is 10;

begin

  sys_rst  <= not(sys_rst_i) when (C_RST_ACT_LOW /= 0) else sys_rst_i;
  pll_lock_out <= bufpll_mcb1_locked and bufpll_mcb3_locked;
  pll_lock <= pll_lock_out;

  --***************************************************************************
  -- Global clock generation and distribution
  --***************************************************************************

   process (mcb_drp_clk, sys_rst)
   begin
      if(sys_rst = '1') then
         powerup_pll_locked <= '0';
      elsif (mcb_drp_clk'event and mcb_drp_clk = '1') then
         if (pll_lock_out = '1') then
            powerup_pll_locked <= '1';
         end if;
      end if;
   end process;


   process (clk0, sys_rst)
   begin
      if(sys_rst = '1') then
         syn_clk0_powerup_pll_locked <= '0';
      elsif (clk0'event and clk0 = '1') then
         if (pll_lock_out = '1') then
            syn_clk0_powerup_pll_locked <= '1';
         end if;
      end if;
   end process;


   --***************************************************************************
   -- Reset synchronization
   -- NOTES:
   --   1. shut down the whole operation if the PLL hasn't yet locked (and
   --      by inference, this means that external sys_rst has been asserted -
   --      PLL deasserts LOCKED as soon as sys_rst asserted)
   --   2. asynchronously assert reset. This was we can assert reset even if
   --      there is no clock (needed for things like 3-stating output buffers).
   --      reset deassertion is synchronous.
   --   3. asynchronous reset only look at pll_lock from PLL during power up. After
   --      power up and pll_lock is asserted, the powerup_pll_locked will be asserted
   --      forever until sys_rst is asserted again. PLL will lose lock when FPGA
   --      enters suspend mode. We don't want reset to MCB get
   --      asserted in the application that needs suspend feature.
   --***************************************************************************


  async_rst <= sys_rst or not(powerup_pll_locked);
  -- async_rst <= rst_tmp;
  rst_tmp <= sys_rst or not(syn_clk0_powerup_pll_locked);
  -- rst_tmp <= sys_rst or not(powerup_pll_locked);

process (clk0, rst_tmp)
  begin
    if (rst_tmp = '1') then
      rst0_sync_r <= (others => '1');
    elsif (rising_edge(clk0)) then
      rst0_sync_r <= rst0_sync_r(RST_SYNC_NUM-2 downto 0) & '0';  -- logical left shift by one (pads with 0)
    end if;
  end process;

  rst0    <= rst0_sync_r(RST_SYNC_NUM-1);


BUFPLL_MCB_INST1 : BUFPLL_MCB
port map
( IOCLK0         => sysclk1_2x,
  IOCLK1         => sysclk1_2x_180,
  LOCKED         => locked,
  GCLK           => mcb_drp_clk,
  SERDESSTROBE0  => pll_ce1_0,
  SERDESSTROBE1  => pll_ce1_90,
  PLLIN0         => clk_2x_0,
  PLLIN1         => clk_2x_180,
  LOCK           => bufpll_mcb1_locked
  );

BUFPLL_MCB_INST3 : BUFPLL_MCB
port map
( IOCLK0         => sysclk3_2x,
  IOCLK1         => sysclk3_2x_180,
  LOCKED         => locked,
  GCLK           => mcb_drp_clk,
  SERDESSTROBE0  => pll_ce3_0,
  SERDESSTROBE1  => pll_ce3_90,
  PLLIN0         => clk_2x_0,
  PLLIN1         => clk_2x_180,
  LOCK           => bufpll_mcb3_locked
  );

end architecture syn;

