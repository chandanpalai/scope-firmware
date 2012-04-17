---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : think_tb.vhd
--
-- Abstract    : Test bench for the think module
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity think_tb is
---------------------------------------------------------------------------
end think_tb;


---------------------------------------------------------------------------
architecture Behavioral of think_tb is
---------------------------------------------------------------------------
  component think
    port (
          sys_rst : in std_logic;
          clk     : in std_logic;

        --FX3 interface
          cfgout    : in std_logic_vector(31 downto 0);
          cfgoutclk : in std_logic;
          cfgin     : out std_logic_vector(31 downto 0);
          cfginclk  : out std_logic;

        --Configuration Bus
          adccfg         : inout std_logic_vector(5 downto 0);
          datawrappercfg : inout std_logic_vector(5 downto 0);
          inputcfg       : inout std_logic_vector(5 downto 0);
          monitoringcfg  : inout std_logic_vector(5 downto 0);
          lacfg          : inout std_logic_vector(5 downto 0)
        );
  end component think;

  signal clk_int      : std_logic := '1';
  signal cfgclk_int   : std_logic := '1';
  signal reset        : std_logic;
  signal cfgout       : std_logic_vector(31 downto 0);
  signal cfgoutclk    : std_logic;
  signal cfgbusout    : std_logic;
  signal cfgbusoutclk : std_logic;

begin

  Inst_think : think
  port map (
             sys_rst      => reset,
             clk          => clk_int,
             cfgout       => cfgout,
             cfgoutclk    => cfgoutclk,
             --cfgin        => ,
             --cfginclk     => ,
             cfgbusout    => cfgbusout,
             cfgbusoutclk => cfgbusoutclk,
             cfgbusin     => (others => '0'),
             cfgbusinclk  => '0',
             cfgbusinbusy => '0'
             );


  clk : process
  begin
    clk_int <= '1';
    wait for 10 ns;
    clk_int <= '0';
    wait for 10 ns;
  end process;

  ctrl : process
  begin
    reset     <= '1';
    cfgoutclk <= '0';
    wait for 100 ns;
    reset     <= '0';

    cfgout    <= x"AAA0010F";
    cfgoutclk <= '1';
    wait for 1 us;
    cfgoutclk <= '0';
    wait for 1 us;

    cfgout    <= x"AAA1000F";
    cfgoutclk <= '1';
    wait for 1 us;
    cfgoutclk <= '0';
    wait for 1 us;

    wait;
  end process;

end architecture Behavioral;

