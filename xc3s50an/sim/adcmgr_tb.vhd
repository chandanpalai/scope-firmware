--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:08:13 11/19/2010
-- Design Name:   
-- Module Name:   /home/ali/Dropbox/Active/Electronics/scope/firmware/fpga/adcmgr_tb.vhd
-- Project Name:  fpga
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: adcmgr
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
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY adcmgr_tb IS
END adcmgr_tb;
 
ARCHITECTURE behavior OF adcmgr_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT adcmgr
    PORT(
         D0 : IN  std_logic_vector(7 downto 0);
         D1 : IN  std_logic_vector(7 downto 0);
         SMPLCLK : IN  std_logic;
         SEL : IN  std_logic_vector(1 downto 0);
         ZZ : IN  std_logic;
         CLK : OUT  std_logic;
         OE : OUT  std_logic;
         PD : OUT  std_logic;
         DATA : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal D0 : std_logic_vector(7 downto 0) := (others => '0');
   signal D1 : std_logic_vector(7 downto 0) := (others => '0');
   signal SMPLCLK : std_logic := '0';
   signal SEL : std_logic_vector(1 downto 0) := (others => '0');
   signal ZZ : std_logic := '0';

 	--Outputs
   signal CLK : std_logic;
   signal OE : std_logic;
   signal PD : std_logic;
   signal DATA : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant SMPLCLK_period : time := 10 ns;

   signal i0 : std_logic_vector(7 downto 0) := "00000000";
   signal i1 : std_logic_vector(7 downto 0) := "11111111";

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: adcmgr PORT MAP (
          D0 => D0,
          D1 => D1,
          SMPLCLK => SMPLCLK,
          SEL => SEL,
          ZZ => ZZ,
          CLK => CLK,
          OE => OE,
          PD => PD,
          DATA => DATA
        );

   -- Clock process definitions
   SMPLCLK_process :process
   begin
		SMPLCLK <= '0';
		wait for SMPLCLK_period/2;
		SMPLCLK <= '1';
		wait for SMPLCLK_period/2;
   end process;


 
   -- Stimulus process
   stim_proc: process
   begin		
		   SEL <= "00";
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;

		   SEL <= "01";
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;

		   SEL <= "10";
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;

		   SEL <= "11";
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;

		   ZZ <= '1';
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;

		   ZZ <= '0';
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
		   D0 <= i0;
		   i0 <= i0 + 1;
		   D1 <= i1;
		   i1 <= i1 - 1;
		   wait for 10 ns;
      wait;
   end process;

END;
