---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : adcdata_tb.vhdl
--
-- Abstract    : Test bench for the ADC data capturing logic
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity adcdata_tb is
---------------------------------------------------------------------------
end adcdata_tb;


---------------------------------------------------------------------------
architecture Behavioral of adcdata_tb is
---------------------------------------------------------------------------
  component adcdata
    generic (
             S              : integer := 8; --SERDES factor
             NUM_DATA_PAIRS : natural := 8  --Num of A+B pairs
            );
    port (
          bclk_p       : in std_logic;
          bclk_n       : in std_logic;
          fclk         : in std_logic;
          serdesstrobe : in std_logic;

          bitslip_p : in std_logic;
          bitslip_n : in std_logic;
          delay_inc : in std_logic;
          delay_en  : in std_logic;

          reset        : in std_logic;
          cal_en       : in std_logic;
          cal_slave_en : in std_logic;
          cal_busy     : out std_logic;

          data_in  : in std_logic_vector((NUM_DATA_PAIRS*2)-1 downto 0);
          data_out : out std_logic_vector((NUM_DATA_PAIRS*S)-1 downto 0);
          valid    : out std_logic
        );
  end component adcdata;

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

          delay_inc    : out std_logic;
          delay_inc_en : out std_logic;
          bitslip      : out std_logic;

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


  signal test_bclk_p, test_bclk_n    : std_logic;
  signal test_fclk_p, test_fclk_n    : std_logic;
  signal reset, cal_en, cal_busy     : std_logic;
  signal cal_b_busy, cal_f_busy      : std_logic;
  signal cal_d_busy                  : std_logic;
  signal cal_calibrate_en, cal_tb_en : std_logic;
  signal rx_bclk_p, rx_bclk_n    : std_logic;
  signal rx_pktclk, rx_serdesstrobe  : std_logic;
  signal delay_inc, bitslip          : std_logic;
  signal rx_fclk, delay_en, valid    : std_logic;
  signal test_din                    : std_logic_vector((8*2)-1 downto 0);
  signal test_dout                   : std_logic_vector((8*8)-1 downto 0);
begin

  cal_busy <= cal_b_busy or cal_f_busy or cal_d_busy;
  cal_en <= cal_tb_en or cal_calibrate_en;

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
             rx_bclk_p     => rx_bclk_p,
             rx_bclk_n     => rx_bclk_n,
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
             bclk_p     => rx_bclk_p,
             bclk_n     => rx_bclk_n,
             serdesstrobe => rx_serdesstrobe,
             pktclk       => rx_pktclk,
             reset        => reset,
             cal_en       => cal_en,
             cal_slave_en => cal_en,
             cal_busy     => cal_f_busy,
             delay_inc    => delay_inc,
             delay_inc_en => delay_en,
             bitslip      => bitslip,
             rx_fclk      => rx_fclk
             );

  Inst_adcdata : adcdata
  generic map (
                S              => 8,
                NUM_DATA_PAIRS => 8
              )
  port map (
             bclk_p       => rx_bclk_p,
             bclk_n       => rx_bclk_n,
             fclk         => rx_fclk,
             serdesstrobe => rx_serdesstrobe,
             bitslip_p    => bitslip,
             bitslip_n    => bitslip,
             delay_inc    => delay_inc,
             delay_en     => delay_en,
             reset        => reset,
             cal_en       => cal_en,
             cal_slave_en => cal_en,
             cal_busy     => cal_d_busy,
             data_in      => test_din,
             data_out     => test_dout,
             valid        => valid
             );

  bclock : process
  begin
    wait for 500 ps;
    test_bclk_p <= '0';
    test_bclk_n <= '1';
    wait for 1 ns;
    test_bclk_p <= '1';
    test_bclk_n <= '0';
    wait for 500 ps;
  end process bclock;

  fclock : process
  begin
    test_fclk_p <= '1';
    test_fclk_n <= '0';
    wait for 4 ns;
    test_fclk_p <= '0';
    test_fclk_n <= '1';
    wait for 4 ns;
  end process fclock;

  calibrate : process
  begin
    cal_calibrate_en <= '0';
    wait for 5 us;
    cal_calibrate_en <= '1';
    wait for 20 ns;
  end process;

  tdata : process
    variable data : integer := 0;
    variable td_p : std_logic_vector(7 downto 0);
    variable td_n : std_logic_vector(7 downto 0);
  begin
    td_p := std_logic_vector(to_unsigned(data,8));
    td_n := not td_p;
    test_din(0)  <= td_p(0);
    test_din(1)  <= td_n(0);
    test_din(2)  <= td_p(1);
    test_din(3)  <= td_n(1);
    test_din(4)  <= td_p(2);
    test_din(5)  <= td_n(2);
    test_din(6)  <= td_p(3);
    test_din(7)  <= td_n(3);
    test_din(8)  <= td_p(4);
    test_din(9)  <= td_n(4);
    test_din(10) <= td_p(5);
    test_din(11) <= td_n(5);
    test_din(12) <= td_p(6);
    test_din(13) <= td_n(6);
    test_din(14) <= td_p(7);
    test_din(15) <= td_n(7);
    data := data + 1;
    wait for 1 ns;
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

