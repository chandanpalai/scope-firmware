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

  buf_ddrclk    : out std_logic;
  buf_fsmclk    : out std_logic;
  buf_fx3clk_2x : out std_logic
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

  component DCM_SP
    generic (
              TimingChecksOn        : boolean := true;
              InstancePath          : string := "*";
              Xon                   : boolean := true;
              MsgOn                 : boolean := false;
              CLKDV_DIVIDE          : real := 2.0;
              CLKFX_DIVIDE          : integer := 1;
              CLKFX_MULTIPLY        : integer := 4;
              CLKIN_DIVIDE_BY_2     : boolean := false;
              CLKIN_PERIOD          : real := 10.0;                         --non-simulatable
              CLKOUT_PHASE_SHIFT    : string := "NONE";
              CLK_FEEDBACK          : string := "1X";
              DESKEW_ADJUST         : string := "SYSTEM_SYNCHRONOUS";     --non-simulatable
              DFS_FREQUENCY_MODE    : string := "LOW";
              DLL_FREQUENCY_MODE    : string := "LOW";
              DSS_MODE              : string := "NONE";                        --non-simulatable
              DUTY_CYCLE_CORRECTION : boolean := true;
              FACTORY_JF            : bit_vector := X"C080";                 --non-simulatable


              PHASE_SHIFT : integer := 0;


              STARTUP_WAIT : boolean := false                     --non-simulatable
            );
    port (
           CLK0     : out std_ulogic := '0';
           CLK180   : out std_ulogic := '0';
           CLK270   : out std_ulogic := '0';
           CLK2X    : out std_ulogic := '0';
           CLK2X180 : out std_ulogic := '0';
           CLK90    : out std_ulogic := '0';
           CLKDV    : out std_ulogic := '0';
           CLKFX    : out std_ulogic := '0';
           CLKFX180 : out std_ulogic := '0';
           LOCKED   : out std_ulogic := '0';
           PSDONE   : out std_ulogic := '0';
           STATUS   : out std_logic_vector(7 downto 0) := "00000000";

           CLKFB    : in std_ulogic := '0';
           CLKIN    : in std_ulogic := '0';
           DSSEN    : in std_ulogic := '0';
           PSCLK    : in std_ulogic := '0';
           PSEN     : in std_ulogic := '0';
           PSINCDEC : in std_ulogic := '0';
           RST      : in std_ulogic := '0'
         );
  end component DCM_SP;

  signal fx3clk_ibufg   : std_logic;
  signal buf_fx3clk_out : std_logic;

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
             O => fx3clk_ibufg,
             I => fx3clk
             );

  Inst_fx3dcm : DCM_SP
  generic map (
                TimingChecksOn        => true,
                InstancePath          => "*",
                Xon                   => true,
                MsgOn                 => false,
                CLKDV_DIVIDE          => 2.0,
                CLKFX_DIVIDE          => 1,
                CLKFX_MULTIPLY        => 4,
                CLKIN_DIVIDE_BY_2     => false,
                CLKIN_PERIOD          => 10.0,
                CLKOUT_PHASE_SHIFT    => "NONE",
                CLK_FEEDBACK          => "1X",
                DESKEW_ADJUST         => "SOURCE_SYNCHRONOUS",
                DFS_FREQUENCY_MODE    => "LOW",
                DLL_FREQUENCY_MODE    => "LOW",
                DSS_MODE              => "NONE",
                DUTY_CYCLE_CORRECTION => true,
                FACTORY_JF            => X"C080",
                PHASE_SHIFT           => 0,
                STARTUP_WAIT          => true
                )
  port map (
             CLK0     => buf_fx3clk_out,
             CLK180   => open,
             CLK270   => open,
             CLK2X    => buf_fx3clk_2x,
             CLK2X180 => open,
             CLK90    => open,
             CLKDV    => open,
             CLKFX    => open,
             CLKFX180 => open,
             LOCKED   => open,
             PSDONE   => open,
             STATUS   => open,
             CLKFB    => buf_fx3clk_out,
             CLKIN    => fx3clk_ibufg,
             DSSEN    => open,
             PSCLK    => open,
             PSEN     => open,
             PSINCDEC => open,
             RST      => open
             );


end architecture Behavioral;

