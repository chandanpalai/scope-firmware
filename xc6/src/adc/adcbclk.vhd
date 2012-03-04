---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : adcbclk.vhd
--
-- Abstract    : Recovers the ADC bit clock.
--               Based on XAPP1064: serdes_1_to_n_clk_ddr_s8_diff
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity adcbclk is
---------------------------------------------------------------------------
  generic (S : integer := 8); --SERDES factor
  port
  (
    bclk_p          : in std_logic;
    bclk_n          : in std_logic;

    reset           : in std_logic;
    cal_en          : in std_logic;
    cal_slave_en    : in std_logic;
    cal_busy        : out std_logic;

    rx_bclk_p     : out std_logic;
    rx_bclk_n     : out std_logic;
    rx_pktclk       : out std_logic;
    rx_serdesstrobe : out std_logic
  );
end adcbclk;


---------------------------------------------------------------------------
architecture Behavioral of adcbclk is
---------------------------------------------------------------------------
  signal delay_m, delay_s     : std_logic;
  signal dlym_busy, dlys_busy : std_logic;

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
           DOUT     : out std_ulogic;
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

  component BUFIO2_2CLK
    generic(

             DIVIDE : integer := 2    -- {2..8}
           );
    port(
          DIVCLK       : out std_ulogic;
          IOCLK        : out std_ulogic;
          SERDESSTROBE : out std_ulogic;

          I  : in  std_ulogic;
          IB : in  std_ulogic
        );
  end component BUFIO2_2CLK;

  component BUFIO2
    generic(

             DIVIDE_BYPASS : boolean := TRUE;  -- TRUE, FALSE
             DIVIDE        : integer := 1;     -- {1..8}
             I_INVERT      : boolean := FALSE; -- TRUE, FALSE
             USE_DOUBLER   : boolean := FALSE  -- TRUE, FALSE
           );
    port(
          DIVCLK       : out std_ulogic;
          IOCLK        : out std_ulogic;
          SERDESSTROBE : out std_ulogic;

          I : in  std_ulogic
        );
  end component BUFIO2;

begin

  cal_busy <= dlym_busy or dlys_busy;

  Inst_iodelay_m : IODELAY2
  generic map (
                COUNTER_WRAPAROUND => "STAY_AT_LIMIT",
                DATA_RATE          => "SDR",
                DELAY_SRC          => "IDATAIN",
                IDELAY2_VALUE      => 0,
                IDELAY_MODE        => "NORMAL",
                IDELAY_TYPE        => "FIXED",
                IDELAY_VALUE       => 0,
                ODELAY_VALUE       => 0,
                SERDES_MODE        => "MASTER",
                SIM_TAPDELAY_VALUE => 49
                )
  port map (
             BUSY     => dlym_busy,
             DATAOUT  => delay_m,
             DATAOUT2 => open,
             DOUT     => open,
             TOUT     => open,
             CAL      => cal_en,
             CE       => '0',
             CLK      => '0',
             IDATAIN  => bclk_p,
             INC      => '0',
             IOCLK0   => '0',
             IOCLK1   => '0',
             ODATAIN  => '0',
             RST      => reset,
             T        => '1'
             );

  Inst_iodelay_s : IODELAY2
  generic map (
                COUNTER_WRAPAROUND => "STAY_AT_LIMIT",
                DATA_RATE          => "SDR",
                DELAY_SRC          => "IDATAIN",
                IDELAY2_VALUE      => 0,
                IDELAY_MODE        => "NORMAL",
                IDELAY_TYPE        => "FIXED",
                IDELAY_VALUE       => 0,
                ODELAY_VALUE       => 0,
                SERDES_MODE        => "SLAVE",
                SIM_TAPDELAY_VALUE => 49
                )
  port map (
             BUSY     => dlys_busy,
             DATAOUT  => delay_s,
             DATAOUT2 => open,
             DOUT     => open,
             TOUT     => open,
             CAL      => cal_slave_en,
             CE       => '0',
             CLK      => '0',
             IDATAIN  => bclk_n,
             INC      => '0',
             IOCLK0   => '0',
             IOCLK1   => '0',
             ODATAIN  => '0',
             RST      => reset,
             T        => '1'
             );

  bufio2_2clk_inst : BUFIO2_2CLK
  generic map (
               DIVIDE => S
  )
  port map (
             DIVCLK       => rx_pktclk,
             IOCLK        => rx_bclk_p,
             SERDESSTROBE => rx_serdesstrobe,
             I            => delay_m,
             IB           => delay_s
             );

  bufio2_inst : BUFIO2
  generic map (
                DIVIDE_BYPASS => FALSE,
                DIVIDE        => 1,
                I_INVERT      => FALSE,
                USE_DOUBLER   => FALSE
                )
  port map (
             DIVCLK       => open,
             IOCLK        => rx_bclk_n,
             SERDESSTROBE => open,
             I            => delay_s
             );

end architecture Behavioral;

