---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : cfgcontroller.vhd
--
-- Abstract    : Handles a bit of the configuration packet decoding for each module
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------------------------
entity cfgcontroller is
---------------------------------------------------------------------------
port
(
  sys_rst : in std_logic;

  --Link to Think module
  cfg     : inout std_logic_vector(5 downto 0);

  --Link to decoding/handling fsm for each system
  out_register : out std_logic_vector(6 downto 0);
  out_rw       : out std_logic;
  out_data     : out std_logic_vector(7 downto 0);
  out_valid    : out std_logic;

  in_register  : in std_logic_vector(6 downto 0);
  in_data      : in std_logic_vector(7 downto 0);
  in_valid     : std_logic
);
end cfgcontroller;


---------------------------------------------------------------------------
architecture Behavioral of cfgcontroller is
---------------------------------------------------------------------------

begin

end architecture Behavioral;

