--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:29:53 06/22/2011
-- Design Name:   
-- Module Name:   /home/ali/Projects/Active/cur/usbscope/fw/xc3s50an/sim/adc_tb.vhd
-- Project Name:  scope
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: adc
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
 
ENTITY adc_tb IS
END adc_tb;
 
ARCHITECTURE behavior OF adc_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT adc
    PORT(
         DA : IN  std_logic_vector(7 downto 0);
         DB : IN  std_logic_vector(7 downto 0);
         DATA : OUT  std_logic_vector(15 downto 0);
         DATAEN : OUT std_logic;

         ZZ : IN  std_logic;
         PD : OUT  std_logic;
         OE : OUT  std_logic;

         CLKSMPL : OUT  std_logic;
         CLKM : IN  std_logic;
         CFGCLK : IN  std_logic_vector(7 downto 0);
         CFGCHNL : IN  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal DA : std_logic_vector(7 downto 0) := (others => '0');
   signal DB : std_logic_vector(7 downto 0) := (others => '0');

   signal ZZ : std_logic := '0';

   signal CLKM : std_logic := '0';
   signal CFGCLK : std_logic_vector(7 downto 0) := (others => '0');
   signal CFGCHNL : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal DATA : std_logic_vector(15 downto 0);
   signal DATAEN : std_logic;

   signal PD : std_logic;
   signal OE : std_logic;

   signal CLKSMPL : std_logic;

   -- Clock period definitions
   constant CLKM_period : time := 5 ns; --200MHz


   signal testi : unsigned (7 downto 0);
   signal testdata : std_logic_vector(7 downto 0) := "00000000";
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: adc PORT MAP (
          DA => DA,
          DB => DB,
          DATA => DATA,
          DATAEN => DATAEN,
          ZZ => ZZ,
          PD => PD,
          OE => OE,
          CLKSMPL => CLKSMPL,
          CLKM => CLKM,
          CFGCLK => CFGCLK,
          CFGCHNL => CFGCHNL
        );

   -- Clock process definitions
   CLKM_process :process
   begin
		CLKM <= '0';
		wait for CLKM_period/2;
		CLKM <= '1';
		wait for CLKM_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
           CFGCLK <= "00000000";
           CFGCHNL <= "00";
           for testi in 0 to 10 loop
                   wait until CLKSMPL = '0';
                   DA <= testdata;
                   DB <= not testdata;
                   wait until CLKSMPL = '1';
                   testdata <= std_logic_vector(unsigned(testdata) + 1);
           end loop;

           CFGCHNL <= "01";
           for testi in 0 to 10 loop
                   wait until CLKSMPL = '0';
                   DA <= testdata;
                   DB <= not testdata;
                   wait until CLKSMPL = '1';
                   testdata <= std_logic_vector(unsigned(testdata) + 1);
           end loop;

           CFGCHNL <= "10";
           for testi in 0 to 10 loop
                   wait until CLKSMPL = '0';
                   DA <= testdata;
                   DB <= not testdata;
                   wait until CLKSMPL = '1';
                   testdata <= std_logic_vector(unsigned(testdata) + 1);
           end loop;

           CFGCHNL <= "11";
           for testi in 0 to 10 loop
                   wait until CLKSMPL = '0';
                   DA <= testdata;
                   DB <= not testdata;
                   wait until CLKSMPL = '1';
                   testdata <= std_logic_vector(unsigned(testdata) + 1);
           end loop;

           ZZ <= '1';
           for testi in 0 to 10 loop
                   wait for 10 ns;
                   testdata <= std_logic_vector(unsigned(testdata) + 1);
           end loop;

           ZZ <= '0';
           for testi in 0 to 10 loop
                   wait for 10 ns;
                   testdata <= std_logic_vector(unsigned(testdata) + 1);
           end loop;


           --new speed
           CFGCLK <= "10000000";
           CFGCHNL <= "00";
           for testi in 0 to 10 loop
                   wait until CLKSMPL = '0';
                   DA <= testdata;
                   DB <= not testdata;
                   wait until CLKSMPL = '1';
                   testdata <= std_logic_vector(unsigned(testdata) + 1);
           end loop;

           CFGCHNL <= "01";
           for testi in 0 to 10 loop
                   wait until CLKSMPL = '0';
                   DA <= testdata;
                   DB <= not testdata;
                   wait until CLKSMPL = '1';
                   testdata <= std_logic_vector(unsigned(testdata) + 1);
           end loop;

           CFGCHNL <= "10";
           for testi in 0 to 10 loop
                   wait until CLKSMPL = '0';
                   DA <= testdata;
                   DB <= not testdata;
                   wait until CLKSMPL = '1';
                   testdata <= std_logic_vector(unsigned(testdata) + 1);
           end loop;

           CFGCHNL <= "11";
           for testi in 0 to 10 loop
                   wait until CLKSMPL = '0';
                   DA <= testdata;
                   DB <= not testdata;
                   wait until CLKSMPL = '1';
                   testdata <= std_logic_vector(unsigned(testdata) + 1);
           end loop;

           ZZ <= '1';
           for testi in 0 to 10 loop
                   wait for 1 us;
                   testdata <= std_logic_vector(unsigned(testdata) + 1);
           end loop;

           ZZ <= '0';
           for testi in 0 to 10 loop
                   wait for 1 us;
                   testdata <= std_logic_vector(unsigned(testdata) + 1);
           end loop;

           wait;
   end process;

END;
