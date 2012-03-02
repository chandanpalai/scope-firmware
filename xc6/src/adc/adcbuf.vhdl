---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : adcbuf.vhdl
--
-- Abstract    : Manually instantiates diff buffers for all the lines
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity adcbuf is
---------------------------------------------------------------------------
  port
  (
    bclk_p         : in std_logic;
    bclk_n         : in std_logic;
    fclk_p         : in std_logic;
    fclk_n         : in std_logic;

    d1a_p          : in std_logic;
    d1a_n          : in std_logic;
    d1b_p          : in std_logic;
    d1b_n          : in std_logic;
    d2a_p          : in std_logic;
    d2a_n          : in std_logic;
    d2b_p          : in std_logic;
    d2b_n          : in std_logic;
    d3a_p          : in std_logic;
    d3a_n          : in std_logic;
    d3b_p          : in std_logic;
    d3b_n          : in std_logic;
    d4a_p          : in std_logic;
    d4a_n          : in std_logic;
    d4b_p          : in std_logic;
    d4b_n          : in std_logic;

    buf_bclk_p     : out std_logic;
    buf_bclk_n     : out std_logic;
    buf_fclk_p     : out std_logic;
    buf_fclk_n     : out std_logic;
    buf_data_a_p   : out std_logic_vector(3 downto 0);
    buf_data_a_n   : out std_logic_vector(3 downto 0);
    buf_data_b_p   : out std_logic_vector(3 downto 0);
    buf_data_b_n   : out std_logic_vector(3 downto 0)
  );
end adcbuf;


---------------------------------------------------------------------------
architecture Behavioral of adcbuf is
---------------------------------------------------------------------------

  component IBUFGDS_DIFF_OUT
    generic(
             DIFF_TERM    : boolean :=  FALSE;
             IBUF_LOW_PWR : boolean :=  TRUE;
             IOSTANDARD   : string  := "DEFAULT"
           );
    port(
          O  : out   STD_ULOGIC;
          OB : out   STD_ULOGIC;

          I  : in    STD_ULOGIC;
          IB : in    STD_ULOGIC
        );
  end component IBUFGDS_DIFF_OUT;

  component IBUFDS_DIFF_OUT
    generic(
             DIFF_TERM    : boolean :=  FALSE;
             IBUF_LOW_PWR : boolean :=  TRUE;
             IOSTANDARD   : string  := "DEFAULT"
           );
    port(
          O  : out   STD_ULOGIC;
          OB : out   STD_ULOGIC;

          I  : in    STD_ULOGIC;
          IB : in    STD_ULOGIC
        );
  end component IBUFDS_DIFF_OUT;

begin
  Inst_bclk_bufgds : IBUFGDS_DIFF_OUT
  generic map (
                DIFF_TERM    => TRUE,
                IBUF_LOW_PWR => FALSE,
                IOSTANDARD   => "LVDS_33"
                )
  port map (
             O  => buf_bclk_p,
             OB => buf_bclk_n,
             I  => bclk_p,
             IB => bclk_n
             );

  Inst_fclk_bufgds : IBUFGDS_DIFF_OUT
  generic map (
                DIFF_TERM    => TRUE,
                IBUF_LOW_PWR => FALSE,
                IOSTANDARD   => "LVDS_33"
                )
  port map (
             O  => buf_fclk_p,
             OB => buf_fclk_n,
             I  => fclk_p,
             IB => fclk_n
             );

  Inst_d1a_bufds : IBUFDS_DIFF_OUT
  generic map (
                DIFF_TERM    => TRUE,
                IBUF_LOW_PWR => FALSE,
                IOSTANDARD   => "LVDS_33"
                )
  port map (
             O  => buf_data_a_p(0),
             OB => buf_data_a_n(0),
             I  => d1a_p,
             IB => d1a_n
             );

  Inst_d1b_bufds : IBUFDS_DIFF_OUT
  generic map (
                DIFF_TERM    => TRUE,
                IBUF_LOW_PWR => FALSE,
                IOSTANDARD   => "LVDS_33"
                )
  port map (
             O  => buf_data_b_p(0),
             OB => buf_data_b_n(0),
             I  => d1b_p,
             IB => d1b_n
             );

  Inst_d2a_bufds : IBUFDS_DIFF_OUT
  generic map (
                DIFF_TERM    => TRUE,
                IBUF_LOW_PWR => FALSE,
                IOSTANDARD   => "LVDS_33"
                )
  port map (
             O  => buf_data_a_p(1),
             OB => buf_data_a_n(1),
             I  => d2a_p,
             IB => d2a_n
             );

  Inst_d2b_bufds : IBUFDS_DIFF_OUT
  generic map (
                DIFF_TERM    => TRUE,
                IBUF_LOW_PWR => FALSE,
                IOSTANDARD   => "LVDS_33"
                )
  port map (
             O  => buf_data_b_p(1),
             OB => buf_data_b_n(1),
             I  => d2b_p,
             IB => d2b_n
             );

  Inst_d3a_bufds : IBUFDS_DIFF_OUT
  generic map (
                DIFF_TERM    => TRUE,
                IBUF_LOW_PWR => FALSE,
                IOSTANDARD   => "LVDS_33"
                )
  port map (
             O  => buf_data_a_p(2),
             OB => buf_data_a_n(2),
             I  => d3a_p,
             IB => d3a_n
             );

  Inst_d3b_bufds : IBUFDS_DIFF_OUT
  generic map (
                DIFF_TERM    => TRUE,
                IBUF_LOW_PWR => FALSE,
                IOSTANDARD   => "LVDS_33"
                )
  port map (
             O  => buf_data_b_p(2),
             OB => buf_data_b_n(2),
             I  => d3b_p,
             IB => d3b_n
             );

  Inst_d4a_bufds : IBUFDS_DIFF_OUT
  generic map (
                DIFF_TERM    => TRUE,
                IBUF_LOW_PWR => FALSE,
                IOSTANDARD   => "LVDS_33"
                )
  port map (
             O  => buf_data_a_p(3),
             OB => buf_data_a_n(3),
             I  => d4a_p,
             IB => d4a_n
             );

  Inst_d4b_bufds : IBUFDS_DIFF_OUT
  generic map (
                DIFF_TERM    => TRUE,
                IBUF_LOW_PWR => FALSE,
                IOSTANDARD   => "LVDS_33"
                )
  port map (
             O  => buf_data_b_p(3),
             OB => buf_data_b_n(3),
             I  => d4b_p,
             IB => d4b_n
             );

end architecture Behavioral;

