--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:13:11 03/09/2011
-- Design Name:   
-- Module Name:   /home/ali/Projects/Active/Electronics/scope/sw/fw/fpga/inrouter_tb.vhd
-- Project Name:  fpga
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: inrouter
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
USE ieee.numeric_std.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY inrouter_tb IS
END inrouter_tb;
 
ARCHITECTURE behavior OF inrouter_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT inrouter
    PORT(
         CYDATA_IN : IN  std_logic_vector(15 downto 0);
         CYINT : IN  std_logic;
         CYDATA_OUT : OUT  std_logic_vector(15 downto 0);
         CYDATA_OUT_SEL : OUT  std_logic;
         CYCLK : IN  std_logic;
         MEMDATA : IN  std_logic_vector(15 downto 0);
         MEMCLK : IN  std_logic;
         MEMCTRL : OUT  std_logic_vector(2 downto 0);
         MEMCTRL_SEL : OUT  std_logic;
         RESET : IN  std_logic;
         STOP : IN  std_logic;
         STOPPED : OUT  std_logic;
         STATE_CLK : IN  std_logic;
         PROCESSINT : OUT  std_logic;
         PROCESSDATA : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CYDATA_IN : std_logic_vector(15 downto 0) := (others => '0');
   signal CYINT : std_logic := '0';
   signal CYCLK : std_logic := '0';
   signal MEMDATA : std_logic_vector(15 downto 0) := (others => '0');
   signal MEMCLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal STOP : std_logic := '0';
   signal STATE_CLK : std_logic := '0';

 	--Outputs
   signal CYDATA_OUT : std_logic_vector(15 downto 0);
   signal CYDATA_OUT_SEL : std_logic;
   signal MEMCTRL : std_logic_vector(2 downto 0);
   signal MEMCTRL_SEL : std_logic;
   signal STOPPED : std_logic;
   signal PROCESSINT : std_logic;
   signal PROCESSDATA : std_logic_vector(63 downto 0);

   -- Clock period definitions
   constant CYCLK_period : time := 22.5 ns;
   constant MEMCLK_period : time := 7.5 ns;
   constant STATE_CLK_period : time := 22.5 ns;

   signal data : std_logic_vector(15 downto 0) := "0000000000000000";
   signal i : std_logic_vector(7 downto 0) := "00000000";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: inrouter PORT MAP (
          CYDATA_IN => CYDATA_IN,
          CYINT => CYINT,
          CYDATA_OUT => CYDATA_OUT,
          CYDATA_OUT_SEL => CYDATA_OUT_SEL,
          CYCLK => CYCLK,
          MEMDATA => MEMDATA,
          MEMCLK => MEMCLK,
          MEMCTRL => MEMCTRL,
          MEMCTRL_SEL => MEMCTRL_SEL,
          RESET => RESET,
          STOP => STOP,
          STOPPED => STOPPED,
          STATE_CLK => STATE_CLK,
          PROCESSINT => PROCESSINT,
          PROCESSDATA => PROCESSDATA
        );

   -- Clock process definitions
   CYCLK_process :process
   begin
		CYCLK <= '0';
		wait for CYCLK_period/2;
		CYCLK <= '1';
		wait for CYCLK_period/2;
   end process;
 
   MEMCLK_process :process
   begin
		MEMCLK <= '0';
		wait for MEMCLK_period/2;
		MEMCLK <= '1';
		wait for MEMCLK_period/2;
   end process;
 
   STATE_CLK_process :process
   begin
		STATE_CLK <= '0';
		wait for STATE_CLK_period/2;
		STATE_CLK <= '1';
		wait for STATE_CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		   wait for CYCLK_period/2;
		   RESET <= '1';
		   wait for CYCLK_period;
		   RESET <= '0';

		   CYINT <= '1';
		   for i in 0 to 1024 loop
				   CYDATA_IN <= data;
				   data <= data + 1;
				   wait for CYCLK_period;
		   end loop;
		   CYINT <= '0';

      wait;
   end process;

END;
