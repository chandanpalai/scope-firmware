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
use ieee.numeric_std.all;

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

  --Configuration Links to modules
  --Pinout: 0=outdata, 1=outclk, 2=outint
  --        3=indata,  4=inclk,  5=inint
  adccfg         : inout std_logic_vector(5 downto 0);
  datawrappercfg : inout std_logic_vector(5 downto 0);
  inputcfg       : inout std_logic_vector(5 downto 0);
  monitoringcfg  : inout std_logic_vector(5 downto 0);
  lacfg          : inout std_logic_vector(5 downto 0)
);
end think;

---------------------------------------------------------------------------
architecture Behavioral of think is
---------------------------------------------------------------------------
  signal fsmclk : std_logic;
begin

  --Divide clk by 16 to get the speed for the fsm
  clkdiv : process(clk, sys_rst)
    variable count : unsigned(3 downto 0);
  begin
    if clk'event and clk = '1' then
      if sys_rst = '1' then
        count := TO_UNSIGNED(0, 4);
      else
        count := count + 1;
        if count = 0 then
          fsmclk <= not fsmclk;
        end if;
      end if;
    end if;
  end process;

end architecture Behavioral;

