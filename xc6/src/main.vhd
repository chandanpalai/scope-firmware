---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : main.vhd
--
-- Abstract    : Top level file joining the modules together
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity main is
---------------------------------------------------------------------------
port
(
          --========================================
          --ADC
          --Serial interface
          adc_sdata  : out std_logic;
          adc_sclk   : out std_logic;
          adc_sreset : out std_logic;
          adc_csn    : out std_logic;

            --Data interface
          adc_bclk_p : in std_logic;
          adc_bclk_n : in std_logic;
          adc_fclk_p : in std_logic;
          adc_fclk_n : in std_logic;

          adc_d1a_p : in std_logic;
          adc_d1a_n : in std_logic;
          adc_d1b_p : in std_logic;
          adc_d1b_n : in std_logic;
          adc_d2a_p : in std_logic;
          adc_d2a_n : in std_logic;
          adc_d2b_p : in std_logic;
          adc_d2b_n : in std_logic;
          adc_d3a_p : in std_logic;
          adc_d3a_n : in std_logic;
          adc_d3b_p : in std_logic;
          adc_d3b_n : in std_logic;
          adc_d4a_p : in std_logic;
          adc_d4a_n : in std_logic;
          adc_d4b_p : in std_logic;
          adc_d4b_n : in std_logic;
          --========================================

          --========================================
          --Clocking
          clock_ddr_p : in std_logic;
          clock_ddr_n : in std_logic;
          clock_fsm_p : in std_logic;
          clock_fsm_n : in std_logic;
          clock_fx3   : in std_logic
          --========================================

);
end main;


---------------------------------------------------------------------------
architecture Behavioral of main is
---------------------------------------------------------------------------
  component adc
    generic (
              S              : integer := 8; --SERDES factor
              NUM_DATA_PAIRS : natural := 8 --Num of A+B pairs
            );
    port (
          sys_rst : in std_logic;
          fsmclk  : in std_logic;

            --Serial interface
          sdata  : out std_logic;
          sclk   : out std_logic;
          sreset : out std_logic;
          csn    : out std_logic;

            --Data interface
          bclk_p : in std_logic;
          bclk_n : in std_logic;
          fclk_p : in std_logic;
          fclk_n : in std_logic;

          d1a_p : in std_logic;
          d1a_n : in std_logic;
          d1b_p : in std_logic;
          d1b_n : in std_logic;
          d2a_p : in std_logic;
          d2a_n : in std_logic;
          d2b_p : in std_logic;
          d2b_n : in std_logic;
          d3a_p : in std_logic;
          d3a_n : in std_logic;
          d3b_p : in std_logic;
          d3b_n : in std_logic;
          d4a_p : in std_logic;
          d4a_n : in std_logic;
          d4b_p : in std_logic;
          d4b_n : in std_logic;

            --Internal config interface
          pktoutadc    : in std_logic_vector(15 downto 0);
          pktoutadcclk : in std_logic;
          pktinadc     : out std_logic_vector(15 downto 0);
          pktinadcclk  : out std_logic;

            --Internal data interface
          data    : out std_logic_vector(NUM_DATA_PAIRS*S-1 downto 0);
          dataclk : out std_logic
        );
  end component adc;

  component clockbuf
  port (
          ddrclk_p : in std_logic;
          ddrclk_n : in std_logic;
          fsmclk_p : in std_logic;
          fsmclk_n : in std_logic;
          fx3clk   : in std_logic;

          buf_ddrclk : out std_logic;
          buf_fsmclk : out std_logic;
          buf_fx3clk : out std_logic
        );
  end component clockbuf;

  signal sys_rst : std_logic;
  signal fsmclk  : std_logic;
  signal ddrclk  : std_logic;
  signal fx3clk  : std_logic;

  signal pktoutadc, pktinadc       : std_logic_vector(15 downto 0);
  signal pktoutadcclk, pktinadcclk : std_logic;

  signal adcdata    : std_logic_vector(63 downto 0);
  signal adcdataclk : std_logic;

begin
  Inst_clockbuf : clockbuf
  port map (
             ddrclk_p   => clock_ddr_p,
             ddrclk_n   => clock_ddr_n,
             fsmclk_p   => clock_fsm_p,
             fsmclk_n   => clock_fsm_n,
             fx3clk     => clock_fx3,
             buf_ddrclk => ddrclk,
             buf_fsmclk => fsmclk,
             buf_fx3clk => fx3clk
             );

  Inst_adc : adc
  generic map (
                S              => 8,
                NUM_DATA_PAIRS => 8
               )
  port map (
             sys_rst      => sys_rst,
             fsmclk       => fsmclk,
             sdata        => adc_sdata,
             sclk         => adc_sclk,
             sreset       => adc_sreset,
             csn          => adc_csn,
             bclk_p       => adc_bclk_p,
             bclk_n       => adc_bclk_n,
             fclk_p       => adc_fclk_p,
             fclk_n       => adc_fclk_n,
             d1a_p        => adc_d1a_p,
             d1a_n        => adc_d1a_n,
             d1b_p        => adc_d1b_p,
             d1b_n        => adc_d1b_n,
             d2a_p        => adc_d2a_p,
             d2a_n        => adc_d2a_n,
             d2b_p        => adc_d2b_p,
             d2b_n        => adc_d2b_n,
             d3a_p        => adc_d3a_p,
             d3a_n        => adc_d3a_n,
             d3b_p        => adc_d3b_p,
             d3b_n        => adc_d3b_n,
             d4a_p        => adc_d4a_p,
             d4a_n        => adc_d4a_n,
             d4b_p        => adc_d4b_p,
             d4b_n        => adc_d4b_n,
             pktoutadc    => pktoutadc,
             pktoutadcclk => pktoutadcclk,
             pktinadc     => pktinadc,
             pktinadcclk  => pktinadcclk,
             data         => adcdata,
             dataclk      => adcdataclk
             );


end architecture Behavioral;

