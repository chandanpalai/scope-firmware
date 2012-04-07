---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : input.vhd
--
-- Abstract    : Input board I2C interfacing module
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------------------------
entity input is
---------------------------------------------------------------------------
port
(
  sys_rst : in std_logic;
  clk     : in std_logic;

  --External interface
  sda : inout std_logic;
  scl : inout std_logic;

  --Internal interface
  cfg : inout std_logic_vector(5 downto 0)
);
end input;


---------------------------------------------------------------------------
architecture Behavioral of input is
---------------------------------------------------------------------------

begin

end architecture Behavioral;

