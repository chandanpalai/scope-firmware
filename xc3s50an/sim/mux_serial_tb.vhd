--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:44:59 01/25/2011
-- Design Name:   
-- Module Name:   /home/ali/Dropbox/Active/Electronics/scope/firmware/fpga/mux_serial_tb.vhd
-- Project Name:  fpga
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mux_serial
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY mux_serial_tb IS
END mux_serial_tb;
 
ARCHITECTURE behavior OF mux_serial_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mux_serial
    PORT(
         LOAD : IN  std_logic;
         EN : IN  std_logic;
         CLKOUT : IN  std_logic;
         CTRL : IN  std_logic_vector(15 downto 0);
         CLK : OUT  std_logic;
         CS : OUT  std_logic;
         DATA : OUT  std_logic;
         DONE : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal LOAD : std_logic := '0';
   signal EN : std_logic := '0';
   signal CLKOUT : std_logic := '0';
   signal CTRL : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal CLK : std_logic;
   signal CS : std_logic;
   signal DATA : std_logic;
   signal DONE : std_logic;

   -- Clock period definitions
   constant CLKOUT_period : time := 10 ns;
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mux_serial PORT MAP (
          LOAD => LOAD,
          EN => EN,
          CLKOUT => CLKOUT,
          CTRL => CTRL,
          CLK => CLK,
          CS => CS,
          DATA => DATA,
          DONE => DONE
        );

   -- Clock process definitions
   CLKOUT_process :process
   begin
		CLKOUT <= '0';
		wait for CLKOUT_period/2;
		CLKOUT <= '1';
		wait for CLKOUT_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin		
		   EN <= '0';

		   CTRL <= "0101010101010101";
		   LOAD <= '1';
		   wait for 10 ns;
		   LOAD <= '0';

		   EN <= '1';
		   wait for 500 ns;

		   EN <= '0';

      wait;
   end process;

END;
