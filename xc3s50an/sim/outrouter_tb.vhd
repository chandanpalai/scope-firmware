--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:00:12 03/08/2011
-- Design Name:   
-- Module Name:   /home/ali/Projects/Active/Electronics/scope/sw/fw/fpga/outrouter_tb.vhd
-- Project Name:  fpga
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: outrouter
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
 
ENTITY outrouter_tb IS
END outrouter_tb;
 
ARCHITECTURE behavior OF outrouter_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT outrouter
    PORT(
         ADCCLK : IN  std_logic;
         ADCDATA : IN  std_logic_vector(15 downto 0);
         CYCLK : IN  std_logic;
         CYWRITE_STROBE : OUT  std_logic;
         CYDATA : OUT  std_logic_vector(15 downto 0);
         CYFULL : IN  std_logic;
         MEMCLK : IN  std_logic;
         MEMCTRL_BURST_DONE : OUT  std_logic;
         MEMCTRL : OUT  std_logic_vector(2 downto 0);
         MEMDATAMASK : OUT  std_logic_vector(1 downto 0);
         MEMDATA : OUT  std_logic_vector(15 downto 0);
         MEMADDR : OUT  std_logic_vector(25 downto 0);
         STOP : IN  std_logic;
         STOPPED : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal ADCCLK : std_logic := '0';
   signal ADCDATA : std_logic_vector(15 downto 0) := (others => '0');
   signal CYCLK : std_logic := '0';
   signal CYFULL : std_logic := '0';
   signal MEMCLK : std_logic := '0';
   signal STOP : std_logic := '0';

 	--Outputs
   signal CYWRITE_STROBE : std_logic;
   signal CYDATA : std_logic_vector(15 downto 0);
   signal MEMCTRL_BURST_DONE : std_logic;
   signal MEMCTRL : std_logic_vector(2 downto 0);
   signal MEMDATAMASK : std_logic_vector(1 downto 0);
   signal MEMDATA : std_logic_vector(15 downto 0);
   signal MEMADDR : std_logic_vector(25 downto 0);
   signal STOPPED : std_logic;

   -- Clock period definitions
   constant ADCCLK_period : time := 22.5 ns;
   constant CYCLK_period : time := 22.5 ns;
   constant MEMCLK_period : time := 7.5 ns;


   --Vars
   signal data : std_logic_vector(15 downto 0) := "0000000000000000";
   signal i : std_logic_vector(7 downto 0) 	:= "00000000";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: outrouter PORT MAP (
          ADCCLK => ADCCLK,
          ADCDATA => ADCDATA,
          CYCLK => CYCLK,
          CYWRITE_STROBE => CYWRITE_STROBE,
          CYDATA => CYDATA,
          CYFULL => CYFULL,
          MEMCLK => MEMCLK,
          MEMCTRL_BURST_DONE => MEMCTRL_BURST_DONE,
          MEMCTRL => MEMCTRL,
          MEMDATAMASK => MEMDATAMASK,
          MEMDATA => MEMDATA,
          MEMADDR => MEMADDR,
          STOP => STOP,
          STOPPED => STOPPED
        );

   -- Clock process definitions
   ADCCLK_process :process
   begin
		ADCCLK <= '0';
		wait for ADCCLK_period/2;
		ADCCLK <= '1';
		wait for ADCCLK_period/2;
   end process;
 
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
 

   -- Stimulus process
   stim_proc: process
   begin		

		   wait for ADCClK_period/2;

		   for i in 0 to 1024 loop
				   ADCDATA <= data;
				   data <= data + 1;
				   wait for ADCCLK_period;
		   end loop;

		   CYFULL <= '1';
		   for i in 0 to 8 loop
				   ADCDATA <= data;
				   data <= data + 1;
				   wait for ADCCLK_period;
		   end loop;
		   
		   CYFULL <= '0';
		   for i in 0 to 1024 loop
				   ADCDATA <= data;
				   data <= data + 1;
				   wait for ADCCLK_period;
		   end loop;

      wait;
   end process;

END;
