---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : datawrapper.vhd
--
-- Abstract    : Redirects the data from the adc buffer to either the DDR3 memory module, or to the FX3 depending on load
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------------------------
entity datawrapper is
---------------------------------------------------------------------------
port
(
  sys_rst : in std_logic;
  clk     : in std_logic;

  --Think interface
  cfg : inout std_logic_vector(5 downto 0);

  --ADC data interface
  adcdata       : in std_logic_vector(63 downto 0);
  adcdata_clk   : out std_logic;
  adcdata_en    : out std_logic;
  adcdata_full  : in std_logic;
  adcdata_empty : in std_logic;
  adcdata_rd_count : in std_logic_vector(14 downto 0);
  adcdata_wr_count : in std_logic_vector(14 downto 0)

  --DDR interface

  --FX3 interface
);
end datawrapper;


---------------------------------------------------------------------------
architecture Behavioral of datawrapper is
---------------------------------------------------------------------------

begin

end architecture Behavioral;

