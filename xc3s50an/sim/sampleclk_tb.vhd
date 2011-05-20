--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:49:43 11/18/2010
-- Design Name:   
-- Module Name:   /home/ali/Dropbox/Active/Electronics/scope/firmware/fpga/sampleclk_tb.vhd
-- Project Name:  fpga
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sampleclk
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
 
ENTITY sampleclk_tb IS
END sampleclk_tb;
 
ARCHITECTURE behavior OF sampleclk_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sampleclk
    PORT(
         CLKIN : IN  std_logic;
         sel : IN  std_logic_vector(2 downto 0);
         CLK : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLKIN : std_logic := '0';
   signal sel : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal CLK : std_logic;

   -- Clock period definitions
   constant CLKIN_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sampleclk PORT MAP (
          CLKIN => CLKIN,
          sel => sel,
          CLK => CLK
        );

   -- Clock process definitions
   CLKIN_process :process
   begin
		CLKIN <= '0';
		wait for CLKIN_period/2;
		CLKIN <= '1';
		wait for CLKIN_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 200 ns;
	  sel <= "001";
	  wait for 200 ns;
	  sel <= "010";
	  wait for 200 ns;
	  sel <= "011";
	  wait for 200 ns;
	  sel <= "100";
	  wait for 500 ns;
	  sel <= "101";
	  wait for 1 us;
	  sel <= "110";
	  wait for 2 us;
	  sel <= "111";
	  wait for 4 us;


      -- insert stimulus here 

      wait;
   end process;

END;
