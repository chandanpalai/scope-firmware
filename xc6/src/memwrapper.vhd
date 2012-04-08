---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : memwrapper.vhd
--
-- Abstract    : Abstracts away the boring parts of interfacing with the MIG
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity memwrapper is
---------------------------------------------------------------------------
port
(
  sys_rst : in std_logic;
  clk     : in std_logic;

  --mcb interface
  mcb3_dram_dq        : inout  std_logic_vector(C3_NUM_DQ_PINS-1 downto 0);
  mcb3_dram_a         : out std_logic_vector(C3_MEM_ADDR_WIDTH-1 downto 0);
  mcb3_dram_ba        : out std_logic_vector(C3_MEM_BANKADDR_WIDTH-1 downto 0);
  mcb3_dram_ras_n     : out std_logic;
  mcb3_dram_cas_n     : out std_logic;
  mcb3_dram_we_n      : out std_logic;
  mcb3_dram_odt       : out std_logic;
  mcb3_dram_reset_n   : out std_logic;
  mcb3_dram_cke       : out std_logic;
  mcb3_dram_dm        : out std_logic;
  mcb3_dram_udqs      : inout  std_logic;
  mcb3_dram_udqs_n    : inout  std_logic;
  mcb3_rzq            : inout  std_logic;
  mcb3_zio            : inout  std_logic;
  mcb3_dram_udm       : out std_logic;
  mcb3_dram_dqs       : inout  std_logic;
  mcb3_dram_dqs_n     : inout  std_logic;
  mcb3_dram_ck        : out std_logic;
  mcb3_dram_ck_n      : out std_logic;

  --adc data

);
end memwrapper;


---------------------------------------------------------------------------
architecture Behavioral of memwrapper is
---------------------------------------------------------------------------

begin

end architecture Behavioral;

