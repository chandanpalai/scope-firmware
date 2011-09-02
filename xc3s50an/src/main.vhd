--------------------------------------------------------------------------------
-- Engineer:       Ali Lown
--
-- Create Date:    08:49:11 06/24/2011
-- Module Name:    main - Behavioral
-- Project Name:   USB Digital Oscilloscope
-- Target Devices: xc3s50a(n)
-- Description:    Links the whole design together, but doesn't do a lot!
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
  Port ( ADCDA : in  std_logic_vector (7 downto 0);
         ADCDB : in  std_logic_vector (7 downto 0);
         ADCCLK : out  STD_LOGIC;
         ADCPD : out  STD_LOGIC;
         ADCOE : out  STD_LOGIC;
         CYFD : inout  std_logic_vector (15 downto 0);
         CYIFCLK : in  STD_LOGIC;
         CYFIFOADR : out  std_logic_vector (1 downto 0);
         CYSLOE : out  STD_LOGIC;
         CYSLWR : out  STD_LOGIC;
         CYSLRD : out  STD_LOGIC;
         CYFLAGA : in  STD_LOGIC;
         CYFLAGB : in  STD_LOGIC;
         CYFLAGC : in  STD_LOGIC;
         CYPKTEND : out STD_LOGIC;
         MCLK : in STD_LOGIC;
         RXA : in STD_LOGIC;
         TXA : out STD_LOGIC;
         RXB : in STD_LOGIC;
         TXB : out STD_LOGIC);
end main;

architecture Behavioral of main is
  COMPONENT adc
    PORT(
          DA : IN std_logic_vector(7 downto 0);
          DB : IN std_logic_vector(7 downto 0);
          ZZ : IN std_logic;
          CLKM : IN std_logic;
          CFGCLK : IN std_logic_vector(7 downto 0);
          CFGCHNL : IN std_logic_vector(1 downto 0);
          DATA : OUT std_logic_vector(15 downto 0);
          DATACLK : OUT std_logic;
          PD : OUT std_logic;
          OE : OUT std_logic;
          CLKSMPL : OUT std_logic
        );
  END COMPONENT;

  COMPONENT fx2
    PORT(
          ADCDATA : IN std_logic_vector(15 downto 0);
          ADCDATACLK : IN std_logic;

          CFGDATA : IN std_logic_vector(15 downto 0);
          CFGDATACLK : IN std_logic;

          OUTDATA : OUT std_logic_vector(15 downto 0);
          OUTDATACLK : OUT std_logic;

          CLKIF : IN std_logic;
          RESET : IN std_logic;

          FLAGA : IN std_logic;
          FLAGB : IN std_logic;
          FLAGC : IN std_logic;
          FD : INOUT std_logic_vector(15 downto 0);
          SLOE : OUT std_logic;
          SLRD : OUT std_logic;
          SLWR : OUT std_logic;
          FIFOADR : OUT std_logic_vector(1 downto 0);
          PKTEND : OUT std_logic
        );
  END COMPONENT;

  COMPONENT think
    PORT(
          DATAIN : IN std_logic_vector(15 downto 0);
          DATACLK : IN std_logic;

          RESET : IN std_logic;
          CLKIF : IN std_logic;
          ZZ : OUT std_logic;
          CFGCLK : OUT std_logic_vector(7 downto 0);
          CFGCHNL : OUT std_logic_vector(1 downto 0);

          CFGIBA : out STD_LOGIC_VECTOR(15 downto 0);
          CFGIBB : out STD_LOGIC_VECTOR(15 downto 0);
          SAVEA : out STD_LOGIC;
          SAVEB : out STD_LOGIC
        );
  END COMPONENT;

  COMPONENT maindcm
    PORT(
          CLKIN_IN : IN std_logic;
          CLKFX_OUT : OUT std_logic;
          CLKIN_IBUFG_OUT : OUT std_logic;
          CLK0_OUT : OUT std_logic;
          LOCKED_OUT : OUT std_logic
        );
  END COMPONENT;

  COMPONENT inputBoard
    PORT(
          RESET : IN std_logic;
          CLK : IN std_logic;
          BAUDCLK : IN std_logic;
          CFGIB : IN std_logic_vector(15 downto 0);
          SAVE : IN std_logic;
          DATAOUT : out std_logic_vector(15 downto 0);
          DATACLK : out std_logic;
          RX : IN std_logic;
          TX : OUT std_logic
        );
  END COMPONENT;


  component chipscope_icon
    PORT (
           CONTROL0 : INOUT std_logic_vector(35 DOWNTO 0));
  end component;

  component chipscope_ila_uart
    PORT (
           CONTROL : INOUT std_logic_vector(35 DOWNTO 0);
           CLK : IN STD_LOGIC;
           TRIG0 : IN std_logic_vector(3 DOWNTO 0));
  end component;

  COMPONENT BR_GENERATOR
    PORT(
          CLOCK : IN std_logic;
          BAUD : OUT std_logic
        );
  END COMPONENT;

  signal zz : std_logic;
  signal cfgclk : std_logic_vector(7 downto 0);
  signal cfgchnl : std_logic_vector(1 downto 0);
  signal dcmlocked : std_logic;
  signal reset : std_logic;
  signal mclk_out : std_logic;
  signal adcbus : std_logic_vector(15 downto 0);
  signal adcbusclk : std_logic;
  signal cybus : std_logic_vector(15 downto 0);
  signal cybusclk : std_logic;
  signal adcintclk : std_logic;
  signal adcsmplclk : std_logic;
  signal adcpd_out : std_logic;
  signal adcoe_out : std_logic;
  signal cfgdata : std_logic_vector(15 downto 0);
  signal cfgdataclk : std_logic;

  signal cs_control, cs_control_uart : std_logic_vector(35 downto 0);
  signal cs_uart : std_logic_vector(3 downto 0);

  signal cysloe_out : std_logic;
  signal cyslrd_out : std_logic;
  signal cyslwr_out : std_logic;
  signal cyfifoadr_out : std_logic_vector(1 downto 0);

  signal clk_baud : std_logic;
  signal txa_out, txb_out : std_logic;
  signal cfgiba,cfgibb : std_logic_vector(15 downto 0);
  signal savea,saveb : std_logic;
begin
  Inst_adc: adc
  PORT MAP(
            DA => ADCDA,
            DB => ADCDB,
            DATA => adcbus,
            DATACLK => adcbusclk,
            ZZ => zz,
            PD => adcpd_out,
            OE => adcoe_out,
            CLKSMPL => adcsmplclk,
            CLKM => adcintclk,
            CFGCLK => cfgclk,
            CFGCHNL => cfgchnl
          );

  Inst_fx2: fx2
  PORT MAP(
            ADCDATA => adcbus,
            ADCDATACLK => adcbusclk,

            CFGDATA => cfgdata,
            CFGDATACLK => cfgdataclk,

            OUTDATA => cybus,
            OUTDATACLK => cybusclk,

            CLKIF => CYIFCLK,
            RESET => reset,
            FD => CYFD,
            FLAGA => CYFLAGA,
            FLAGB => CYFLAGB,
            FLAGC => CYFLAGC,
            SLOE => cysloe_out,
            SLRD => cyslrd_out,
            SLWR => cyslwr_out,
            FIFOADR => cyfifoadr_out,
            PKTEND => CYPKTEND
          );

  Inst_think: think
  PORT MAP(
            DATAIN => cybus,
            DATACLK => cybusclk,

            RESET => reset,
            CLKIF => CYIFCLK,
            ZZ => zz,
            CFGCLK => cfgclk,
            CFGCHNL => cfgchnl,
            CFGIBA => cfgiba,
            CFGIBB => cfgibb,
            SAVEA => savea,
            SAVEB => saveb
          );

  Inst_maindcm: maindcm
  PORT MAP(
            CLKIN_IN => MCLK,
            CLK0_OUT => mclk_out,
            CLKFX_OUT => adcintclk,
            LOCKED_OUT => dcmlocked
          );

  Inst_inputBoardA: inputBoard
  PORT MAP(
            RESET => reset,
            CLK => mclk_out,
            BAUDCLK => clk_baud,
            CFGIB => cfgiba,
            SAVE => savea,
            RX => RXA,
            TX => txa_out
          );

  Inst_inputBoardB: inputBoard
  PORT MAP(
            RESET => reset,
            CLK => mclk_out,
            BAUDCLK => clk_baud,
            CFGIB => cfgibb,
            SAVE => saveb,
            RX => RXB,
            TX => txb_out
          );


  Inst_chipscope_icon : chipscope_icon
  port map (
             CONTROL0 => cs_control_uart
           );

  Inst_chipscope_ila_uart : chipscope_ila_uart
  port map (
             CONTROL => cs_control_uart,
             CLK => clk_baud,
             TRIG0 => cs_uart
           );

  Inst_BR_GENERATOR: BR_GENERATOR
  PORT MAP(
            CLOCK => mclk_out,
            BAUD => clk_baud
          );

  reset <= not dcmlocked;

  ADCCLK <= adcsmplclk;
  ADCPD <= adcpd_out;
  ADCOE <= adcoe_out;

  CYSLOE <= cysloe_out;
  CYSLRD <= cyslrd_out;
  CYSLWR <= cyslwr_out;
  CYFIFOADR <= cyfifoadr_out;

  TXA <= txa_out;
  TXB <= txb_out;

  cs_uart(0) <= RXA;
  cs_uart(1) <= txa_out;
  cs_uart(2) <= RXB;
  cs_uart(3) <= txb_out;
end Behavioral;
