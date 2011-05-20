--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:43:05 02/27/2011
-- Design Name:   
-- Module Name:   /home/ali/Projects/Active/Electronics/sw/fw/fpga/div10_tb.vhd
-- Project Name:  fpga
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: div10
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
 
ENTITY div10_tb IS
END div10_tb;
 
ARCHITECTURE behavior OF div10_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT div10
    PORT(
         CLKIN : IN  std_logic;
         CLKOUT : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLKIN : std_logic := '0';

 	--Outputs
   signal CLKOUT : std_logic;

   -- Clock period definitions
   constant CLKIN_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: div10 PORT MAP (
          CLKIN => CLKIN,
          CLKOUT => CLKOUT
        );

   -- Clock process definitions
   CLKIN_process :process
   begin
		CLKIN <= '1';
		wait for CLKIN_period/2;
		CLKIN <= '0';
		wait for CLKIN_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.

      wait for CLKIN_period*100;

      -- insert stimulus here 

      wait;
   end process;

END;
