---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : adcfclk.vhdl
--
-- Abstract    : Recovers the ADC frame clock.
--               Based loosely on XAPP1071 and
--               and XAPP1064 serdes_1_to_n_data_ddr_s8_diff
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity adcfclk is
---------------------------------------------------------------------------
  generic (S : integer := 8); --SERDES factor
  port
  (
    fclk_p       : in std_logic;
    fclk_n       : in std_logic;

    bclk_p     : in std_logic;
    bclk_n     : in std_logic;
    serdesstrobe : in std_logic;
    pktclk       : in std_logic;

    reset        : in std_logic;
    cal_en       : in std_logic;
    cal_busy     : out std_logic;

    delay_inc    : out std_logic;
    bitslip      : out std_logic;

    rx_fclk      : out std_logic
  );
end adcfclk;


---------------------------------------------------------------------------
architecture Behavioral of adcfclk is
---------------------------------------------------------------------------
  signal delay_m, delay_s     : std_logic;
  signal dlym_busy, dlys_busy : std_logic;
  signal pd_edge, cascade     : std_logic;
  signal frame_data           : std_logic_vector(S-1 downto 0);
  signal is_valid             : std_logic;
  signal delay_inc_int        : std_logic := '0';
  signal delay_inc_en         : std_logic := '0';
  signal incdec               : std_logic;
  signal bitslip_int          : std_logic;
  signal cal_busy_int         : std_logic;
  signal divbclk_p, divbclk_n : std_logic;

  type state_type is (st0_idle, st1_slip, st2_slip_wait, st3_delay,
                      st4_delay_wait);
  signal state : state_type;

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

  cal_busy_int <= dlym_busy or dlys_busy;
  cal_busy     <= cal_busy_int;
  delay_inc    <= delay_inc_int;
  bitslip      <= bitslip_int;

  Inst_bufio2_p : BUFIO2
  generic map (
                DIVIDE_BYPASS => FALSE,
                DIVIDE        => 2,
                I_INVERT      => FALSE,
                USE_DOUBLER   => FALSE
                )
  port map (
             DIVCLK       => divbclk_p,
             IOCLK        => open,
             SERDESSTROBE => open,
             I            => bclk_p
             );

  Inst_bufio2_n : BUFIO2
  generic map (
                DIVIDE_BYPASS => FALSE,
                DIVIDE        => 2,
                I_INVERT      => FALSE,
                USE_DOUBLER   => FALSE
                )
  port map (
             DIVCLK       => divbclk_n,
             IOCLK        => open,
             SERDESSTROBE => open,
             I            => bclk_n
             );

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
             BUSY     => dlym_busy,
             DATAOUT  => delay_m,
             DATAOUT2 => open,
             DOUT     => open,
             TOUT     => open,
             CAL      => cal_en,
             CE       => delay_inc_en,
             CLK      => pktclk,
             IDATAIN  => fclk_p,
             INC      => delay_inc_int,
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
             BUSY     => dlys_busy,
             DATAOUT  => delay_s,
             DATAOUT2 => open,
             DOUT     => open,
             TOUT     => open,
             CAL      => cal_en,
             CE       => delay_inc_en,
             CLK      => pktclk,
             IDATAIN  => fclk_n,
             INC      => delay_inc_int,
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
             INCDEC    => incdec,
             Q1        => frame_data(4),
             Q2        => frame_data(5),
             Q3        => frame_data(6),
             Q4        => frame_data(7),
             SHIFTOUT  => cascade,
             VALID     => is_valid,
             BITSLIP   => bitslip_int,
             CE0       => '1',
             CLK0      => divbclk_p,
             CLK1      => divbclk_n,
             CLKDIV    => pktclk,
             D         => delay_m,
             IOCE      => serdesstrobe,
             RST       => reset,
             SHIFTIN   => pd_edge
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
             Q1        => frame_data(0),
             Q2        => frame_data(1),
             Q3        => frame_data(2),
             Q4        => frame_data(3),
             SHIFTOUT  => pd_edge,
             VALID     => open,
             BITSLIP   => bitslip_int,
             CE0       => '1',
             CLK0      => divbclk_p,
             CLK1      => divbclk_n,
             CLKDIV    => pktclk,
             D         => delay_s,
             IOCE      => serdesstrobe,
             RST       => reset,
             SHIFTIN   => cascade
             );

  --TODO: Test stuff
  rx_fclk <= frame_data(0);
  align : process (reset, pktclk, frame_data)
  begin
    if reset = '1' then
      state <= st0_idle;
      bitslip_int <= '0';
      delay_inc_en <= '0';
    else
      if pktclk'event and pktclk = '1' then
        case state is
          when st0_idle =>
            if cal_busy_int = '0' then
              state <= st1_slip;
            end if;
          when st1_slip =>
            if frame_data = x"F0" then
              bitslip_int <= '1';
              state <= st2_slip_wait;
            else
              state <= st3_delay;
            end if;
          when st2_slip_wait =>
            bitslip_int <= '0';
            state <= st1_slip;
          when st3_delay =>
            if incdec = '1' then
              delay_inc_en <= '1';
              case frame_data is
                when "11111110" =>
                  delay_inc_int <= '0';
                when "00000001" =>
                when others =>
              end case;
              state <= st4_delay_wait;
            else
              state <= st0_idle;
            end if;
          when st4_delay_wait =>
            if cal_busy_int = '0' then
              state <= st3_delay;
            end if;
        end case;
      end if;
    end if;
  end process align;

end architecture Behavioral;
