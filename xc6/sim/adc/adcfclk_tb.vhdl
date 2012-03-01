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

          bitclk_p     : in std_logic;
          bitclk_n     : in std_logic;
          serdesstrobe : in std_logic;
          pktclk       : in std_logic;

          reset    : in std_logic;
          cal_en   : in std_logic;
          cal_busy : out std_logic;

          delay_inc : out std_logic;
          bitslip   : out std_logic;

          rx_fclk : out std_logic
        );
  end component adcfclk;

  component adcbclk
    generic (S : integer := 8); --SERDES factor
    port (
          bclk_p : in std_logic;
          bclk_n : in std_logic;

          reset    : in std_logic;
          cal_en   : in std_logic;
          cal_busy : out std_logic;

          rx_bitclk_p     : out std_logic;
          rx_bitclk_n     : out std_logic;
          rx_pktclk       : out std_logic;
          rx_serdesstrobe : out std_logic
        );
  end component adcbclk;

  signal test_fclk_p, test_fclk_n : std_logic;
  signal test_bclk_p, test_bclk_n : std_logic;
  signal reset, cal_en, cal_busy  : std_logic;
  signal cal_b_busy, cal_f_busy   : std_logic;
  signal rx_bitclk_p, rx_bitclk_n : std_logic;
  signal rx_pktclk                : std_logic;
  signal rx_serdesstrobe          : std_logic;
  signal delay_inc, bitslip       : std_logic;
  signal rx_fclk                  : std_logic;

begin

  cal_busy <= cal_b_busy or cal_f_busy;

  Inst_adcbclk : adcbclk
  generic map (
               S => 8
              )
  port map (
             bclk_p          => test_bclk_p,
             bclk_n          => test_bclk_n,
             reset           => reset,
             cal_en          => cal_en,
             cal_busy        => cal_b_busy,
             rx_bitclk_p     => rx_bitclk_p,
             rx_bitclk_n     => rx_bitclk_n,
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
             bitclk_p     => rx_bitclk_p,
             bitclk_n     => rx_bitclk_n,
             serdesstrobe => rx_serdesstrobe,
             pktclk       => rx_pktclk,
             reset        => reset,
             cal_en       => cal_en,
             cal_busy     => cal_f_busy,
             delay_inc    => delay_inc,
             bitslip      => bitslip,
             rx_fclk      => rx_fclk
             );

  bclock : process
  begin
    test_bclk_p <= '1';
    test_bclk_n <= '0';
    wait for 1 ns;
    test_bclk_p <= '0';
    test_bclk_n <= '0';
    wait for 1 ns;
  end process bclock;

  fclock : process
  begin
    test_fclk_p <= '1';
    test_fclk_n <= '0';
    wait for 8 ns;
    test_fclk_p <= '0';
    test_fclk_n <= '1';
    wait for 8 ns;
  end process fclock;

  tb : process
  begin
    reset <= '1';
    cal_en <= '0';
    wait for 10 ns;
    reset <= '0';

    cal_en <= '1';
    wait until cal_busy = '0';
    cal_en <= '0';

    wait;
  end process tb;

end architecture Behavioral;
