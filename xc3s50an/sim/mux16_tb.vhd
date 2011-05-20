--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:02:46 03/07/2011
-- Design Name:   
-- Module Name:   /home/ali/Projects/Active/Electronics/scope/sw/fw/fpga/mux16_tb.vhd
-- Project Name:  fpga
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mux16
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
USE ieee.numeric_std.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
 
ENTITY mux16_tb IS
END mux16_tb;
 
ARCHITECTURE behavior OF mux16_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mux16
    PORT(
         D0 : IN  std_logic_vector(15 downto 0);
         D1 : IN  std_logic_vector(15 downto 0);
         SEL : IN  std_logic;
         D : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal D0 : std_logic_vector(15 downto 0) := (others => '0');
   signal D1 : std_logic_vector(15 downto 0) := (others => '0');
   signal SEL : std_logic := '0';

 	--Outputs
   signal D : std_logic_vector(15 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 


   signal curd1 : std_logic_vector(15 downto 0) := "0000000000000000";
   signal curd2 : std_logic_vector(15 downto 0) := "1111111111111111";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mux16 PORT MAP (
          D0 => D0,
          D1 => D1,
          SEL => SEL,
          D => D
        );


   -- Stimulus process
   stim_proc: process
   begin		
	  SEL <= '0';
	  D0 <= curd1;
	  wait for 10 ns;
	  curd1 <= curd1 + 1;

	  SEL <= '1';
	  D1 <= curd2;
	  wait for 10 ns;
	  curd2 <= curd2 + 1;
	  D0 <= curd1;
	  wait for 10 ns;
	  curd1 <= curd1 + 1;

	  SEL <= '0';
	  D0 <= curd1;
	  wait for 10 ns;
	  curd1 <= curd1 + 1;

      -- insert stimulus here 

      wait;
   end process;

END;
