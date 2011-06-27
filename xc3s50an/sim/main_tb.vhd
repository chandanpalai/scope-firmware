--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:54:01 06/24/2011
-- Design Name:   
-- Module Name:   /home/ali/Projects/Active/cur/usbscope/fw/xc3s50an/sim/main_tb.vhd
-- Project Name:  scope
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: main
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
 
ENTITY main_tb IS
END main_tb;
 
ARCHITECTURE behavior OF main_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT main
    PORT(
         ADCDA : IN  std_logic_vector(7 downto 0);
         ADCDB : IN  std_logic_vector(7 downto 0);
         ADCCLK : OUT  std_logic;
         ADCPD : OUT  std_logic;
         ADCOE : OUT  std_logic;
         CYFD : INOUT  std_logic_vector(15 downto 0);
         CYIFCLK : IN  std_logic;
         CYFIFOADR : OUT  std_logic_vector(1 downto 0);
         CYSLOE : OUT  std_logic;
         CYSLWR : OUT  std_logic;
         CYSLRD : OUT  std_logic;
         CYFLAGA : IN  std_logic;
         CYFLAGB : IN  std_logic;
         CYFLAGC : IN  std_logic;
         CYPKTEND : OUT  std_logic;
         MCLK : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal ADCDA : std_logic_vector(7 downto 0) := (others => '0');
   signal ADCDB : std_logic_vector(7 downto 0) := (others => '0');
   signal CYIFCLK : std_logic := '0';
   signal CYFLAGA : std_logic := '0';
   signal CYFLAGB : std_logic := '0';
   signal CYFLAGC : std_logic := '0';
   signal MCLK : std_logic := '0';

	--BiDirs
   signal CYFD : std_logic_vector(15 downto 0);

 	--Outputs
   signal ADCCLK : std_logic;
   signal ADCPD : std_logic;
   signal ADCOE : std_logic;
   signal CYFIFOADR : std_logic_vector(1 downto 0);
   signal CYSLOE : std_logic;
   signal CYSLWR : std_logic;
   signal CYSLRD : std_logic;
   signal CYPKTEND : std_logic;

   -- Clock period definitions
   constant MCLK_period : time := 30 ns;
   constant IFCLK_period : time := 20 ns;

   signal clken : std_logic;

   signal testi : unsigned(7 downto 0);
   signal testdata : std_logic_vector(7 downto 0) := "00000000";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: main PORT MAP (
          ADCDA => ADCDA,
          ADCDB => ADCDB,
          ADCCLK => ADCCLK,
          ADCPD => ADCPD,
          ADCOE => ADCOE,
          CYFD => CYFD,
          CYIFCLK => CYIFCLK,
          CYFIFOADR => CYFIFOADR,
          CYSLOE => CYSLOE,
          CYSLWR => CYSLWR,
          CYSLRD => CYSLRD,
          CYFLAGA => CYFLAGA,
          CYFLAGB => CYFLAGB,
          CYFLAGC => CYFLAGC,
          CYPKTEND => CYPKTEND,
          MCLK => MCLK
        );

   -- Clock process definitions
   MCLK_process :process
   begin
		MCLK <= '0';
		wait for MCLK_period/2;
		MCLK <= '1';
		wait for MCLK_period/2;
   end process;

   IFCLK_process :process
   begin
        if clken = '1' then
            CYIFCLK <= '0';
        end if;
		wait for IFCLK_period/2;
        if clken = '1' then
            CYIFCLK <= '1';
        end if;
		wait for IFCLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
           clken <= '0'; --simulate fx2 starting IFCLK afterwards
           wait for 1 us;
           clken <= '1';

		   CYFD <= "ZZZZZZZZZZZZZZZZ";
		   CYFLAGA <= '0';
		   CYFLAGB <= '0';
		   CYFLAGC <= '1';

		   wait for 100 ns;

		   CYFLAGA <= '1';
           wait until CYSLOE = '0';
           CYFD <= "0000000000000000";
           wait until CYSLRD = '0';
           CYFD <= "0011110000111100";
           wait until CYSLRD = '1';
           wait until CYSLRD = '0';
           CYFD <= "0000001100000011";
           wait until CYSLRD = '1';
           wait until CYSLRD = '0';
           CYFD <= "1111000010101010";
           wait until CYSLRD = '1';
           CYFLAGA <= '0';
		   CYFD <= "ZZZZZZZZZZZZZZZZ";

		   wait;
   end process;
   
   adc_proc: process
   begin
		   for testi in 0 to 100 loop
				   wait until ADCCLK = '1';
				   ADCDA <= testdata;
				   ADCDB <= not testdata;
				   wait until ADCCLK = '0';
				   testdata <= std_logic_vector(unsigned(testdata) + 1);
		   end loop;

		   wait;
   end process;

END;
