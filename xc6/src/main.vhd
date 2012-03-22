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
  generic
  (
    S              : integer := 8; --SERDES factor
    NUM_DATA_PAIRS : natural := 8; --Num of A+B pairs

    NUM_DQ_PINS        : integer := 16;
    MASK_SIZE          : integer := 16;
    MEM_ADDR_WIDTH     : integer := 14;
    MEM_BANKADDR_WIDTH : integer := 3;
    DATA_PORT_SIZE     : integer := 128
  );
  port
  (
            --========================================
            --ADC
            --Serial interface
            adc_sdata  : out std_logic;
            adc_sclk   : out std_logic;
            adc_sreset : out std_logic;
            adc_cs_n   : out std_logic;

            --Data interface
            adc_bclk_p : in std_logic; --Up to 1GHz
            adc_bclk_n : in std_logic;
            adc_fclk_p : in std_logic; --Up to 125MHz
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
            clock_ddr_p : in std_logic; --667MHz(?)
            clock_ddr_n : in std_logic;
            clock_fsm_p : in std_logic; --200MHz
            clock_fsm_n : in std_logic;
            clock_fx3   : in std_logic; --100MHz (from fx3)
            --========================================

            --========================================
            --DDR3 Modules
            mcb1_dram_dq        : inout  std_logic_vector(NUM_DQ_PINS-1 downto 0);
            mcb1_dram_a         : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
            mcb1_dram_ba        : out std_logic_vector(MEM_BANKADDR_WIDTH-1 downto 0);
            mcb1_dram_ras_n     : out std_logic;
            mcb1_dram_cas_n     : out std_logic;
            mcb1_dram_we_n      : out std_logic;
            mcb1_dram_odt       : out std_logic;
            mcb1_dram_reset_n   : out std_logic;
            mcb1_dram_cke       : out std_logic;
            mcb1_dram_dm        : out std_logic;
            mcb1_dram_udqs_p    : inout  std_logic;
            mcb1_dram_udqs_n    : inout  std_logic;
            mcb1_rzq            : inout  std_logic;
            mcb1_zio            : inout  std_logic;
            mcb1_dram_udm       : out std_logic;
            mcb1_dram_dqs_p     : inout  std_logic;
            mcb1_dram_dqs_n     : inout  std_logic;
            mcb1_dram_ck_p      : out std_logic;
            mcb1_dram_ck_n      : out std_logic;
            --========================================

            --========================================
            --DACs
            dac0_clock : out std_logic;
            dac0_data  : out std_logic_vector(11 downto 0);
            dac0_sleep : out std_logic;

            dac1_clock : out std_logic;
            dac1_data  : out std_logic_vector(11 downto 0);
            dac1_sleep : out std_logic;
            --========================================

            --========================================
            --FX3 Slave FIFO
            fx3_slcs_n  : out std_logic;
            fx3_slwr_n  : out std_logic;
            fx3_sloe_n  : out std_logic;
            fx3_slrd_n  : out std_logic;
            fx3_flaga   : in std_logic;
            fx3_flagb   : in std_logic;
            fx3_pktend_n: out std_logic;
            fx3_fifoadr : out std_logic_vector(1 downto 0);
            fx3_dq      : inout std_logic_vector(31 downto 0);
            --========================================

            --========================================
            --Monitoring I2C
            monit_sda : inout std_logic;
            monit_scl : inout std_logic;
            --========================================

            --========================================
            --Input section I2C
            input_sda : inout std_logic;
            input_scl : inout std_logic;
            --========================================

            --========================================
            --LA section
            la : in std_logic_vector(21 downto 0)
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
          pktoutadc     : in std_logic_vector(15 downto 0);
          pktoutadcclk  : in std_logic;
          pktinadc      : out std_logic_vector(63 downto 0);
          pktinadcclk   : in std_logic;
          pktinadcempty : out std_logic;

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

  component migint
    generic (
              C1_P0_MASK_SIZE      : integer := 16;
              C1_P0_DATA_PORT_SIZE : integer := 128;
              C1_P1_MASK_SIZE      : integer := 16;
              C1_P1_DATA_PORT_SIZE : integer := 128;
              C1_MEMCLK_PERIOD     : integer := 3000;
              -- Memory data transfer clock period.
              C1_RST_ACT_LOW : integer := 0;
              -- # = 1 for active low reset,
              -- # = 0 for active high reset.
              C1_CALIB_SOFT_IP : string := "TRUE";
              -- # = TRUE, Enables the soft calibration logic,
              -- # = FALSE, Disables the soft calibration logic.
              C1_SIMULATION : string := "FALSE";
              -- # = TRUE, Simulating the design. Useful to reduce the simulation time,
              -- # = FALSE, Implementing the design.
              DEBUG_EN : integer := 1;
              -- # = 1, Enable debug signals/controls,
              --   = 0, Disable debug signals/controls.
              C1_MEM_ADDR_ORDER : string := "ROW_BANK_COLUMN";
              -- The order in which user address is provided to the memory controller,
              -- ROW_BANK_COLUMN or BANK_ROW_COLUMN.
              C1_NUM_DQ_PINS : integer := 16;
              -- External memory data width.
              C1_MEM_ADDR_WIDTH : integer := 14;
              -- External memory address width.
              C1_MEM_BANKADDR_WIDTH : integer := 3;
                    -- External memory bank address width.
              C3_P0_MASK_SIZE      : integer := 16;
              C3_P0_DATA_PORT_SIZE : integer := 128;
              C3_P1_MASK_SIZE      : integer := 16;
              C3_P1_DATA_PORT_SIZE : integer := 128;
              C3_MEMCLK_PERIOD     : integer := 3000;
              -- Memory data transfer clock period.
              C3_RST_ACT_LOW : integer := 0;
              -- # = 1 for active low reset,
              -- # = 0 for active high reset.
              C3_CALIB_SOFT_IP : string := "TRUE";
              -- # = TRUE, Enables the soft calibration logic,
              -- # = FALSE, Disables the soft calibration logic.
              C3_SIMULATION : string := "FALSE";
              -- # = TRUE, Simulating the design. Useful to reduce the simulation time,
              -- # = FALSE, Implementing the design.
              C3_MEM_ADDR_ORDER : string := "ROW_BANK_COLUMN";
              -- The order in which user address is provided to the memory controller,
              -- ROW_BANK_COLUMN or BANK_ROW_COLUMN.
              C3_NUM_DQ_PINS : integer := 16;
              -- External memory data width.
              C3_MEM_ADDR_WIDTH : integer := 14;
              -- External memory address width.
              C3_MEM_BANKADDR_WIDTH : integer := 3
            -- External memory bank address width.
            );
  port (
        mcb1_dram_dq        : inout  std_logic_vector(C1_NUM_DQ_PINS-1 downto 0);
        mcb1_dram_a         : out std_logic_vector(C1_MEM_ADDR_WIDTH-1 downto 0);
        mcb1_dram_ba        : out std_logic_vector(C1_MEM_BANKADDR_WIDTH-1 downto 0);
        mcb1_dram_ras_n     : out std_logic;
        mcb1_dram_cas_n     : out std_logic;
        mcb1_dram_we_n      : out std_logic;
        mcb1_dram_odt       : out std_logic;
        mcb1_dram_reset_n   : out std_logic;
        mcb1_dram_cke       : out std_logic;
        mcb1_dram_dm        : out std_logic;
        mcb1_dram_udqs      : inout  std_logic;
        mcb1_dram_udqs_n    : inout  std_logic;
        mcb1_rzq            : inout  std_logic;
        mcb1_zio            : inout  std_logic;
        mcb1_dram_udm       : out std_logic;
        c1_sys_clk_ibufg    : in  std_logic;
        c1_sys_rst_i        : in  std_logic;
        c1_calib_done       : out std_logic;
        c1_clk0             : out std_logic;
        c1_rst0             : out std_logic;
        mcb1_dram_dqs       : inout  std_logic;
        mcb1_dram_dqs_n     : inout  std_logic;
        mcb1_dram_ck        : out std_logic;
        mcb1_dram_ck_n      : out std_logic;
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
        c3_sys_clk_ibufg    : in  std_logic;
        c3_sys_rst_i        : in  std_logic;
        c3_calib_done       : out std_logic;
        c3_clk0             : out std_logic;
        c3_rst0             : out std_logic;
        mcb3_dram_dqs       : inout  std_logic;
        mcb3_dram_dqs_n     : inout  std_logic;
        mcb3_dram_ck        : out std_logic;
        mcb3_dram_ck_n      : out std_logic;
        c1_p0_cmd_clk       : in std_logic;
        c1_p0_cmd_en        : in std_logic;
        c1_p0_cmd_instr     : in std_logic_vector(2 downto 0);
        c1_p0_cmd_bl        : in std_logic_vector(5 downto 0);
        c1_p0_cmd_byte_addr : in std_logic_vector(29 downto 0);
        c1_p0_cmd_empty     : out std_logic;
        c1_p0_cmd_full      : out std_logic;
        c1_p0_wr_clk        : in std_logic;
        c1_p0_wr_en         : in std_logic;
        c1_p0_wr_mask       : in std_logic_vector(C1_P0_MASK_SIZE - 1 downto 0);
        c1_p0_wr_data       : in std_logic_vector(C1_P0_DATA_PORT_SIZE - 1 downto 0);
        c1_p0_wr_full       : out std_logic;
        c1_p0_wr_empty      : out std_logic;
        c1_p0_wr_count      : out std_logic_vector(6 downto 0);
        c1_p0_wr_underrun   : out std_logic;
        c1_p0_wr_error      : out std_logic;
        c1_p0_rd_clk        : in std_logic;
        c1_p0_rd_en         : in std_logic;
        c1_p0_rd_data       : out std_logic_vector(C1_P0_DATA_PORT_SIZE - 1 downto 0);
        c1_p0_rd_full       : out std_logic;
        c1_p0_rd_empty      : out std_logic;
        c1_p0_rd_count      : out std_logic_vector(6 downto 0);
        c1_p0_rd_overflow   : out std_logic;
        c1_p0_rd_error      : out std_logic;
        c3_p0_cmd_clk       : in std_logic;
        c3_p0_cmd_en        : in std_logic;
        c3_p0_cmd_instr     : in std_logic_vector(2 downto 0);
        c3_p0_cmd_bl        : in std_logic_vector(5 downto 0);
        c3_p0_cmd_byte_addr : in std_logic_vector(29 downto 0);
        c3_p0_cmd_empty     : out std_logic;
        c3_p0_cmd_full      : out std_logic;
        c3_p0_wr_clk        : in std_logic;
        c3_p0_wr_en         : in std_logic;
        c3_p0_wr_mask       : in std_logic_vector(C3_P0_MASK_SIZE - 1 downto 0);
        c3_p0_wr_data       : in std_logic_vector(C3_P0_DATA_PORT_SIZE - 1 downto 0);
        c3_p0_wr_full       : out std_logic;
        c3_p0_wr_empty      : out std_logic;
        c3_p0_wr_count      : out std_logic_vector(6 downto 0);
        c3_p0_wr_underrun   : out std_logic;
        c3_p0_wr_error      : out std_logic;
        c3_p0_rd_clk        : in std_logic;
        c3_p0_rd_en         : in std_logic;
        c3_p0_rd_data       : out std_logic_vector(C3_P0_DATA_PORT_SIZE - 1 downto 0);
        c3_p0_rd_full       : out std_logic;
        c3_p0_rd_empty      : out std_logic;
        c3_p0_rd_count      : out std_logic_vector(6 downto 0);
        c3_p0_rd_overflow   : out std_logic;
        c3_p0_rd_error      : out std_logic
      );
  end component migint;


  signal sys_rst : std_logic;
  signal fsmclk  : std_logic;
  signal ddrclk  : std_logic;
  signal fx3clk  : std_logic;

  signal pktoutadc, pktinadc       : std_logic_vector(15 downto 0);
  signal pktoutadcclk, pktinadcclk : std_logic;

  signal adcdata    : std_logic_vector(63 downto 0);
  signal adcdataclk : std_logic;

  signal c1_calib_done, c3_calib_done         : std_logic;
  signal c1_clk0, c1_rst0, c3_clk0, c3_rst0   : std_logic;
  signal c1_p0_cmd_clk, c3_p0_cmd_clk         : std_logic;
  signal c1_p0_cmd_en, c3_p0_cmd_en           : std_logic;
  signal c1_p0_cmd_instr, c3_p0_cmd_instr     : std_logic_vector(2 downto 0);
  signal c1_p0_cmd_bl, c3_p0_cmd_bl           : std_logic_vector(5 downto 0);
  signal c1_p0_cmd_byte_addr                  : std_logic_vector(29 downto 0);
  signal c3_p0_cmd_byte_addr                  : std_logic_vector(29 downto 0);
  signal c1_p0_cmd_empty, c3_p0_cmd_empty     : std_logic;
  signal c1_p0_cmd_full, c3_p0_cmd_full       : std_logic;
  signal c1_p0_wr_clk, c3_p0_wr_clk           : std_logic;
  signal c1_p0_wr_en, c3_p0_wr_en             : std_logic;
  signal c1_p0_wr_full, c3_p0_wr_full         : std_logic;
  signal c1_p0_wr_empty, c3_p0_wr_empty       : std_logic;
  signal c1_p0_wr_count, c3_p0_wr_count       : std_logic_vector(6 downto 0);
  signal c1_p0_wr_underrun, c3_p0_wr_underrun : std_logic;
  signal c1_p0_wr_error, c3_p0_wr_error       : std_logic;
  signal c1_p0_rd_clk, c3_p0_rd_clk           : std_logic;
  signal c1_p0_rd_en, c3_p0_rd_en             : std_logic;
  signal c1_p0_rd_full, c3_p0_rd_full         : std_logic;
  signal c1_p0_rd_empty, c3_p0_rd_empty       : std_logic;
  signal c1_p0_rd_count, c3_p0_rd_count       : std_logic_vector(6 downto 0);
  signal c1_p0_rd_overflow, c3_p0_rd_overflow : std_logic;
  signal c1_p0_rd_error, c3_p0_rd_error       : std_logic;

  signal c1_p0_wr_data, c3_p0_wr_data : std_logic_vector(DATA_PORT_SIZE-1 downto 0);
  signal c1_p0_rd_data, c3_p0_rd_data : std_logic_vector(DATA_PORT_SIZE-1 downto 0);
  signal c1_p0_wr_mask, c3_p0_wr_mask : std_logic_vector(MASK_SIZE-1 downto 0);

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
                S              => S,
                NUM_DATA_PAIRS => NUM_DATA_PAIRS
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
