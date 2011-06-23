--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:18:32 06/23/2011
-- Design Name:   
-- Module Name:   /home/ali/Projects/Active/cur/usbscope/fw/xc3s50an/sim/think_tb.vhd
-- Project Name:  scope
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: think
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
 
ENTITY think_tb IS
END think_tb;
 
ARCHITECTURE behavior OF think_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT think
    PORT(
         DATAIN : IN  std_logic_vector(15 downto 0);
         DATACLK : IN  std_logic;

         RESET : IN std_logic;
         CLKIF : IN std_logic;

         ZZ : OUT  std_logic;
         CFGCLK : OUT  std_logic_vector(7 downto 0);
         CFGCHNL : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal DATAIN : std_logic_vector(15 downto 0) := (others => '0');
   signal DATACLK : std_logic := '0';

   signal RESET : std_logic := '0';
   signal CLKIF: std_logic := '0';

 	--Outputs
   signal ZZ : std_logic;
   signal CFGCLK : std_logic_vector(7 downto 0);
   signal CFGCHNL : std_logic_vector(1 downto 0);

   constant CLKIF_period : time := 20 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: think PORT MAP (
          DATAIN => DATAIN,
          DATACLK => DATACLK,
          RESET => RESET,
          CLKIF => CLKIF,
          ZZ => ZZ,
          CFGCLK => CFGCLK,
          CFGCHNL => CFGCHNL
        );

   --clock stim
   CLKIF_process : process
   begin
       CLKIF <= '0';
       wait for CLKIF_period/2;
       CLKIF <= '1';
       wait for CLKIF_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
       RESET <= '1';
       wait for 100 ns;
       RESET <= '0';

       DATAIN <= "0011110000111100";
       DATACLK <= '1';
       wait until CLKIF = '1';
       DATACLK <= '0';
       wait until CLKIF = '0';
       DATAIN <= "0000000000000111";
       DATACLK <= '1';
       wait until CLKIF = '1';
       DATACLK <= '0';
       wait until CLKIF = '0';
       DATAIN <= "1111000010101010";
       DATACLK <= '1';
       wait until CLKIF = '1';
       DATACLK <= '0';
       wait until CLKIF = '0';


       wait;
   end process;

END;
