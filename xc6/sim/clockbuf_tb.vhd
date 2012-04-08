---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : clockbuf_tb.vhd
--
-- Abstract    : Test bench for the clock buffer module
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------------------------
entity clockbuf_tb is
---------------------------------------------------------------------------
end clockbuf_tb;


---------------------------------------------------------------------------
architecture Behavioral of clockbuf_tb is
---------------------------------------------------------------------------
  component clockbuf
    port (
          ddrclk_p : in std_logic;
          ddrclk_n : in std_logic;
          fsmclk_p : in std_logic;
          fsmclk_n : in std_logic;
          fx3clk   : in std_logic;

          buf_ddrclk : out std_logic;
          buf_fsmclk : out std_logic;
          buf_fx3clk : out std_logic
        );
  end component clockbuf;

  signal ddrclk_p, ddrclk_n : std_logic;
  signal fsmclk_p, fsmclk_n : std_logic;
  signal fx3clk             : std_logic;
  signal buf_ddrclk         : std_logic;
  signal buf_fsmclk         : std_logic;
  signal buf_fx3clk         : std_logic;


begin
  Inst_clockbuf : clockbuf
  port map (
             ddrclk_p   => ddrclk_p,
             ddrclk_n   => ddrclk_n,
             fsmclk_p   => fsmclk_p,
             fsmclk_n   => fsmclk_n,
             fx3clk     => fx3clk,
             buf_ddrclk => buf_ddrclk,
             buf_fsmclk => buf_fsmclk,
             buf_fx3clk => buf_fx3clk
             );

  ddrclk_n <= not ddrclk_p;
  ddrclk : process
  begin
    ddrclk_p <= '1';
    wait for 1.5 ns;
    ddrclk_p <= '0';
    wait for 1.5 ns;
  end process;

  fsmclk_n <= not fsmclk_p;
  fsmclk : process
  begin
    fsmclk_p <= '1';
    wait for 2.5 ns;
    fsmclk_p <= '0';
    wait for 2.5 ns;
  end process;

  --Simulate out of phase with the other 2 clocks
  fx3 : process
  begin
    wait for 126 ps;
    fx3clk <= '1';
    wait for 5 ns;
    fx3clk <= '0';
    wait for 4874 ps;
  end process;

end architecture Behavioral;

