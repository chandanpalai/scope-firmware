--------------------------------------------------------------------------------
-- Engineer:       Ali Lown
--
-- Module Name:    adcdata - Behavioral
-- Project Name:   USB Digital Oscilloscope
-- Target Devices: xc6slx25
-- Description:    Recovers the ADC data lines
--                 Based 'losely' on XAPP1071
--                 and XAPP1064 serdes_1_to_n_data_ddr_s8_diff
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

entity adcdata is
  generic (
            S : integer := 8; --SERDES Factor
            NUM_DATA_PAIRS : natural := 8 --Num of A+B pairs
          );
  port (
         bitclk_p : in std_logic;
         bitclk_n : in std_logic;
         frameclk : in std_logic;
         frameclk_en : in std_logic;
         serdesstrobe : in std_logic;

         bitslip_p : in std_logic;
         bitslip_n : in std_logic;
         delay_inc : in std_logic;

         reset : in std_logic;
         cal_en : in std_logic;
         cal_busy : out std_logic;

         data_in : in std_logic_vector((NUM_DATA_PAIRS*2)-1 downto 0);
         dout : out std_logic_vector((NUM_DATA_PAIRS*S)-1 downto 0);
         dout_valid : out std_logic_vector(NUM_DATA_PAIRS-1 downto 0)
       );
end adcdata;

architecture Behavioral of adcdata is
  signal delay_m, delay_s : std_logic_vector(NUM_DATA_PAIRS-1 downto 0);
  signal dlym_busy, dlys_busy : std_logic_vector(NUM_DATA_PAIRS-1 downto 0);
  signal cascade, pd_edge : std_logic_vector(NUM_DATA_PAIRS-1 downto 0);

begin
  DATA: for n in 0 to NUM_DATA_PAIRS-1 generate
    Inst_iodelay_m : IODELAY2
    generic map (
                  DATA_RATE => "DDR",
                  IDELAY_VALUE => 0,
                  IDELAY2_VALUE => 0,
                  IDELAY_MODE => "NORMAL",
                  ODELAY_VALUE => 0,
                  IDELAY_TYPE => "DIFF_PHASE_DETECTOR",
                  COUNTER_WRAPAROUND => "WRAPAROUND",
                  DELAY_SRC => "IDATAIN",
                  SERDES_MODE => "MASTER",
                  SIM_TAPDELAY_VALUE => 49
                )
    port map (
               IDATAIN => data_in(n*2),
               TOUT => open,
               DOUT => open,
               T => '1',
               ODATAIN => '0',
               DATAOUT => delay_m(n),
               DATAOUT2 => open,
               IOCLK0 => bitclk_p,
               IOCLK1 => bitclk_n,
               CLK => frameclk,
               CAL => cal_en,
               INC => delay_inc,
               CE => frameclk_en,
               RST => reset,
               BUSY => dlym_busy(n)
             );

    Inst_iodelay_s : IODELAY2
    generic map (
                  DATA_RATE => "DDR",
                  IDELAY_VALUE => 0,
                  IDELAY2_VALUE => 0,
                  IDELAY_MODE => "NORMAL",
                  ODELAY_VALUE => 0,
                  IDELAY_TYPE => "DIFF_PHASE_DETECTOR",
                  COUNTER_WRAPAROUND => "WRAPAROUND",
                  DELAY_SRC => "IDATAIN",
                  SERDES_MODE => "SLAVE",
                  SIM_TAPDELAY_VALUE => 49
                )
    port map (
               IDATAIN => data_in(n*2+1),
               TOUT => open,
               DOUT => open,
               T => '1',
               ODATAIN => '0',
               DATAOUT => delay_s(n),
               DATAOUT2 => open,
               IOCLK0 => bitclk_p,
               IOCLK1 => bitclk_n,
               CLK => frameclk,
               CAL => cal_en,
               INC => delay_inc,
               CE => frameclk_en,
               RST => reset,
               BUSY => dlys_busy(n)
             );

    Inst_iserdes_m : ISERDES2
    generic map (
                  DATA_WIDTH => S,
                  DATA_RATE => "DDR",
                  BITSLIP_ENABLE => TRUE,
                  SERDES_MODE => "MASTER",
                  INTERFACE_TYPE => "RETIMED"
                )
    port map (
               D => delay_m(n),
               CE0 => '1',
               CLK0 => bitclk_p,
               CLK1 => bitclk_n,
               IOCE => serdesstrobe,
               RST => reset,
               CLKDIV => frameclk,
               SHIFTIN => pd_edge(n),
               BITSLIP => bitslip_p(n),
               FABRICOUT => open,
               Q4 => dout(S*n+7),
               Q3 => dout(S*n+6),
               Q2 => dout(S*n+5),
               Q1 => dout(S*n+4),
               DFB => open,
               CFB0 => open,
               CFB1 => open,
               VALID => dout_valid(n),
               INCDEC => serdes_incdec(n),
               SHIFTOUT => cascade(n)
             );

    Inst_iserdes_s : ISERDES2
    generic map (
                  DATA_WIDTH => S,
                  DATA_RATE => "DDR",
                  BITSLIP_ENABLE => TRUE,
                  SERDES_MODE => "SLAVE",
                  INTERFACE_TYPE => "RETIMED"
                )
    port map (
               D => delay_s(n),
               CE0 => '1',
               CLK0 => bitclk_p,
               CLK1 => bitclk_n,
               IOCE => serdesstrobe,
               RST => reset,
               CLKDIV => frameclk,
               SHIFTIN => cascade(n),
               BITSLIP => bitslip_n(n),
               FABRICOUT => open,
               Q4 => dout(S*n+3),
               Q3 => dout(S*n+2),
               Q2 => dout(S*n+1),
               Q1 => dout(S*n),
               DFB => open,
               CFB0 => open,
               CFB1 => open,
               VALID => open,
               INCDEC => open,
               SHIFTOUT => pd_edge(n)
             );
  end generate;
end Behavioral;
