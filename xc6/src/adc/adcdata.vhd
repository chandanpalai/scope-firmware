---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : adcdata.vhdl
--
-- Abstract    : Captures the ADC data using SERDES
--               Based 'loosely' on XAPP1071
--               and XAPP1064's serdes_1_to_n_data_ddr_s8_diff
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity adcdata is
---------------------------------------------------------------------------
  generic
  (
    S              : integer := 8; --SERDES factor
    NUM_DATA_PAIRS : natural := 8  --Num of A+B pairs
  );
  port
  (
    bclk_p       : in std_logic;
    bclk_n       : in std_logic;
    fclk         : in std_logic;
    serdesstrobe : in std_logic;

    bitslip_p    : in std_logic;
    bitslip_n    : in std_logic;
    delay_inc    : in std_logic;
    delay_en     : in std_logic;

    reset        : in std_logic;
    cal_en       : in std_logic;
    cal_slave_en : in std_logic;
    cal_busy     : out std_logic;

    data_in      : in std_logic_vector((NUM_DATA_PAIRS*2)-1 downto 0);
    data_out     : out std_logic_vector((NUM_DATA_PAIRS*S)-1 downto 0);
    valid        : out std_logic
  );
end adcdata;


---------------------------------------------------------------------------
architecture Behavioral of adcdata is
---------------------------------------------------------------------------
  signal delay_m, delay_s        : std_logic_vector(NUM_DATA_PAIRS-1 downto 0);
  signal dlym_busy, dlys_busy    : std_logic_vector(NUM_DATA_PAIRS-1 downto 0);
  signal cascade, pd_edge        : std_logic_vector(NUM_DATA_PAIRS-1 downto 0);
  signal is_valid, serdes_incdec : std_logic_vector(NUM_DATA_PAIRS-1 downto 0);

  component IODELAY2
    generic (
              COUNTER_WRAPAROUND : string := "WRAPAROUND";
              DATA_RATE          : string := "SDR";
              DELAY_SRC          : string := "IO";
              IDELAY2_VALUE      : integer := 0;
              IDELAY_MODE        : string := "NORMAL";
              IDELAY_TYPE        : string := "DEFAULT";
              IDELAY_VALUE       : integer := 0;
              ODELAY_VALUE       : integer := 0;
              SERDES_MODE        : string := "NONE";
              SIM_TAPDELAY_VALUE : integer := 75
            );
    port (
           BUSY     : out std_ulogic;
           DATAOUT  : out std_ulogic;
           DATAOUT2 : out std_ulogic;
           TOUT     : out std_ulogic;
           CAL      : in std_ulogic;
           CE       : in std_ulogic;
           CLK      : in std_ulogic;
           IDATAIN  : in std_ulogic;
           INC      : in std_ulogic;
           IOCLK0   : in std_ulogic;
           IOCLK1   : in std_ulogic;
           ODATAIN  : in std_ulogic;
           RST      : in std_ulogic;
           T        : in std_ulogic
         );
  end component IODELAY2;

  component ISERDES2
    generic (
              BITSLIP_ENABLE : boolean := FALSE;
              DATA_RATE      : string := "SDR";
              DATA_WIDTH     : integer := 1;
              INTERFACE_TYPE : string := "NETWORKING";
              SERDES_MODE    : string := "NONE"
            );
    port (
           CFB0      : out std_ulogic;
           CFB1      : out std_ulogic;
           DFB       : out std_ulogic;
           FABRICOUT : out std_ulogic;
           INCDEC    : out std_ulogic;
           Q1        : out std_ulogic;
           Q2        : out std_ulogic;
           Q3        : out std_ulogic;
           Q4        : out std_ulogic;
           SHIFTOUT  : out std_ulogic;
           VALID     : out std_ulogic;
           BITSLIP   : in std_ulogic := 'L';
           CE0       : in std_ulogic := 'H';
           CLK0      : in std_ulogic;
           CLK1      : in std_ulogic;
           CLKDIV    : in std_ulogic;
           D         : in std_ulogic;
           IOCE      : in std_ulogic := 'H';
           RST       : in std_ulogic := 'L';
           SHIFTIN   : in std_ulogic
         );
  end component ISERDES2;

begin

  cal_busy <= OR_REDUCE(dlym_busy) or OR_REDUCE(dlys_busy);
  valid    <= AND_REDUCE(is_valid);

  DCAPT : for n in 0 to NUM_DATA_PAIRS-1 generate
    Inst_iodelay_m : IODELAY2
    generic map (
                  COUNTER_WRAPAROUND => "WRAPAROUND",
                  DATA_RATE          => "DDR",
                  DELAY_SRC          => "IDATAIN",
                  IDELAY2_VALUE      => 0,
                  IDELAY_MODE        => "NORMAL",
                  IDELAY_TYPE        => "DIFF_PHASE_DETECTOR",
                  IDELAY_VALUE       => 0,
                  ODELAY_VALUE       => 0,
                  SERDES_MODE        => "MASTER",
                  SIM_TAPDELAY_VALUE => 49
                  )
    port map (
               BUSY     => dlym_busy(n),
               DATAOUT  => delay_m(n),
               DATAOUT2 => open,
               TOUT     => open,
               CAL      => cal_en,
               CE       => delay_en,
               CLK      => fclk,
               IDATAIN  => data_in(n*2),
               INC      => delay_inc,
               IOCLK0   => bclk_p,
               IOCLK1   => bclk_n,
               ODATAIN  => '0',
               RST      => reset,
               T        => '1'
               );

    Inst_iodelay_s : IODELAY2
    generic map (
                  COUNTER_WRAPAROUND => "WRAPAROUND",
                  DATA_RATE          => "DDR",
                  DELAY_SRC          => "IDATAIN",
                  IDELAY2_VALUE      => 0,
                  IDELAY_MODE        => "NORMAL",
                  IDELAY_TYPE        => "DIFF_PHASE_DETECTOR",
                  IDELAY_VALUE       => 0,
                  ODELAY_VALUE       => 0,
                  SERDES_MODE        => "SLAVE",
                  SIM_TAPDELAY_VALUE => 49
                  )
    port map (
               BUSY     => dlys_busy(n),
               DATAOUT  => delay_s(n),
               DATAOUT2 => open,
               TOUT     => open,
               CAL      => cal_slave_en,
               CE       => delay_en,
               CLK      => fclk,
               IDATAIN  => data_in(n*2+1),
               INC      => delay_inc,
               IOCLK0   => bclk_p,
               IOCLK1   => bclk_n,
               ODATAIN  => '0',
               RST      => reset,
               T        => '1'
               );

    Inst_iserdes_m : ISERDES2
    generic map (
                  BITSLIP_ENABLE => TRUE,
                  DATA_RATE      => "DDR",
                  DATA_WIDTH     => S,
                  INTERFACE_TYPE => "RETIMED",
                  SERDES_MODE    => "MASTER"
                  )
    port map (
               CFB0      => open,
               CFB1      => open,
               DFB       => open,
               FABRICOUT => open,
               INCDEC    => serdes_incdec(n),
               Q1        => data_out(S*n+4),
               Q2        => data_out(S*n+5),
               Q3        => data_out(S*n+6),
               Q4        => data_out(S*n+7),
               SHIFTOUT  => cascade(n),
               VALID     => is_valid(n),
               BITSLIP   => bitslip_p,
               CE0       => '1',
               CLK0      => bclk_p,
               CLK1      => bclk_n,
               CLKDIV    => fclk,
               D         => delay_m(n),
               IOCE      => serdesstrobe,
               RST       => reset,
               SHIFTIN   => pd_edge(n)
               );

    Inst_iserdes_s : ISERDES2
    generic map (
                  BITSLIP_ENABLE => TRUE,
                  DATA_RATE      => "DDR",
                  DATA_WIDTH     => S,
                  INTERFACE_TYPE => "RETIMED",
                  SERDES_MODE    => "SLAVE"
                  )
    port map (
               CFB0      => open,
               CFB1      => open,
               DFB       => open,
               FABRICOUT => open,
               INCDEC    => open,
               Q1        => data_out(S*n),
               Q2        => data_out(S*n+1),
               Q3        => data_out(S*n+2),
               Q4        => data_out(S*n+3),
               SHIFTOUT  => pd_edge(n),
               VALID     => open,
               BITSLIP   => bitslip_n,
               CE0       => '1',
               CLK0      => bclk_p,
               CLK1      => bclk_n,
               CLKDIV    => fclk,
               D         => delay_s(n),
               IOCE      => serdesstrobe,
               RST       => reset,
               SHIFTIN   => cascade(n)
               );
  end generate DCAPT;

end architecture Behavioral;

