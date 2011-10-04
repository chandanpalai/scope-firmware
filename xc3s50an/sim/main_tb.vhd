--------------------------------------------------------------------------------
-- Engineer: Ali Lown
-- Module Name:   /home/ali/Projects/Active/cur/usbscope/fw/xc3s50an/sim/main_tb.vhd
-- Project Name:  scope
-- Target Device: xc3s50a(n)
-- Description: Top-level full simulations for the scope
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

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

  --Constants
  constant CONST_MAGIC : std_logic_vector(7 downto 0) := x"AF";
  constant CONST_DEST_SCOPE : std_logic_vector(7 downto 0) := "00000001";
  constant CONST_DEST_ADC   : std_logic_vector(7 downto 0) := "00000010";
  constant CONST_DEST_IBA   : std_logic_vector(7 downto 0) := "00010000";
  constant CONST_DEST_IBB   : std_logic_vector(7 downto 0) := "00010001";

  constant CONST_REG_IB     : std_logic_vector(6 downto 0) := "0000001";

  constant CONST_REG_PD     : std_logic_vector(6 downto 0) := "0000001";
  constant CONST_REG_CLKL   : std_logic_vector(6 downto 0) := "0000010";
  constant CONST_REG_CLKH   : std_logic_vector(6 downto 0) := "0000011";
  constant CONST_REG_CHNL   : std_logic_vector(6 downto 0) := "0000100";

  constant CONST_REG_RELAY  : std_logic_vector(6 downto 0) := "0000001";
  constant CONST_REG_MUX0   : std_logic_vector(6 downto 0) := "0010000";

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

  constant UARTCLK_period : time := 800 ns;

  -- UART Test data
  signal uartclk : std_logic := '0';

  -- ADC Test data
  signal adcdataa : std_logic_vector(7 downto 0) := x"01";
  signal adcdatab : std_logic_vector(7 downto 0) := x"02";

  -- FX2 Data
  constant OUTEP : STD_LOGIC_VECTOR(1 downto 0) := "01";       --EP4
  constant INEPADC : STD_LOGIC_VECTOR(1 downto 0) := "10";     --EP6
  constant INEPCFG : STD_LOGIC_VECTOR(1 downto 0) := "11";     --EP8

  -- Useful Functions
  procedure hostoutfx2(constant dest : in std_logic_vector(7 downto 0); constant rnw : in std_logic; constant reg : in std_logic_vector(6 downto 0); constant value : in std_logic_vector(7 downto 0); signal slrd : in std_logic; signal fd : inout std_logic_vector(15 downto 0)) is
  begin
    wait until slrd = '0';
    fd(7 downto 0) <= CONST_MAGIC;
    fd(15 downto 8) <= dest;
    wait until slrd = '1';

    wait until slrd = '0';
    fd(0) <= rnw;
    fd(7 downto 1) <= reg;
    fd(15 downto 8) <= value;
    wait until slrd = '1';
  end hostoutfx2;

  procedure ibin(constant rnw : in std_logic; constant reg : in std_logic_vector(6 downto 0); constant value : in std_logic_vector(7 downto 0); signal clk : in std_logic; signal rx : out std_logic) is
    variable i,j : integer;
    variable packet : std_logic_vector(23 downto 0);
  begin
     packet(7 downto 0) := CONST_MAGIC;
     packet(8) := rnw;
     packet(15 downto 9) := reg;
     packet(23 downto 16) := value;

     wait until clk = '0';
     for i in 0 to 2 loop
       wait until clk = '1';
       rx <= '0';
       wait until clk = '0';

       for j in 0 to 7 loop
         wait until clk = '1';
         rx <= packet(8*i+j);
         wait until clk = '0';
       end loop;

       wait until clk = '1';
       rx <= '1';
     end loop;
  end ibin;

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

  UARTCLK_process :process
  begin
    uartclk <= '0';
    wait for UARTCLK_period/2;
    uartclk <= '1';
    wait for UARTCLK_period/2;
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
      wait until ADCCLK = '1';
      if ADCPD = '0' and ADCOE = '0' then
        ADCDA <= adcdataa;
        ADCDB <= adcdatab;
        adcdataa <= adcdatab + '1';
        adcdatab <= adcdataa;
      end if;
      wait until ADCCLK = '0';
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

    hostoutfx2(CONST_DEST_ADC, '0', CONST_REG_CHNL, x"03", CYSLRD, CYFD);
    hostoutfx2(CONST_DEST_ADC, '0', CONST_REG_CLKL, x"F0", CYSLRD, CYFD);
    hostoutfx2(CONST_DEST_ADC, '0', CONST_REG_CLKH, x"00", CYSLRD, CYFD);
    hostoutfx2(CONST_DEST_ADC, '0', CONST_REG_PD,   x"00", CYSLRD, CYFD);

    wait for 20 us;

    CYFLAGA <= '1';

    hostoutfx2(CONST_DEST_ADC, '0', CONST_REG_PD,   x"01", CYSLRD, CYFD);

    CYFD <= "ZZZZZZZZZZZZZZZZ";
    CYFLAGA <= '0';

    wait;
  end process;

  -- IBA process
  iba_proc: process
  begin
    -- Define the initial values
    RXA <= '1';

    -- Let the DCM's lock on
    wait for DCMlck_period;

    -- Wait for a sensible time
    wait for 25 us;

    -- Send HELO as Single-ended probe
    for i in 1 to 1 loop
      ibin('0', "0000000", x"A0", uartclk, RXA);
    end loop;

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
