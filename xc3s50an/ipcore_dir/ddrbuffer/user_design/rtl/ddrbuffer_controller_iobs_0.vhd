--*****************************************************************************
-- DISCLAIMER OF LIABILITY
--
-- This file contains proprietary and confidential information of
-- Xilinx, Inc. ("Xilinx"), that is distributed under a license
-- from Xilinx, and may be used, copied and/or disclosed only
-- pursuant to the terms of a valid license agreement with Xilinx.
--
-- XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION
-- ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
-- EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT
-- LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,
-- MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx
-- does not warrant that functions included in the Materials will
-- meet the requirements of Licensee, or that the operation of the
-- Materials will be uninterrupted or error-free, or that defects
-- in the Materials will be corrected. Furthermore, Xilinx does
-- not warrant or make any representations regarding use, or the
-- results of the use, of the Materials in terms of correctness,
-- accuracy, reliability or otherwise.
--
-- Xilinx products are not designed or intended to be fail-safe,
-- or for use in any application requiring fail-safe performance,
-- such as life-support or safety devices or systems, Class III
-- medical devices, nuclear facilities, applications related to
-- the deployment of airbags, or any other applications that could
-- lead to death, personal injury or severe property or
-- environmental damage (individually and collectively, "critical
-- applications"). Customer assumes the sole risk and liability
-- of any use of Xilinx products in critical applications,
-- subject only to applicable laws and regulations governing
-- limitations on product liability.
--
-- Copyright 2005, 2006, 2007, 2008 Xilinx, Inc.
-- All rights reserved.
--
-- This disclaimer and copyright notice must be retained as part
-- of this file at all times.
--*****************************************************************************
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor		    : Xilinx
-- \   \   \/    Version	    : 3.6.1
--  \   \        Application	    : MIG
--  /   /        Filename	    : ddrbuffer_controller_iobs_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2010/11/26 18:25:43 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
-- Device      : Spartan-3/3E/3A/3A-DSP
-- Design Name : DDR SDRAM
-- Purpose     : This module has the IOB instantiations to the address and 
--							 control signals.
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.ddrbuffer_parameters_0.all;
library UNISIM;
use UNISIM.VCOMPONENTS.all;

entity ddrbuffer_controller_iobs_0 is
  port (
    clk0              : in  std_logic;
    ddr_rasb_cntrl    : in  std_logic;
    ddr_casb_cntrl    : in  std_logic;
    ddr_web_cntrl     : in  std_logic;
    ddr_cke_cntrl     : in  std_logic;
    ddr_csb_cntrl     : in  std_logic;
    ddr_address_cntrl : in  std_logic_vector((ROW_ADDRESS -1) downto 0);
    ddr_ba_cntrl      : in  std_logic_vector((BANK_ADDRESS -1) downto 0);
    rst_dqs_div_int   : in  std_logic;
    ddr_rasb          : out std_logic;
    ddr_casb          : out std_logic;
    ddr_web           : out std_logic;
    ddr_ba            : out std_logic_vector((BANK_ADDRESS -1) downto 0);
    ddr_address       : out std_logic_vector((ROW_ADDRESS -1) downto 0);
    ddr_cke           : out std_logic;
    ddr_csb           : out std_logic;
    rst_dqs_div       : out std_logic;
    rst_dqs_div_in    : in  std_logic;
    rst_dqs_div_out   : out std_logic
    );
end ddrbuffer_controller_iobs_0;

architecture arc of ddrbuffer_controller_iobs_0 is

  signal ddr_web_q       : std_logic;
  signal ddr_rasb_q      : std_logic;
  signal ddr_casb_q      : std_logic;
  signal ddr_cke_q       : std_logic;
  signal clk180          : std_logic;
  signal ddr_address_reg : std_logic_vector((ROW_ADDRESS -1) downto 0);
  signal ddr_ba_reg      : std_logic_vector((BANK_ADDRESS -1) downto 0);
  signal ddr_cke_int     : std_logic;

  attribute iob          : string;
  attribute syn_useioff  : boolean;

  attribute iob of iob_rasb : label is "FORCE";
  attribute iob of iob_casb : label is "FORCE";
  attribute iob of iob_web  : label is "FORCE";
  attribute iob of iob_cke  : label is "FORCE";

  attribute syn_useioff of iob_rasb : label is true;
  attribute syn_useioff of iob_casb : label is true;
  attribute syn_useioff of iob_web  : label is true;
  attribute syn_useioff of iob_cke  : label is true;

begin

  clk180 <= not clk0;

---- *******************************************  ----
----  Includes the instantiation of FD for cntrl  ----
----            signals                           ----
---- *******************************************  ----

  iob_web : FD
    port map (
      Q => ddr_web_q,
      D => ddr_web_cntrl,
      C => clk180
      );

  iob_rasb : FD
    port map (
      Q => ddr_rasb_q,
      D => ddr_rasb_cntrl,
      C => clk180
      );

  iob_casb : FD
    port map (
      Q => ddr_casb_q,
      D => ddr_casb_cntrl,
      C => clk180
      );

---- *************************************  ----
----  Output buffers for control signals    ----
---- *************************************  ----

  r16 : OBUF
    port map (
      I => ddr_web_q,
      O => ddr_web
      );

  r17 : OBUF
    port map (
      I => ddr_rasb_q,
      O => ddr_rasb
      );

  r18 : OBUF
    port map (
      I => ddr_casb_q,
      O => ddr_casb
      );

  r19 : OBUF
    port map (
      I => ddr_csb_cntrl,
      O => ddr_csb
      );

  iob_cke0 : FD
    port map (
      Q => ddr_cke_int,
      D => ddr_cke_cntrl,
      C => clk0
      );

  iob_cke : FD
    port map (
      Q => ddr_cke_q,
      D => ddr_cke_int,
      C => clk180
      );

  r20 : OBUF
    port map (
      I => ddr_cke_q,
      O => ddr_cke
      );

---- *******************************************  ----
----  Includes the instantiation of FD and OBUF   ----
----  for row address and bank address            ----
---- *******************************************  ----

  gen_addr : for i in (ROW_ADDRESS -1) downto 0 generate
    attribute IOB of iob_addr_inst         : label is "FORCE";
    attribute syn_useioff of iob_addr_inst : label is true;
  begin
    iob_addr_inst : FD
      port map (
        Q => ddr_address_reg(i),
        D => ddr_address_cntrl(i),
        C => clk180
        );

    r : OBUF
      port map (
        I => ddr_address_reg(i),
        O => ddr_address(i)
        );
  end generate;

  gen_ba : for i in (BANK_ADDRESS -1) downto 0 generate
    attribute IOB of iob_ba_inst         : label is "FORCE";
    attribute syn_useioff of iob_ba_inst : label is true;
  begin
    iob_ba_inst : FD
      port map (
        Q => ddr_ba_reg(i),
        D => ddr_ba_cntrl(i),
        C => clk180
        );

    r : OBUF
      port map (
        I => ddr_ba_reg(i),
        O => ddr_ba(i)
        );
  end generate;

  rst_iob_inbuf : IBUF
    port map (
      I => rst_dqs_div_in,
      O => rst_dqs_div
      );

  rst_iob_outbuf : OBUF
    port map (
      I => rst_dqs_div_int,
      O => rst_dqs_div_out
      );

end arc;
