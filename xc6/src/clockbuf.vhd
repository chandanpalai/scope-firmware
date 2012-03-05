---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : clockbuf.vhd
--
-- Abstract    : Manually instantiate clock buffers
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity clockbuf is
---------------------------------------------------------------------------
port
(
  ddrclk_p : in std_logic;
  ddrclk_n : in std_logic;
  fsmclk_p : in std_logic;
  fsmclk_n : in std_logic;
  fx3clk   : in std_logic;

  buf_ddrclk : out std_logic;
  buf_fsmclk : out std_logic;
  buf_fx3clk : out std_logic
);
end clockbuf;


---------------------------------------------------------------------------
architecture Behavioral of clockbuf is
---------------------------------------------------------------------------
  component IBUFGDS
    generic(
             CAPACITANCE      : string  := "DONT_CARE";
             DIFF_TERM        : boolean :=  FALSE;
             IBUF_DELAY_VALUE : string := "0";
             IBUF_LOW_PWR     : boolean :=  TRUE;
             IOSTANDARD       : string  := "DEFAULT"
           );
    port(
          O : out std_ulogic;

          I  : in std_ulogic;
          IB : in std_ulogic
        );
  end component IBUFGDS;

  component IBUFG
    generic(
             CAPACITANCE      : string := "DONT_CARE";
             IBUF_DELAY_VALUE : string := "0";
             IBUF_LOW_PWR     : boolean :=  TRUE;
             IOSTANDARD       : string := "DEFAULT"
           );
    port(
          O : out std_ulogic;

          I : in std_ulogic
        );
  end component IBUFG;

begin

  Inst_ddrclk_bufgds : IBUFGDS
  generic map (
                CAPACITANCE      => "DONT_CARE",
                DIFF_TERM        => TRUE,
                IBUF_DELAY_VALUE => "0",
                IBUF_LOW_PWR     => FALSE,
                IOSTANDARD       => "LVDS_33"
                )
  port map (
             O  => buf_ddrclk,
             I  => ddrclk_p,
             IB => ddrclk_n
             );

  Inst_fsmclk_bufgds : IBUFGDS
  generic map (
                CAPACITANCE      => "DONT_CARE",
                DIFF_TERM        => TRUE,
                IBUF_DELAY_VALUE => "0",
                IBUF_LOW_PWR     => FALSE,
                IOSTANDARD       => "LVDS_33"
                )
  port map (
             O  => buf_fsmclk,
             I  => fsmclk_p,
             IB => fsmclk_n
             );

  Inst_fx3clk : IBUFG
  generic map (
                CAPACITANCE      => "DONT_CARE",
                IBUF_DELAY_VALUE => "0",
                IBUF_LOW_PWR     => FALSE,
                IOSTANDARD       => "LVDS_33"
                )
  port map (
             O => buf_fx3clk,
             I => fx3clk
             );

end architecture Behavioral;

