---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : adcspi.vhd
--
-- Abstract    : SPI interface module for the ADC
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------------------------
entity adcspi is
---------------------------------------------------------------------------
port
(
  sys_rst : in std_logic;
  clk     : in std_logic;

  --External inteface
  sdata  : out std_logic;
  sclk   : out std_logic;
  sreset : out std_logic;
  cs_n    : out std_logic;

  --Internal interface
  cfg     : inout std_logic_vector(5 downto 0)

);
end adcspi;


---------------------------------------------------------------------------
architecture Behavioral of adcspi is
---------------------------------------------------------------------------

begin

end architecture Behavioral;

