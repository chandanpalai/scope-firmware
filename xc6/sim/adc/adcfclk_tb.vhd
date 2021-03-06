---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : adcfclk_tb.vhdl
--
-- Abstract    : Test bench for the ADC frame clock recovery logic
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity adcfclk_tb is
---------------------------------------------------------------------------
end adcfclk_tb;


---------------------------------------------------------------------------
architecture Behavioral of adcfclk_tb is
---------------------------------------------------------------------------
  component adcfclk
    generic (S : integer := 8); --SERDES factor
    port (
          fclk_p : in std_logic;
          fclk_n : in std_logic;

          bclk_p     : in std_logic;
          bclk_n     : in std_logic;
          serdesstrobe : in std_logic;
          pktclk       : in std_logic;

          reset        : in std_logic;
          cal_en       : in std_logic;
          cal_slave_en : in std_logic;
          cal_busy     : out std_logic;

          delay_inc : out std_logic;
          delay_inc_en : out std_logic;
          bitslip   : out std_logic;

          rx_fclk : out std_logic
        );
  end component adcfclk;

  component adcbclk
    generic (S : integer := 8); --SERDES factor
    port (
          bclk_p : in std_logic;
          bclk_n : in std_logic;

          reset        : in std_logic;
          cal_en       : in std_logic;
          cal_slave_en : in std_logic;
          cal_busy     : out std_logic;

          rx_bclk_p     : out std_logic;
          rx_bclk_n     : out std_logic;
          rx_pktclk       : out std_logic;
          rx_serdesstrobe : out std_logic
        );
  end component adcbclk;

  signal test_fclk_p, test_fclk_n : std_logic;
  signal test_bclk_p, test_bclk_n : std_logic;
  signal reset, cal_en, cal_busy  : std_logic;
  signal cal_b_busy, cal_f_busy   : std_logic;
  signal rx_bclk_p, rx_bclk_n : std_logic;
  signal rx_pktclk                : std_logic;
  signal rx_serdesstrobe          : std_logic;
  signal delay_inc_en             : std_logic;
  signal delay_inc, bitslip       : std_logic;
  signal rx_fclk                  : std_logic;

  signal cal_tb_en                : std_logic := '0';
  signal cal_calibrate_en         : std_logic := '0';

begin

  cal_busy <= cal_b_busy or cal_f_busy;
  cal_en   <= cal_tb_en or cal_calibrate_en;

  Inst_adcbclk : adcbclk
  generic map (
               S => 8
              )
  port map (
             bclk_p          => test_bclk_p,
             bclk_n          => test_bclk_n,
             reset           => reset,
             cal_en          => cal_en,
             cal_slave_en    => cal_en,
             cal_busy        => cal_b_busy,
             rx_bclk_p       => rx_bclk_p,
             rx_bclk_n       => rx_bclk_n,
             rx_pktclk       => rx_pktclk,
             rx_serdesstrobe => rx_serdesstrobe
             );

  Inst_adcfclk : adcfclk
  generic map (
              S => 8
              )
  port map (
             fclk_p       => test_fclk_p,
             fclk_n       => test_fclk_n,
             bclk_p       => rx_bclk_p,
             bclk_n       => rx_bclk_n,
             serdesstrobe => rx_serdesstrobe,
             pktclk       => rx_pktclk,
             reset        => reset,
             cal_en       => cal_en,
             cal_slave_en => cal_en,
             cal_busy     => cal_f_busy,
             delay_inc    => delay_inc,
             delay_inc_en => delay_inc_en,
             bitslip      => bitslip,
             rx_fclk      => rx_fclk
             );

  test_bclk_n <= not test_bclk_p;
  bclock : process
  begin
    wait for 500 ps;
    test_bclk_p <= '0';
    wait for 1 ns;
    test_bclk_p <= '1';
    wait for 500 ps;
  end process bclock;

  test_fclk_n <= not test_fclk_p;
  fclock : process
  begin
    test_fclk_p <= '1';
    wait for 4 ns;
    test_fclk_p <= '0';
    wait for 4 ns;
  end process fclock;

  calibrate : process
  begin
    cal_calibrate_en <= '0';
    wait for 10 us;
    cal_calibrate_en <= '1';
    wait for 20 ns;
  end process;

  tb : process
  begin
    reset <= '1';
    wait for 10 ns;
    reset <= '0';

    cal_tb_en <= '1';
    wait for 20 ns;
    cal_tb_en <= '0';
    reset <= '1';
    wait for 5 ns;
    reset <= '0';

    wait;
  end process tb;

end architecture Behavioral;
