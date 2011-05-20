--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:25:14 11/20/2010
-- Design Name:   
-- Module Name:   /home/ali/Dropbox/Active/Electronics/scope/firmware/fpga/muxmgr_tb.vhd
-- Project Name:  fpga
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: muxmgr
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
 
ENTITY muxmgr_tb IS
END muxmgr_tb;
 
ARCHITECTURE behavior OF muxmgr_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT muxmgr
    PORT(
         MULTWARN : IN  std_logic_vector(1 downto 0);
         DIVWARN : IN  std_logic_vector(1 downto 0);
         DONE : IN  std_logic;
         LOAD : OUT  std_logic;
         ENOUT : OUT  std_logic;
         CTRL : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal MULTWARN : std_logic_vector(1 downto 0) := (others => '0');
   signal DIVWARN : std_logic_vector(1 downto 0) := (others => '0');
   signal DONE : std_logic := '0';

 	--Outputs
   signal LOAD : std_logic;
   signal ENOUT : std_logic;
   signal CTRL : std_logic_vector(15 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: muxmgr PORT MAP (
          MULTWARN => MULTWARN,
          DIVWARN => DIVWARN,
          DONE => DONE,
          LOAD => LOAD,
          ENOUT => ENOUT,
          CTRL => CTRL
        );

   -- Stimulus process
   stim_proc: process
   begin		
		   MULTWARN <= "11";
		   wait for 1 ns;
		   DONE <= '1';
		   wait for 9 ns;
		   MULTWARN <= "00";
		   DONE <= '0';
		   wait for 1 ns;
		   DONE <= '1';
		   wait for 9 ns;
		   MULTWARN <= "11";
      wait;
   end process;

END;
