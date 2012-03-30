---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : think.vhd
--
-- Abstract    : Central command system for the scope
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------------------------
entity think is
---------------------------------------------------------------------------
port
(
  sys_rst : in std_logic;
  clk     : in std_logic;

  --FX3 interface
  cfgout    : in std_logic_vector(31 downto 0);
  cfgoutclk : in std_logic;
  cfgin     : out std_logic_vector(31 downto 0);
  cfginclk  : out std_logic;

  --Configuration Bus
  cfgbusout    : out std_logic_vector(15 downto 0);
  cfgbusoutclk : out std_logic;
  cfgbusin     : in std_logic_vector(15 downto 0);
  cfgbusinclk  : in std_logic;
  cfgbusinbusy : in std_logic
);
end think;

---------------------------------------------------------------------------
architecture Behavioral of think is
---------------------------------------------------------------------------

  component

  type state_type is (st0_address, st1_regval);
  signal cfgout_state : state_type;

begin
  cfgout : process(cfgoutclk, sys_rst)
  begin
    if cfgout'event and cfgoutclk = '1' then
      if sys_rst = '1' then
        cfgout_state <= st0_default;
      end if;
    else
      case cfgout_state is
        when st0_address =>
      end case;
    end if;
  end process;

end architecture Behavioral;

