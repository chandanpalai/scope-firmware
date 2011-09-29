--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   20:03:50 09/22/2011
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
USE ieee.std_logic_unsigned.ALL;
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
          MCLK : IN  std_logic;
          RXA : IN  std_logic;
          TXA : OUT  std_logic;
          RXB : IN  std_logic;
          TXB : OUT  std_logic;
          cntrl0_ddr_dq : INOUT  std_logic_vector(7 downto 0);
          cntrl0_ddr_dqs : INOUT  std_logic_vector(0 downto 0);
          cntrl0_ddr_a : OUT  std_logic_vector(12 downto 0);
          cntrl0_ddr_ba : OUT  std_logic_vector(1 downto 0);
          cntrl0_ddr_cke : OUT  std_logic;
          cntrl0_ddr_cs_n : OUT  std_logic;
          cntrl0_ddr_ras_n : OUT  std_logic;
          cntrl0_ddr_cas_n : OUT  std_logic;
          cntrl0_ddr_we_n : OUT  std_logic;
          cntrl0_ddr_dm : OUT  std_logic_vector(0 downto 0);
          cntrl0_ddr_ck : OUT  std_logic_vector(0 downto 0);
          cntrl0_ddr_ck_n : OUT  std_logic_vector(0 downto 0)
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
  signal RXA : std_logic := '0';
  signal RXB : std_logic := '0';

  --BiDirs
  signal CYFD : std_logic_vector(15 downto 0);
  signal cntrl0_ddr_dq : std_logic_vector(7 downto 0);
  signal cntrl0_ddr_dqs : std_logic_vector(0 downto 0);

  --Outputs
  signal ADCCLK : std_logic;
  signal ADCPD : std_logic;
  signal ADCOE : std_logic;
  signal CYFIFOADR : std_logic_vector(1 downto 0);
  signal CYSLOE : std_logic;
  signal CYSLWR : std_logic;
  signal CYSLRD : std_logic;
  signal CYPKTEND : std_logic;
  signal TXA : std_logic;
  signal TXB : std_logic;
  signal cntrl0_ddr_a : std_logic_vector(12 downto 0);
  signal cntrl0_ddr_ba : std_logic_vector(1 downto 0);
  signal cntrl0_ddr_cke : std_logic;
  signal cntrl0_ddr_cs_n : std_logic;
  signal cntrl0_ddr_ras_n : std_logic;
  signal cntrl0_ddr_cas_n : std_logic;
  signal cntrl0_ddr_we_n : std_logic;
  signal cntrl0_ddr_dm : std_logic_vector(0 downto 0);
  signal cntrl0_ddr_ck : std_logic_vector(0 downto 0);
  signal cntrl0_ddr_ck_n : std_logic_vector(0 downto 0);

  -- Clock period definitions
  constant CYIFCLK_period : time := 20.8 ns;
  constant MCLK_period : time := 30 ns;

  constant DCMLCK_period : time := 100 ns;

  -- ADC Test data
  signal adcdata : unsigned(7 downto 0);


  -- FX2 Data
  constant OUTEP : STD_LOGIC_VECTOR(1 downto 0) := "01";       --EP4
  constant INEPADC : STD_LOGIC_VECTOR(1 downto 0) := "10";     --EP6
  constant INEPCFG : STD_LOGIC_VECTOR(1 downto 0) := "11";     --EP8

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
                       MCLK => MCLK,
                       RXA => RXA,
                       TXA => TXA,
                       RXB => RXB,
                       TXB => TXB,
                       cntrl0_ddr_dq => cntrl0_ddr_dq,
                       cntrl0_ddr_dqs => cntrl0_ddr_dqs,
                       cntrl0_ddr_a => cntrl0_ddr_a,
                       cntrl0_ddr_ba => cntrl0_ddr_ba,
                       cntrl0_ddr_cke => cntrl0_ddr_cke,
                       cntrl0_ddr_cs_n => cntrl0_ddr_cs_n,
                       cntrl0_ddr_ras_n => cntrl0_ddr_ras_n,
                       cntrl0_ddr_cas_n => cntrl0_ddr_cas_n,
                       cntrl0_ddr_we_n => cntrl0_ddr_we_n,
                       cntrl0_ddr_dm => cntrl0_ddr_dm,
                       cntrl0_ddr_ck => cntrl0_ddr_ck,
                       cntrl0_ddr_ck_n => cntrl0_ddr_ck_n
                     );

  -- Clock process definitions
  CYIFCLK_process :process
  begin
    CYIFCLK <= '0';
    wait for CYIFCLK_period/2;
    CYIFCLK <= '1';
    wait for CYIFCLK_period/2;
  end process;

  MCLK_process :process
  begin
    MCLK <= '0';
    wait for MCLK_period/2;
    MCLK <= '1';
    wait for MCLK_period/2;
  end process;

  -- ADC process
  adc_proc: process
  begin
    -- Define the inital values
    ADCDA <= x"00";
    ADCDB <= x"00";

    -- Let the DCM's lock on
    wait for DCMlck_period;

    for i in 0 to 1000 loop
      if ADCCLK'event and ADCCLK = '1' then
        ADCDA <= std_logic_vector(adcdata * 67);
        ADCDB <= std_logic_vector(adcdata * 31);
      end if;
    end loop;

    wait;
  end process;

  -- FX2 process
  fx2_proc: process
  begin
    -- Define the inital values
    CYFLAGA <= '0';
    CYFLAGB <= '1';
    CYFLAGC <= '1';
    CYFD <= "ZZZZZZZZZZZZZZZZ";

    -- Let the DCM's lock on
    wait for DCMlck_period;

    -- Send the CONFIG stream
    CYFLAGA <= '1';
    wait until CYFIFOADR = OUTEP;

    wait until CYSLRD = '0'; --CFGCHNL
    CYFD <= x"02AF";
    wait until CYSLRD = '1';
    wait until CYSLRD = '0';
    CYFD <= x"0308";
    wait until CYSLRD = '1';

    wait until CYSLRD = '0'; --CFGCLK
    CYFD <= x"02AF";
    wait until CYSLRD = '1';
    wait until CYSLRD = '0';
    CYFD <= x"F004";
    wait until CYSLRD = '1';
    wait until CYSLRD = '0';
    CYFD <= x"02AF";
    wait until CYSLRD = '1';
    wait until CYSLRD = '0';
    CYFD <= x"0006";
    wait until CYSLRD = '1';

    wait until CYSLRD = '0'; --PD
    CYFD <= x"02AF";
    wait until CYSLRD = '1';
    wait until CYSLRD = '0';
    CYFD <= x"0002";
    wait until CYSLRD = '1';


    wait;
  end process;

  -- IBA process
  iba_proc: process
  begin
    -- Define the initial values
    RXA <= '1';

    -- Let the DCM's lock on
    wait for DCMlck_period;

    wait;
  end process;

  -- IBB process
  ibb_proc: process
  begin
    -- Define the initial values
    RXB <= '1';

    -- Let the DCM's lock on
    wait for DCMlck_period;

    wait;
  end process;

  -- TODO: integrate ddrbuffer into this
END;
