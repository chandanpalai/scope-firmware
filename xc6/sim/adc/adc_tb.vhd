---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : adc_tb.vhd
--
-- Abstract    : Test bench for booting up the whole ADC system
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity adc_tb is
---------------------------------------------------------------------------
end adc_tb;


---------------------------------------------------------------------------
architecture Behavioral of adc_tb is
---------------------------------------------------------------------------
  component adc
    generic (
              S              : integer := 8; --SERDES factor
              NUM_DATA_PAIRS : natural := 8 --Num of A+B pairs
            );
  port (
        sys_rst : in std_logic;
        fsmclk  : in std_logic;

          --Serial interface
        sdata  : out std_logic;
        sclk   : out std_logic;
        sreset : out std_logic;
        csn    : out std_logic;

          --Data interface
        bclk_p : in std_logic;
        bclk_n : in std_logic;
        fclk_p : in std_logic;
        fclk_n : in std_logic;

        d1a_p : in std_logic;
        d1a_n : in std_logic;
        d1b_p : in std_logic;
        d1b_n : in std_logic;
        d2a_p : in std_logic;
        d2a_n : in std_logic;
        d2b_p : in std_logic;
        d2b_n : in std_logic;
        d3a_p : in std_logic;
        d3a_n : in std_logic;
        d3b_p : in std_logic;
        d3b_n : in std_logic;
        d4a_p : in std_logic;
        d4a_n : in std_logic;
        d4b_p : in std_logic;
        d4b_n : in std_logic;

          --Internal config interface
        pktoutadc    : in std_logic_vector(15 downto 0);
        pktoutadcclk : in std_logic;
        pktinadc     : out std_logic_vector(15 downto 0);
        pktinadcclk  : out std_logic;

          --Internal data interface
        data    : out std_logic_vector(NUM_DATA_PAIRS*S-1 downto 0);
        dataclk : out std_logic
      );
  end component adc;

  signal test_bclk_p, test_bclk_n : std_logic;
  signal test_fclk_p, test_fclk_n : std_logic;
  signal sys_rst, fsmclk          : std_logic;
  signal test_din                 : std_logic_vector(8*2-1 downto 0);
  signal test_dout                : std_logic_vector(8*8-1 downto 0);
  signal test_doutclk             : std_logic;

begin

  Inst_adc : adc
  generic map (
                S              => 8,
                NUM_DATA_PAIRS => 8
                )
  port map (
             sys_rst      => sys_rst,
             fsmclk       => fsmclk,
             sdata        => open,
             sclk         => open,
             sreset       => open,
             csn          => open,
             bclk_p       => test_bclk_p,
             bclk_n       => test_bclk_n,
             fclk_p       => test_fclk_p,
             fclk_n       => test_fclk_n,
             d1a_p        => test_din(0),
             d1a_n        => test_din(1),
             d1b_p        => test_din(2),
             d1b_n        => test_din(3),
             d2a_p        => test_din(4),
             d2a_n        => test_din(5),
             d2b_p        => test_din(6),
             d2b_n        => test_din(7),
             d3a_p        => test_din(8),
             d3a_n        => test_din(9),
             d3b_p        => test_din(10),
             d3b_n        => test_din(11),
             d4a_p        => test_din(12),
             d4a_n        => test_din(13),
             d4b_p        => test_din(14),
             d4b_n        => test_din(15),
             pktoutadc    => (others => '0'),
             pktoutadcclk => '0',
             pktinadc     => open,
             pktinadcclk  => open,
             data         => test_dout,
             dataclk      => test_doutclk
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
  end process;

  fclock : process
  begin
    test_fclk_p <= '1';
    test_fclk_n <= '0';
    wait for 4 ns;
    test_fclk_p <= '0';
    test_fclk_n <= '1';
    wait for 4 ns;
  end process;

  fsmclock : process
  begin
    fsmclk <= '1';
    wait for 5 ns;
    fsmclk <= '0';
    wait for 5 ns;
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
    sys_rst <= '1';
    wait for 10 ns;
    sys_rst <= '0';

    wait;
  end process;

end architecture Behavioral;

