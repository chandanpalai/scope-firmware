--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:50:36 08/14/2011
-- Design Name:   
-- Module Name:   /home/ali/Projects/Active/cur/usbscope/fw/xc3s50an/sim/inputBoard_tb.vhd
-- Project Name:  scope
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: inputBoard
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
 
ENTITY inputBoard_tb IS
END inputBoard_tb;
 
ARCHITECTURE behavior OF inputBoard_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT inputBoard
    PORT(
         RESET : IN  std_logic;
         CLK : IN  std_logic;
         CFGIB : IN  std_logic_vector(15 downto 0);
         SAVE : IN  std_logic;
         ERR : OUT  std_logic;
         RX : IN  std_logic;
         TX : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal RESET : std_logic := '0';
   signal CLK : std_logic := '0';
   signal CFGIB : std_logic_vector(15 downto 0) := (others => '0');
   signal SAVE : std_logic := '0';
   signal RX : std_logic := '0';

 	--Outputs
   signal ERR : std_logic;
   signal TX : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 30 ns;


   signal i : integer;
   signal byte : std_logic_vector(7 downto 0);
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: inputBoard PORT MAP (
          RESET => RESET,
          CLK => CLK,
          CFGIB => CFGIB,
          SAVE => SAVE,
          ERR => ERR,
          RX => RX,
          TX => TX
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      RESET <= '1';
      wait for 100 ns;	
      RESET <= '0';
      wait for 900 ns;

      CFGIB <= x"ABCD";
      SAVE <= '1';
      wait for 30 ns;
      SAVE <= '0';

      wait;
   end process;

END;
