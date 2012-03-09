---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : fx3.vhd
--
-- Abstract    : Implements communication to an FX3 via the slave fifo
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity fx3 is
---------------------------------------------------------------------------
port
(
  sys_rst : in std_logic;
  clk     : in std_logic;

  --FX3 interface
  slcs_n  : out std_logic;
  slwr_n  : out std_logic;
  sloe_n  : out std_logic;
  slrd_n  : out std_logic;
  flaga   : in std_logic;
  flgab   : in std_logic;
  pktend  : out std_logic;
  fifoadr : out std_logic_vector(1 downto 0);
  dq      : out std_logic_vector(31 downto 0);

  --Internal interface
  adcdata    : in std_logic_vector(63 downto 0);
  adcdataclk : in std_logic;

  cfgin    : in std_logic_vector(31 downto 0);
  cfginclk : in std_logic;

  cfgout    : out std_logic_vector(31 downto 0);
  cfgoutclk : out std_logic;
);
end fx3;


---------------------------------------------------------------------------
architecture Behavioral of fx3 is
---------------------------------------------------------------------------

begin

end architecture Behavioral;

