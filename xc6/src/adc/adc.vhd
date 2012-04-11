---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : adc.vhd
--
-- Abstract    : Top level ADC module to interface with the HMCAD15xx
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity adc is
---------------------------------------------------------------------------
  generic
  (
    S              : integer := 8; --SERDES factor
    NUM_DATA_PAIRS : natural := 8 --Num of A+B pairs
  );
  port
  (
    sys_rst      : in std_logic;
    fsmclk       : in std_logic;

    --Serial interface
    sdata        : out std_logic;
    sclk         : out std_logic;
    sreset       : out std_logic;
    cs_n          : out std_logic;

    --Data interface
    bclk_p       : in std_logic;
    bclk_n       : in std_logic;
    fclk_p       : in std_logic;
    fclk_n       : in std_logic;

    d1a_p        : in std_logic;
    d1a_n        : in std_logic;
    d1b_p        : in std_logic;
    d1b_n        : in std_logic;
    d2a_p        : in std_logic;
    d2a_n        : in std_logic;
    d2b_p        : in std_logic;
    d2b_n        : in std_logic;
    d3a_p        : in std_logic;
    d3a_n        : in std_logic;
    d3b_p        : in std_logic;
    d3b_n        : in std_logic;
    d4a_p        : in std_logic;
    d4a_n        : in std_logic;
    d4b_p        : in std_logic;
    d4b_n        : in std_logic;

    --Internal config interface
    cfg : inout std_logic_vector(4 downto 0);

    --Internal data interface
    datard          : out std_logic_vector(NUM_DATA_PAIRS*S-1 downto 0);
    datard_clk      : in std_logic;
    datard_en       : in std_logic;
    datard_full     : out std_logic;
    datard_empty    : out std_logic;
    datard_rd_count : out std_logic_vector(14 downto 0);
    datard_wr_count : out std_logic_vector(14 downto 0)
  );
end adc;


---------------------------------------------------------------------------
architecture Behavioral of adc is
---------------------------------------------------------------------------
  component adcbclk
    generic (S : integer := 8); --SERDES factor
    port (
          bclk_p : in std_logic;
          bclk_n : in std_logic;

          reset        : in std_logic;
          cal_en       : in std_logic;
          cal_slave_en : in std_logic;
          cal_busy     : out std_logic;

          rx_bclk_p       : out std_logic;
          rx_bclk_n       : out std_logic;
          rx_pktclk       : out std_logic;
          rx_serdesstrobe : out std_logic
        );
  end component adcbclk;

  component adcfclk
    generic (S : integer := 8); --SERDES factor
    port (
      fclk_p : in std_logic;
      fclk_n : in std_logic;

      bclk_p       : in std_logic;
      bclk_n       : in std_logic;
      serdesstrobe : in std_logic;
      pktclk       : in std_logic;

      reset        : in std_logic;
      cal_en       : in std_logic;
      cal_slave_en : in std_logic;
      cal_busy     : out std_logic;

      delay_inc    : out std_logic;
      delay_inc_en : out std_logic;
      bitslip      : out std_logic;

      rx_fclk : out std_logic
    );
  end component adcfclk;

  component adcdata
    generic (
              S              : integer := 8; --SERDES factor
              NUM_DATA_PAIRS : natural := 8  --Num of A+B pairs
            );
  port (
        bclk_p       : in std_logic;
        bclk_n       : in std_logic;
        fclk         : in std_logic;
        serdesstrobe : in std_logic;

        bitslip_p : in std_logic;
        bitslip_n : in std_logic;
        delay_inc : in std_logic;
        delay_en  : in std_logic;

        reset        : in std_logic;
        cal_en       : in std_logic;
        cal_slave_en : in std_logic;
        cal_busy     : out std_logic;

        data_in  : in std_logic_vector((NUM_DATA_PAIRS*2)-1 downto 0);
        data_out : out std_logic_vector((NUM_DATA_PAIRS*S)-1 downto 0);
        valid    : out std_logic
      );
  end component adcdata;

  component adcbuf
    port (
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

          buf_bclk_p   : out std_logic;
          buf_bclk_n   : out std_logic;
          buf_fclk_p   : out std_logic;
          buf_fclk_n   : out std_logic;
          buf_data_a_p : out std_logic_vector(3 downto 0);
          buf_data_a_n : out std_logic_vector(3 downto 0);
          buf_data_b_p : out std_logic_vector(3 downto 0);
          buf_data_b_n : out std_logic_vector(3 downto 0)
        );
  end component adcbuf;

  component adccal
    port (
          sys_rst : in std_logic;
          fsmclk  : in std_logic;

          reset        : out std_logic;
          cal_en       : out std_logic;
          cal_busy     : in std_logic;
          cal_slave_en : out std_logic
        );
  end component adccal;

  component adcdatafifo
    port (
          wr_clk : in std_logic;
          rd_clk : in std_logic;
          rst    : in std_logic;
          din    : in std_logic_vector(63 downto 0);
          wr_en  : in std_logic;
          rd_en  : in std_logic;
          dout   : out std_logic_vector(63 downto 0);
          full   : out std_logic;
          empty  : out std_logic;

          rd_data_count : out std_logic_vector(14 downto 0);
          wr_data_count : out std_logic_vector(14 downto 0)
         );
  end component adcdatafifo;

  component adcspi
    port (
          sys_rst : in std_logic;
          clk     : in std_logic;

        --External inteface
          sdata  : out std_logic;
          sclk   : out std_logic;
          sreset : out std_logic;
          cs_n    : out std_logic;

        --Internal interface
          cfg : inout std_logic_vector(4 downto 0)

        );
  end component adcspi;


  signal buf_bclk_p, buf_bclk_n     : std_logic;
  signal buf_fclk_p, buf_fclk_n     : std_logic;
  signal buf_data_a_p, buf_data_a_n : std_logic_vector(3 downto 0);
  signal buf_data_b_p, buf_data_b_n : std_logic_vector(3 downto 0);
  signal reset, cal_busy            : std_logic;
  signal cal_b_busy, cal_f_busy     : std_logic;
  signal cal_d_busy                 : std_logic;
  signal cal_en, cal_slave_en       : std_logic;
  signal rx_bclk_p, rx_bclk_n       : std_logic;
  signal rx_pktclk, rx_serdesstrobe : std_logic;
  signal rx_fclk                    : std_logic;
  signal delay_inc, delay_inc_en    : std_logic;
  signal bitslip                    : std_logic;
  signal data_in                    : std_logic_vector(NUM_DATA_PAIRS*2-1 downto 0);
  signal data_out                   : std_logic_vector(NUM_DATA_PAIRS*S-1 downto 0);
  signal fclk_int                   : std_logic;
  signal dropdata                   : std_logic := '0';
  signal datard_full_int            : std_logic;

begin
  cal_busy     <= cal_b_busy or cal_f_busy or cal_d_busy;
  fclk_int     <= rx_fclk and not cal_busy;
  datard_full  <= datard_full_int;
  dropdata     <= datard_full_int; --TODO: add more logic here...
  DIN : for n in 0 to 3 generate
    data_in(4*n)   <= buf_data_a_p(n);
    data_in(4*n+1) <= buf_data_a_n(n);
    data_in(4*n+2) <= buf_data_b_p(n);
    data_in(4*n+3) <= buf_data_b_n(n);
  end generate;

  Inst_adcbuf : adcbuf
  port map (
             bclk_p       => bclk_p,
             bclk_n       => bclk_n,
             fclk_p       => fclk_p,
             fclk_n       => fclk_n,
             d1a_p        => d1a_p,
             d1a_n        => d1a_n,
             d1b_p        => d1b_p,
             d1b_n        => d1b_n,
             d2a_p        => d2a_p,
             d2a_n        => d2a_n,
             d2b_p        => d2b_p,
             d2b_n        => d2b_n,
             d3a_p        => d3a_p,
             d3a_n        => d3a_n,
             d3b_p        => d3b_p,
             d3b_n        => d3b_n,
             d4a_p        => d4a_p,
             d4a_n        => d4a_n,
             d4b_p        => d4b_p,
             d4b_n        => d4b_n,
             buf_bclk_p   => buf_bclk_p,
             buf_bclk_n   => buf_bclk_n,
             buf_fclk_p   => buf_fclk_p,
             buf_fclk_n   => buf_fclk_n,
             buf_data_a_p => buf_data_a_p,
             buf_data_a_n => buf_data_a_n,
             buf_data_b_p => buf_data_b_p,
             buf_data_b_n => buf_data_b_n
             );

  Inst_adccal : adccal
  port map (
             sys_rst      => sys_rst,
             fsmclk       => fsmclk,
             reset        => reset,
             cal_en       => cal_en,
             cal_slave_en => cal_slave_en,
             cal_busy     => cal_busy
             );

  Inst_adcbclk : adcbclk
  generic map (
                S => S
              )
  port map (
             bclk_p          => buf_bclk_p,
             bclk_n          => buf_bclk_n,
             reset           => reset,
             cal_en          => cal_en,
             cal_slave_en    => cal_slave_en,
             cal_busy        => cal_b_busy,
             rx_bclk_p       => rx_bclk_p,
             rx_bclk_n       => rx_bclk_n,
             rx_pktclk       => rx_pktclk,
             rx_serdesstrobe => rx_serdesstrobe
             );

  Inst_adcfclk : adcfclk
  generic map (
                S => S
              )
  port map (
             fclk_p       => buf_fclk_p,
             fclk_n       => buf_fclk_n,
             bclk_p       => rx_bclk_p,
             bclk_n       => rx_bclk_n,
             serdesstrobe => rx_serdesstrobe,
             pktclk       => rx_pktclk,
             reset        => reset,
             cal_en       => cal_en,
             cal_slave_en => cal_slave_en,
             cal_busy     => cal_f_busy,
             delay_inc    => delay_inc,
             delay_inc_en => delay_inc_en,
             bitslip      => bitslip,
             rx_fclk      => rx_fclk
             );

  Inst_adcdata : adcdata
  generic map (
                S              => S,
                NUM_DATA_PAIRS => NUM_DATA_PAIRS
                )
  port map (
             bclk_p       => rx_bclk_p,
             bclk_n       => rx_bclk_n,
             fclk         => rx_fclk,
             serdesstrobe => rx_serdesstrobe,
             bitslip_p    => bitslip,
             bitslip_n    => bitslip,
             delay_inc    => delay_inc,
             delay_en     => delay_inc_en,
             reset        => reset,
             cal_en       => cal_en,
             cal_slave_en => cal_slave_en,
             cal_busy     => cal_d_busy,
             data_in      => data_in,
             data_out     => data_out,
             valid        => open
             );

  Inst_adcdatafifo : adcdatafifo
  port map (
             wr_clk => fclk_int,
             rst    => reset,
             din    => data_out,
             wr_en  => (not dropdata),
             rd_en  => datard_en,
             rd_clk => datard_clk,
             dout   => datard,
             full   => datard_full_int,
             empty  => datard_empty,

             rd_data_count => datard_rd_count,
             wr_data_count => datard_wr_count
             );

  Inst_adcspi : adcspi
  port map (
             sys_rst => sys_rst,
             clk     => fsmclk,
             sdata   => sdata,
             sclk    => sclk,
             sreset  => sreset,
             cs_n    => cs_n,
             cfg     => cfg
             );


end architecture Behavioral;

