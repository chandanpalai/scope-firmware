----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:23:58 11/25/2010 
-- Design Name: 
-- Module Name:    dimm0 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dimm0 is
		port(
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
end dimm0;

architecture Behavioral of dimm0 is
		component mem
		 port(
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
		end component;
begin
		dimm0 :mem
			   port map (
			  cntrl0_ddr_dq                 => cntrl0_ddr_dq,
			  cntrl0_ddr_a                  => cntrl0_ddr_a,
			  cntrl0_ddr_ba                 => cntrl0_ddr_ba,
			  cntrl0_ddr_cke                => cntrl0_ddr_cke,
			  cntrl0_ddr_cs_n               => cntrl0_ddr_cs_n,
			  cntrl0_ddr_ras_n              => cntrl0_ddr_ras_n,
			  cntrl0_ddr_cas_n              => cntrl0_ddr_cas_n,
			  cntrl0_ddr_we_n               => cntrl0_ddr_we_n,
			  cntrl0_ddr_dm                 => cntrl0_ddr_dm,
			  cntrl0_rst_dqs_div_in         => cntrl0_rst_dqs_div_in,
			  cntrl0_rst_dqs_div_out        => cntrl0_rst_dqs_div_out,
			  reset_in_n                    => reset_in_n,
			  cntrl0_burst_done             => cntrl0_burst_done,
			  cntrl0_init_val               => cntrl0_init_val,
			  cntrl0_ar_done                => cntrl0_ar_done,
			  cntrl0_user_data_valid        => cntrl0_user_data_valid,
			  cntrl0_auto_ref_req           => cntrl0_auto_ref_req,
			  cntrl0_user_cmd_ack           => cntrl0_user_cmd_ack,
			  cntrl0_user_command_register  => cntrl0_user_command_register,
			  cntrl0_clk_tb                 => cntrl0_clk_tb,
			  cntrl0_clk90_tb               => cntrl0_clk90_tb,
			  cntrl0_sys_rst_tb             => cntrl0_sys_rst_tb,
			  cntrl0_sys_rst90_tb           => cntrl0_sys_rst90_tb,
			  cntrl0_sys_rst180_tb          => cntrl0_sys_rst180_tb,
			  cntrl0_user_data_mask         => cntrl0_user_data_mask,
			  cntrl0_user_output_data       => cntrl0_user_output_data,
			  cntrl0_user_input_data        => cntrl0_user_input_data,
			  cntrl0_user_input_address     => cntrl0_user_input_address,
			  clk_int                       => clk_int,
			  clk90_int                     => clk90_int,
			  dcm_lock                      => dcm_lock,
			  cntrl0_ddr_dqs                => cntrl0_ddr_dqs,
			  cntrl0_ddr_ck                 => cntrl0_ddr_ck,
			  cntrl0_ddr_ck_n               => cntrl0_ddr_ck_n
		);
end Behavioral;

