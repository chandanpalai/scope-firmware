---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : adcbuf_tb.vhdl
--
-- Abstract    : Test the buffers
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity adcbuf_tb is
---------------------------------------------------------------------------
end adcbuf_tb;


---------------------------------------------------------------------------
architecture Behavioral of adcbuf_tb is
---------------------------------------------------------------------------
  component adcbuf
  port (
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

        buf_bclk_p   : out std_logic;
        buf_bclk_n   : out std_logic;
        buf_fclk_p   : out std_logic;
        buf_fclk_n   : out std_logic;
        buf_data_a_p : out std_logic_vector(3 downto 0);
        buf_data_a_n : out std_logic_vector(3 downto 0);
        buf_data_b_p : out std_logic_vector(3 downto 0);
        buf_data_b_n : out std_logic_vector(3 downto 0)
      );
  end component adcbuf;

  signal test_bclk_p, test_bclk_n : std_logic;
  signal test_fclk_p, test_fclk_n : std_logic;
  signal buf_bclk_p, buf_bclk_n   : std_logic;
  signal buf_fclk_p, buf_fclk_n   : std_logic;
  signal din_p,din_n              : std_logic_vector(7 downto 0);
  signal dout_p,dout_n            : std_logic_vector(7 downto 0);
begin
  Inst_adcbuf : adcbuf
  port map (
             bclk_p       => test_bclk_p,
             bclk_n       => test_bclk_n,
             fclk_p       => test_fclk_p,
             fclk_n       => test_fclk_n,
             d1a_p        => din_p(0),
             d1a_n        => din_n(0),
             d1b_p        => din_p(1),
             d1b_n        => din_n(1),
             d2a_p        => din_p(2),
             d2a_n        => din_n(2),
             d2b_p        => din_p(3),
             d2b_n        => din_n(3),
             d3a_p        => din_p(4),
             d3a_n        => din_n(4),
             d3b_p        => din_p(5),
             d3b_n        => din_n(5),
             d4a_p        => din_p(6),
             d4a_n        => din_n(6),
             d4b_p        => din_p(7),
             d4b_n        => din_n(7),
             buf_bclk_p   => buf_bclk_p,
             buf_bclk_n   => buf_bclk_n,
             buf_fclk_p   => buf_fclk_p,
             buf_fclk_n   => buf_fclk_n,
             buf_data_a_p => dout_p(3 downto 0),
             buf_data_a_n => dout_n(3 downto 0),
             buf_data_b_p => dout_p(7 downto 4),
             buf_data_b_n => dout_n(7 downto 4)
             );

  bclk : process
  begin
    test_bclk_p <= '1';
    test_bclk_n <= '0';
    wait for 1 ns;
    test_bclk_p <= '0';
    test_bclk_n <= '1';
    wait for 1 ns;
  end process;

  fclk : process
  begin
    test_fclk_p <= '1';
    test_fclk_n <= '0';
    wait for 8 ns;
    test_fclk_p <= '0';
    test_fclk_n <= '1';
    wait for 8 ns;
  end process;

  tb : process
    variable data : integer := 0;
  begin
    din_p <= std_logic_vector(to_unsigned(data,8));
    din_n <= not std_logic_vector(to_unsigned(data,8));
    data := data + 1;
    wait for 1 ns;
  end process;

end architecture Behavioral;

