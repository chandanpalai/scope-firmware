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
-- Copyright 2005, 2006, 2007 Xilinx, Inc.
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
--  /   /        Filename	    : ddrbuffer.vhd
-- /___/   /\    Date Last Modified : $Date: 2010/11/26 18:25:44 $	
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
-- Device      : Spartan-3/3E/3A/3A-DSP
-- Design Name : DDR SDRAM
-- Purpose     : This module has the instantiations for infrastructure_top and
--               main modules.
--*****************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library UNISIM;
use UNISIM.VCOMPONENTS.all;

entity ddrbuffer is
  port (
      cntrl0_ddr_dq                 : inout std_logic_vector(7 downto 0);
      cntrl0_ddr_a                  : out   std_logic_vector(12 downto 0);
      cntrl0_ddr_ba                 : out   std_logic_vector(1 downto 0);
      cntrl0_ddr_cke                : out   std_logic;
      cntrl0_ddr_cs_n               : out   std_logic;
      cntrl0_ddr_ras_n              : out   std_logic;
      cntrl0_ddr_cas_n              : out   std_logic;
      cntrl0_ddr_we_n               : out   std_logic;
      cntrl0_ddr_dm                 : out   std_logic_vector(0 downto 0);
      cntrl0_rst_dqs_div_in         : in    std_logic;
      cntrl0_rst_dqs_div_out        : out   std_logic;
      reset_in_n                    : in    std_logic;
      cntrl0_burst_done             : in    std_logic;
      cntrl0_init_val               : out   std_logic;
      cntrl0_ar_done                : out   std_logic;
      cntrl0_user_data_valid        : out   std_logic;
      cntrl0_auto_ref_req           : out   std_logic;
      cntrl0_user_cmd_ack           : out   std_logic;
      cntrl0_user_command_register  : in    std_logic_vector(2 downto 0);
      cntrl0_clk_tb                 : out   std_logic;
      cntrl0_clk90_tb               : out   std_logic;
      cntrl0_sys_rst_tb             : out   std_logic;
      cntrl0_sys_rst90_tb           : out   std_logic;
      cntrl0_sys_rst180_tb          : out   std_logic;
      cntrl0_user_data_mask         : in    std_logic_vector(1 downto 0);
      cntrl0_user_output_data       : out   std_logic_vector(15 downto 0);
      cntrl0_user_input_data        : in    std_logic_vector(15 downto 0);
      cntrl0_user_input_address     : in    std_logic_vector(25 downto 0);
      clk_int                       : in    std_logic;
      clk90_int                     : in    std_logic;
      dcm_lock                      : in    std_logic;
      cntrl0_ddr_dqs                : inout std_logic_vector(0 downto 0);
      cntrl0_ddr_ck                 : out   std_logic_vector(0 downto 0);
      cntrl0_ddr_ck_n               : out   std_logic_vector(0 downto 0)
    );
end ddrbuffer;

architecture arc_mem_interface_top of ddrbuffer is

  ATTRIBUTE X_CORE_INFO          : STRING;
  ATTRIBUTE CORE_GENERATION_INFO : STRING;

  ATTRIBUTE X_CORE_INFO of arc_mem_interface_top : ARCHITECTURE IS "mig_v3_61_ddr_sp3, Coregen 12.4";
  ATTRIBUTE CORE_GENERATION_INFO of arc_mem_interface_top : ARCHITECTURE IS "ddr_sp3,mig_v3_61,{component_name=ddr_sp3, data_width=8, memory_width=8, clk_width=1, bank_address=2, row_address=13, column_address=11, no_of_cs=1, cke_width=1, registered=0, data_mask=1, mask_enable=1, load_mode_register=0000001100001, ext_load_mode_register=0000000000000, language=VHDL, synthesis_tool=ISE, interface_type=DDR_SDRAM, no_of_controllers=1}";

  component ddrbuffer_top_0
    port(
      ddr_dq                : inout std_logic_vector(7 downto 0);
      ddr_a                 : out   std_logic_vector(12 downto 0);
      ddr_ba                : out   std_logic_vector(1 downto 0);
      ddr_cke               : out   std_logic;
      ddr_cs_n              : out   std_logic;
      ddr_ras_n             : out   std_logic;
      ddr_cas_n             : out   std_logic;
      ddr_we_n              : out   std_logic;
      ddr_dm                : out   std_logic_vector(0 downto 0);
      rst_dqs_div_in        : in    std_logic;
      rst_dqs_div_out       : out   std_logic;
      burst_done            : in    std_logic;
      init_val              : out   std_logic;
      ar_done               : out   std_logic;
      user_data_valid       : out   std_logic;
      auto_ref_req          : out   std_logic;
      user_cmd_ack          : out   std_logic;
      user_command_register : in    std_logic_vector(2 downto 0);
      clk_tb                : out   std_logic;
      clk90_tb              : out   std_logic;
      sys_rst_tb            : out   std_logic;
      sys_rst90_tb          : out   std_logic;
      sys_rst180_tb         : out   std_logic;
      user_data_mask        : in    std_logic_vector(1 downto 0);
      user_output_data      : out   std_logic_vector(15 downto 0);
      user_input_data       : in    std_logic_vector(15 downto 0);
      user_input_address    : in    std_logic_vector(25 downto 0);
      ddr_dqs               : inout std_logic_vector(0 downto 0);
      ddr_ck                : out   std_logic_vector(0 downto 0);
      ddr_ck_n              : out   std_logic_vector(0 downto 0);
      clk_int               : in    std_logic;
      clk90_int             : in    std_logic;
      wait_200us             : in std_logic;   
      delay_sel_val          : in std_logic_vector(4 downto 0);   
      sys_rst_val            : in std_logic;   
      sys_rst90_val          : in std_logic;   
      sys_rst180_val         : in std_logic;   
      --Debug ports

      dbg_delay_sel          : out std_logic_vector(4 downto 0);
      dbg_rst_calib          : out std_logic;
      vio_out_dqs            : in  std_logic_vector(4 downto 0);
      vio_out_dqs_en         : in  std_logic;
      vio_out_rst_dqs_div    : in  std_logic_vector(4 downto 0);
      vio_out_rst_dqs_div_en : in  std_logic
      );
  end component;
  component ddrbuffer_infrastructure_top0
    port (
      wait_200us_rout        : out std_logic;
      delay_sel_val1_val     : out std_logic_vector(4 downto 0);
      sys_rst_val            : out std_logic;
      sys_rst90_val          : out std_logic;
            reset_in_n            : in    std_logic;
      clk_int               : in    std_logic;
      clk90_int             : in    std_logic;
      dcm_lock              : in    std_logic;     
      sys_rst180_val         : out std_logic;
      dbg_phase_cnt          : out std_logic_vector(4 downto 0);
      dbg_cnt                : out std_logic_vector(5 downto 0);
      dbg_trans_onedtct      : out std_logic;
      dbg_trans_twodtct      : out std_logic;
      dbg_enb_trans_two_dtct : out std_logic
      );
  end component;

  component icon
    port (
      CONTROL0 : inout std_logic_vector(35 downto 0);
      CONTROL1 : inout std_logic_vector(35 downto 0)
      );
  end component;

  component ila
    port (
     CLK     : in    std_logic;
     DATA    : in    std_logic_vector(19 downto 0);
     TRIG0   : in    std_logic_vector(3 downto 0);
     CONTROL : inout std_logic_vector(35 downto 0)
     );
  end component;

  component vio
    port (
      CONTROL : inout std_logic_vector(35 downto 0);
      ASYNC_OUT: out std_logic_vector(11 downto 0)
      );
  end component;
  attribute syn_black_box          : boolean;
  attribute syn_noprune            : boolean;
  attribute syn_black_box of icon  : component is TRUE;
  attribute syn_noprune of icon    : component is TRUE;
  attribute syn_black_box of ila   : component is TRUE;
  attribute syn_noprune of ila     : component is TRUE;
  attribute syn_black_box of vio   : component is TRUE;
  attribute syn_noprune of vio     : component is TRUE;

  
  signal sys_rst                : std_logic;
  signal wait_200us             : std_logic;
  signal sys_rst90              : std_logic;
  signal sys_rst180             : std_logic;
  signal delay_sel_val          : std_logic_vector(4 downto 0);
  -- debug signals 
  signal dbg_phase_cnt          : std_logic_vector(4 downto 0);
  signal dbg_cnt                : std_logic_vector(5 downto 0);
  signal dbg_trans_onedtct      : std_logic;
  signal dbg_trans_twodtct      : std_logic;
  signal dbg_enb_trans_two_dtct : std_logic;
  signal dbg_delay_sel          : std_logic_vector(4 downto 0);
  signal dbg_rst_calib          : std_logic;
  -- chipscope signals
  signal dbg_data               : std_logic_vector(19 downto 0);
  signal dbg_trig               : std_logic_vector(3 downto 0);
  signal control0               : std_logic_vector(35 downto 0);
  signal control1               : std_logic_vector(35 downto 0);
  signal vio_out_dqs            : std_logic_vector(4 downto 0);
  signal vio_out_dqs_en         : std_logic;
  signal vio_out_rst_dqs_div    : std_logic_vector(4 downto 0);
  signal vio_out_rst_dqs_div_en : std_logic;
  signal vio_out                : std_logic_vector(11 downto 0); 

begin
  top_00 : ddrbuffer_top_0
    port map (
      ddr_dq                => cntrl0_ddr_dq,
      ddr_a                 => cntrl0_ddr_a,
      ddr_ba                => cntrl0_ddr_ba,
      ddr_cke               => cntrl0_ddr_cke,
      ddr_cs_n              => cntrl0_ddr_cs_n,
      ddr_ras_n             => cntrl0_ddr_ras_n,
      ddr_cas_n             => cntrl0_ddr_cas_n,
      ddr_we_n              => cntrl0_ddr_we_n,
      ddr_dm                => cntrl0_ddr_dm,
      rst_dqs_div_in        => cntrl0_rst_dqs_div_in,
      rst_dqs_div_out       => cntrl0_rst_dqs_div_out,
      burst_done            => cntrl0_burst_done,
      init_val              => cntrl0_init_val,
      ar_done               => cntrl0_ar_done,
      user_data_valid       => cntrl0_user_data_valid,
      auto_ref_req          => cntrl0_auto_ref_req,
      user_cmd_ack          => cntrl0_user_cmd_ack,
      user_command_register => cntrl0_user_command_register,
      clk_tb                => cntrl0_clk_tb,
      clk90_tb              => cntrl0_clk90_tb,
      sys_rst_tb            => cntrl0_sys_rst_tb,
      sys_rst90_tb          => cntrl0_sys_rst90_tb,
      sys_rst180_tb         => cntrl0_sys_rst180_tb,
      user_data_mask        => cntrl0_user_data_mask,
      user_output_data      => cntrl0_user_output_data,
      user_input_data       => cntrl0_user_input_data,
      user_input_address    => cntrl0_user_input_address,
      ddr_dqs               => cntrl0_ddr_dqs,
      ddr_ck                => cntrl0_ddr_ck,
      ddr_ck_n              => cntrl0_ddr_ck_n,
      clk_int               => clk_int,
      clk90_int             => clk90_int,
      wait_200us             => wait_200us,
      delay_sel_val          => delay_sel_val,
      sys_rst_val            => sys_rst,
      sys_rst90_val          => sys_rst90,
      sys_rst180_val         => sys_rst180,

    --Debug signals

      dbg_delay_sel         => dbg_delay_sel,
      dbg_rst_calib          => dbg_rst_calib,
      vio_out_dqs            => vio_out_dqs,
      vio_out_dqs_en         => vio_out_dqs_en,
      vio_out_rst_dqs_div    => vio_out_rst_dqs_div,
      vio_out_rst_dqs_div_en => vio_out_rst_dqs_div_en
      );

  infrastructure_top0 : ddrbuffer_infrastructure_top0
    port map (
      wait_200us_rout        => wait_200us,
      delay_sel_val1_val     => delay_sel_val,
      sys_rst_val            => sys_rst,
      sys_rst90_val          => sys_rst90,
      sys_rst180_val         => sys_rst180,
      dbg_phase_cnt          => dbg_phase_cnt,
      dbg_cnt                => dbg_cnt,
      dbg_trans_onedtct      => dbg_trans_onedtct,
      dbg_trans_twodtct      => dbg_trans_twodtct,
      dbg_enb_trans_two_dtct => dbg_enb_trans_two_dtct,
            reset_in_n            => reset_in_n,
      clk_int               => clk_int,
      clk90_int             => clk90_int,
      dcm_lock              => dcm_lock
      );

  
  dbg_data(19 downto 0) <= (dbg_delay_sel & dbg_rst_calib & 
						   dbg_phase_cnt & dbg_cnt & dbg_trans_onedtct &
						   dbg_trans_twodtct & dbg_enb_trans_two_dtct);

  dbg_trig(3 downto 0) <= (dbg_rst_calib & dbg_trans_onedtct &
						   dbg_trans_twodtct & dbg_enb_trans_two_dtct);

  vio_out_rst_dqs_div_en <= vio_out(11);
  vio_out_rst_dqs_div    <= vio_out(10 downto 6);
  vio_out_dqs_en         <= vio_out(5);
  vio_out_dqs            <= vio_out(4 downto 0);

  ILA_INST : ila
    port map (
      CONTROL => control0,
      CLK     => clk_int,
      DATA    => dbg_data,
      TRIG0   => dbg_trig
      );

  ICON_INST : icon
    port map (
      CONTROL0 => control0,
      CONTROL1 => control1
      );

  VIO_INST : vio
    port map (
      CONTROL   => control1,
      ASYNC_OUT => vio_out
      );

end arc_mem_interface_top;
