---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : main.vhd
--
-- Abstract    : LL shifter for the FX3 data lines
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity main is
---------------------------------------------------------------------------
port
(
  fx3_slcs_n    : out std_logic;
  fx3_slwr_n    : out std_logic;
  fx3_sloe_n    : out std_logic;
  fx3_slrd_n    : out std_logic;
  fx3_flaga     : in std_logic;
  fx3_flagb     : in std_logic;
  fx3_pktend_n  : out std_logic;
  fx3_fifoadr   : out std_logic_vector(1 downto 0);
  fx3_dq        : inout std_logic_vector(31 downto 0);
  fx3_clk       : in std_logic;

  fpga_slcs_n   : in std_logic;
  fpga_slwr_n   : in std_logic;
  fpga_sloe_n   : in std_logic;
  fpga_slrd_n   : in std_logic;
  fpga_flaga    : out std_logic;
  fpga_flagb    : out std_logic;
  fpga_pktend_n : in std_logic;
  fpga_fifoadr  : in std_logic_vector(1 downto 0);
  fpga_dq       : inout std_logic_vector(31 downto 0);
  fpga_clk      : out std_logic
);
end main;

---------------------------------------------------------------------------
architecture Behavioral of main is
---------------------------------------------------------------------------
  component BUFG
    port(
          O : out std_ulogic;

          I : in std_ulogic
        );
  end component BUFG;

begin
  fx3_slcs_n <= fpga_slcs_n;
  fx3_slwr_n <= fpga_slwr_n;
  fx3_sloe_n <= fpga_sloe_n;
  fx3_slrd_n <= fpga_slrd_n;
  fpga_flaga <= fx3_flaga;
  fpga_flagb <= fx3_flagb;
  fx3_pktend_n <= fpga_pktend_n;
  fx3_fifoadr <= fpga_fifoadr;

  Inst_fx3clk : BUFG
  port map (
             O => fpga_clk,
             I => fx3_clk
             );

  process (fx3_dq, fpga_dq, fpga_sloe_n)
  begin
    if fpga_sloe_n = '1' then
      fx3_dq <= fpga_dq;
      fpga_dq <= (others => 'Z');
    else
      fpga_dq <= fx3_dq;
      fx3_dq <= (others => 'Z');
    end if;
  end process;

end architecture Behavioral;

