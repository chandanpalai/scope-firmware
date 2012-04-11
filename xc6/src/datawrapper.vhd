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
  cfg : inout std_logic_vector(4 downto 0);

  --ADC data interface
  adc_datard          : in std_logic_vector(63 downto 0);
  adc_datard_clk      : out std_logic;
  adc_datard_en       : out std_logic;
  adc_datard_full     : in std_logic;
  adc_datard_empty    : in std_logic;
  adc_datard_rd_count : in std_logic_vector(14 downto 0);
  adc_datard_wr_count : in std_logic_vector(14 downto 0);

  --DDR interface
  c3_p0_cmd_clk       : out std_logic;
  c3_p0_cmd_en        : out std_logic;
  c3_p0_cmd_instr     : out std_logic_vector(2 downto 0);
  c3_p0_cmd_bl        : out std_logic_vector(5 downto 0);
  c3_p0_cmd_byte_addr : out std_logic_vector(29 downto 0);
  c3_p0_cmd_empty     : in std_logic;
  c3_p0_cmd_full      : in std_logic;
  c3_p0_wr_clk        : out std_logic;
  c3_p0_wr_en         : out std_logic;
  c3_p0_wr_mask       : out std_logic_vector(15 downto 0);
  c3_p0_wr_data       : out std_logic_vector(127 downto 0);
  c3_p0_wr_full       : in std_logic;
  c3_p0_wr_empty      : in std_logic;
  c3_p0_wr_count      : in std_logic_vector(6 downto 0);
  c3_p0_wr_underrun   : in std_logic;
  c3_p0_wr_error      : in std_logic;
  c3_p0_rd_clk        : out std_logic;
  c3_p0_rd_en         : out std_logic;
  c3_p0_rd_data       : in std_logic_vector(127 downto 0);
  c3_p0_rd_full       : in std_logic;
  c3_p0_rd_empty      : in std_logic;
  c3_p0_rd_count      : in std_logic_vector(6 downto 0);
  c3_p0_rd_overflow   : in std_logic;
  c3_p0_rd_error      : in std_logic;

  --FX3 interface
  fx3_adcdata    : out std_logic_vector(63 downto 0);
  fx3_adcdataclk : out std_logic;
  fx3_adcdataen  : out std_logic
);
end datawrapper;


---------------------------------------------------------------------------
architecture Behavioral of datawrapper is
---------------------------------------------------------------------------

begin
  --Tie pins low as required by ug38x
  c3_p0_cmd_byte_addr(2 downto 0) <= "000";

  --No need for 3 different clocks!
  c3_p0_cmd_clk <= clk;
  c3_p0_wr_clk  <= clk;
  c3_p0_rd_clk  <= clk;

  cfg <= (others => 'Z');

  ctrl : process(clk, sys_rst)
  begin
    if clk'event and clk = '1' then
      if sys_rst = '1' then
      else
      end if;
    end if;
  end process;

end architecture Behavioral;

