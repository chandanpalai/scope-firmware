---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : adcbclk_tb.vhdl
--
-- Abstract    : Test Bench for the ADC Bit Clock receiving code
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity adcbclk_tb is
---------------------------------------------------------------------------
end entity;


---------------------------------------------------------------------------
architecture Behavioral of adcbclk_tb is
---------------------------------------------------------------------------
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

  signal test_bclk_p, test_bclk_n : std_logic;
  signal reset, cal_en, cal_busy  : std_logic;
  signal rx_bitclk_p, rx_bitclk_n : std_logic;
  signal rx_pktclk                : std_logic;
  signal rx_serdesstrobe          : std_logic;
begin
  Inst_adcbclk : adcbclk
  generic map (
               S => 8
              )
  port map (
             bclk_p          => test_bclk_p,
             bclk_n          => test_bclk_n,
             reset           => reset,
             cal_en          => cal_en,
             cal_busy        => cal_busy,
             rx_bitclk_p     => rx_bitclk_p,
             rx_bitclk_n     => rx_bitclk_n,
             rx_pktclk       => rx_pktclk,
             rx_serdesstrobe => rx_serdesstrobe
             );

  clock : process
  begin
    test_bclk_p <= '1';
    test_bclk_n <= '0';
    wait for 1 ns;
    test_bclk_p <= '0';
    test_bclk_n <= '1';
    wait for 1 ns;
  end process clock;

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
