---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : monitoring.vhd
--
-- Abstract    : Power supply monitoring I2C interfacing module
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------------------------
entity monitoring is
---------------------------------------------------------------------------
port
(
  sys_rst : in std_logic;
  clk     : in std_logic;

  --External interface
  sda : inout std_logic;
  scl : inout std_logic;

  --Internal interface
  cfg : inout std_logic_vector(4 downto 0)
);
end monitoring;


---------------------------------------------------------------------------
architecture Behavioral of monitoring is
---------------------------------------------------------------------------

begin
  cfg <= (others => 'Z');

end architecture Behavioral;

