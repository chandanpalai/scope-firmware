--------------------------------------------------------------------------------
-- Copyright (c) 1995-2011 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 13.2
--  \   \         Application : xaw2vhdl
--  /   /         Filename : maindcm.vhd
-- /___/   /\     Timestamp : 08/14/2011 17:53:38
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: xaw2vhdl-st /home/ali/Projects/Active/cur/usbscope/fw/xc3s50an/ipcore_dir/./maindcm.xaw /home/ali/Projects/Active/cur/usbscope/fw/xc3s50an/ipcore_dir/./maindcm
--Design Name: maindcm
--Device: xc3s50an-4tqg144
--
-- Module maindcm
-- Generated by Xilinx Architecture Wizard
-- Written for synthesis tool: XST
-- Period Jitter (unit interval) for block DCM_SP_INST = 0.14 UI
-- Period Jitter (Peak-to-Peak) for block DCM_SP_INST = 0.71 ns

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity maindcm is
   port ( CLKIN_IN        : in    std_logic; 
          CLKFX_OUT       : out   std_logic; 
          CLKIN_IBUFG_OUT : out   std_logic; 
          CLK0_OUT        : out   std_logic; 
          LOCKED_OUT      : out   std_logic);
end maindcm;

architecture BEHAVIORAL of maindcm is
   signal CLKFB_IN        : std_logic;
   signal CLKFX_BUF       : std_logic;
   signal CLKIN_IBUFG     : std_logic;
   signal CLK0_BUF        : std_logic;
   signal GND_BIT         : std_logic;
begin
   GND_BIT <= '0';
   CLKIN_IBUFG_OUT <= CLKIN_IBUFG;
   CLK0_OUT <= CLKFB_IN;
   CLKFX_BUFG_INST : BUFG
      port map (I=>CLKFX_BUF,
                O=>CLKFX_OUT);
   
   CLKIN_IBUFG_INST : IBUFG
      port map (I=>CLKIN_IN,
                O=>CLKIN_IBUFG);
   
   CLK0_BUFG_INST : BUFG
      port map (I=>CLK0_BUF,
                O=>CLKFB_IN);
   
   DCM_SP_INST : DCM_SP
   generic map( CLK_FEEDBACK => "1X",
            CLKDV_DIVIDE => 2.0,
            CLKFX_DIVIDE => 1,
            CLKFX_MULTIPLY => 6,
            CLKIN_DIVIDE_BY_2 => FALSE,
            CLKIN_PERIOD => 30.000,
            CLKOUT_PHASE_SHIFT => "NONE",
            DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS",
            DFS_FREQUENCY_MODE => "LOW",
            DLL_FREQUENCY_MODE => "LOW",
            DUTY_CYCLE_CORRECTION => TRUE,
            FACTORY_JF => x"C080",
            PHASE_SHIFT => 0,
            STARTUP_WAIT => FALSE)
      port map (CLKFB=>CLKFB_IN,
                CLKIN=>CLKIN_IBUFG,
                DSSEN=>GND_BIT,
                PSCLK=>GND_BIT,
                PSEN=>GND_BIT,
                PSINCDEC=>GND_BIT,
                RST=>GND_BIT,
                CLKDV=>open,
                CLKFX=>CLKFX_BUF,
                CLKFX180=>open,
                CLK0=>CLK0_BUF,
                CLK2X=>open,
                CLK2X180=>open,
                CLK90=>open,
                CLK180=>open,
                CLK270=>open,
                LOCKED=>LOCKED_OUT,
                PSDONE=>open,
                STATUS=>open);
   
end BEHAVIORAL;

