--------------------------------------------------------------------------------
-- Engineer:       Ali Lown
--
-- Create Date:    08:49:11 06/24/2011
-- Module Name:    main - Behavioral
-- Project Name:   USB Digital Oscilloscope
-- Target Devices: xc3s50a(n)
-- Description:    Links the whole design together, but doesn't do a lot!
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library unisim;
use unisim.vcomponents.ALL;

entity main is
  generic
  (
    NUM_IB : integer := 4 --Max of 4 due to the FSM in think
  );
  Port (
         --ADC Lines
         adc_sdata : out std_logic;
         adc_sclk : out std_logic;
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

         --External PLL
         pll_data : out std_logic;
         pll_clk : out std_logic;
         pll_le : out std_logic;

         --LA lines
         la_data : in std_logic_vector(11 downto 0);

         --DAC for the AWG
         dac_data : out std_logic_vector(11 downto 0);
         dac_clk : out std_logic;

         --FX2 lines
         CYFD : inout  std_logic_vector (15 downto 0);
         CYIFCLK : in  STD_LOGIC; --48MHz
         CYFIFOADR : out  std_logic_vector (1 downto 0);
         CYSLOE : out  STD_LOGIC;
         CYSLWR : out  STD_LOGIC;
         CYSLRD : out  STD_LOGIC;
         CYFLAGA : in  STD_LOGIC;
         CYFLAGB : in  STD_LOGIC;
         CYFLAGC : in  STD_LOGIC;
         CYPKTEND : out STD_LOGIC;

         MCLK : in STD_LOGIC; --200MHz

         --Input Board lines
         RX : in std_logic_vector(NUM_IB-1 downto 0);
         TX : out std_logic_vector(NUM_IB-1 downto 0);

         --Memory 1
         mcb1_dram_dq : INOUT std_logic_vector(15 downto 0);
         mcb1_dram_udqs : INOUT std_logic;
         mcb1_dram_udqs_n : INOUT std_logic;
         mcb1_rzq : INOUT std_logic;
         mcb1_zio : INOUT std_logic;
         mcb1_dram_dqs : INOUT std_logic;
         mcb1_dram_dqs_n : INOUT std_logic;
         mcb1_dram_a : OUT std_logic_vector(12 downto 0);
         mcb1_dram_ba : OUT std_logic_vector(2 downto 0);
         mcb1_dram_ras_n : OUT std_logic;
         mcb1_dram_cas_n : OUT std_logic;
         mcb1_dram_we_n : OUT std_logic;
         mcb1_dram_odt : OUT std_logic;
         mcb1_dram_reset_n : OUT std_logic;
         mcb1_dram_cke : OUT std_logic;
         mcb1_dram_dm : OUT std_logic;
         mcb1_dram_udm : OUT std_logic;
         mcb1_dram_ck : OUT std_logic;
         mcb1_dram_ck_n : OUT std_logic;

         --Memory 2
         mcb3_dram_dq : INOUT std_logic_vector(15 downto 0);
         mcb3_dram_udqs : INOUT std_logic;
         mcb3_dram_udqs_n : INOUT std_logic;
         mcb3_rzq : INOUT std_logic;
         mcb3_zio : INOUT std_logic;
         mcb3_dram_dqs : INOUT std_logic;
         mcb3_dram_dqs_n : INOUT std_logic;
         mcb3_dram_a : OUT std_logic_vector(12 downto 0);
         mcb3_dram_ba : OUT std_logic_vector(2 downto 0);
         mcb3_dram_ras_n : OUT std_logic;
         mcb3_dram_cas_n : OUT std_logic;
         mcb3_dram_we_n : OUT std_logic;
         mcb3_dram_odt : OUT std_logic;
         mcb3_dram_reset_n : OUT std_logic;
         mcb3_dram_cke : OUT std_logic;
         mcb3_dram_dm : OUT std_logic;
         mcb3_dram_udm : OUT std_logic;
         mcb3_dram_ck : OUT std_logic;
         mcb3_dram_ck_n : OUT std_logic
       );
end main;

architecture Behavioral of main is

  --Clocking
  COMPONENT clkmgr
    PORT(
          XTALIN : in std_logic; --200MHz

          MEMCLK : out std_logic; --800MHz
          MEMCLK180 : out std_logic; --800MHz @180
          XTALOUT : out std_logic; --200MHz
          XTALDIV2 : out std_logic; --100MHz
          XTALDIV4 : out std_logic; --50MHz
          DDRCLK : out std_logic; --400MHz

          LOCKED : out std_logic
        );
  END COMPONENT;


  COMPONENT BR_GENERATOR
    PORT(
          CLOCK : IN std_logic;
          BAUD : OUT std_logic
        );
  END COMPONENT;

  --Modules
  component adc
    Port (
           reset : in std_logic;

           --ADC interface
           sdata : out std_logic;
           sclk : out std_logic;

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

           --PLL interface
           pll_data : out std_logic;
           pll_clk : out std_logic;
           pll_le : out std_logic;

           --Internal (think) interface
           pktoutadc : in std_logic_vector(15 downto 0);
           pktoutadcclk : in std_logic;
           pktinadc : out std_logic_vector(15 downto 0);
           pktinadcclk : out std_logic
         );
  end component;

  COMPONENT think
    generic ( NUM_IB : integer );
    PORT(
          --General
          RESET : IN std_logic;
          CLK : IN std_logic;

          --to/from fx2ctrl
          PKTBUS : IN std_logic_vector(15 downto 0);
          PKTBUSCLK : IN std_logic;

          PKTIN : OUT std_logic_vector(15 downto 0);
          PKTINCLK : OUT std_logic;

          --to ADC Config
          PKTOUTADC : OUT std_logic_vector(15 downto 0);
          PKTOUTADCCLK : OUT std_logic;

          --to/from IB's
          PKTOUTIB : OUT std_logic_vector(NUM_IB*16-1 downto 0);
          PKTOUTIBCLK : OUT std_logic_vector(NUM_IB-1 downto 0);

          PKTINIB : IN std_logic_vector(NUM_IB*16-1 downto 0);
          PKTINIBCLK : IN std_logic_vector(NUM_IB-1 downto 0)
        );
  END COMPONENT;

  component extbuffer
    generic
    (
      C1_P0_MASK_SIZE           : integer := 8;
      C1_P0_DATA_PORT_SIZE      : integer := 64;
      C1_P1_MASK_SIZE           : integer := 8;
      C1_P1_DATA_PORT_SIZE      : integer := 64;
      C1_MEMCLK_PERIOD        : integer := 2500;
    -- Memory data transfer clock period.
      C1_RST_ACT_LOW          : integer := 0;
    -- # = 1 for active low reset,
    -- # = 0 for active high reset.
      C1_INPUT_CLK_TYPE       : string := "DIFFERENTIAL";
    -- input clock type DIFFERENTIAL or SINGLE_ENDED.
      C1_CALIB_SOFT_IP        : string := "TRUE";
    -- # = TRUE, Enables the soft calibration logic,
    -- # = FALSE, Disables the soft calibration logic.
      C1_SIMULATION           : string := "FALSE";
    -- # = TRUE, Simulating the design. Useful to reduce the simulation time,
    -- # = FALSE, Implementing the design.
      DEBUG_EN                : integer := 1;
    -- # = 1, Enable debug signals/controls,
    --   = 0, Disable debug signals/controls.
      C1_MEM_ADDR_ORDER       : string := "ROW_BANK_COLUMN";
    -- The order in which user address is provided to the memory controller,
    -- ROW_BANK_COLUMN or BANK_ROW_COLUMN.
      C1_NUM_DQ_PINS          : integer := 16;
    -- External memory data width.
      C1_MEM_ADDR_WIDTH       : integer := 13;
    -- External memory address width.
      C1_MEM_BANKADDR_WIDTH   : integer := 3;
          -- External memory bank address width.
      C3_P0_MASK_SIZE           : integer := 8;
      C3_P0_DATA_PORT_SIZE      : integer := 64;
      C3_P1_MASK_SIZE           : integer := 8;
      C3_P1_DATA_PORT_SIZE      : integer := 64;
      C3_MEMCLK_PERIOD        : integer := 2500;
    -- Memory data transfer clock period.
      C3_RST_ACT_LOW          : integer := 0;
    -- # = 1 for active low reset,
    -- # = 0 for active high reset.
      C3_INPUT_CLK_TYPE       : string := "DIFFERENTIAL";
    -- input clock type DIFFERENTIAL or SINGLE_ENDED.
      C3_CALIB_SOFT_IP        : string := "TRUE";
    -- # = TRUE, Enables the soft calibration logic,
    -- # = FALSE, Disables the soft calibration logic.
      C3_SIMULATION           : string := "FALSE";
    -- # = TRUE, Simulating the design. Useful to reduce the simulation time,
    -- # = FALSE, Implementing the design.
      C3_MEM_ADDR_ORDER       : string := "ROW_BANK_COLUMN";
    -- The order in which user address is provided to the memory controller,
    -- ROW_BANK_COLUMN or BANK_ROW_COLUMN.
      C3_NUM_DQ_PINS          : integer := 16;
    -- External memory data width.
      C3_MEM_ADDR_WIDTH       : integer := 13;
    -- External memory address width.
      C3_MEM_BANKADDR_WIDTH   : integer := 3
  -- External memory bank address width.
    );
    port
    (
      mcb1_dram_dq                            : inout  std_logic_vector(C1_NUM_DQ_PINS-1 downto 0);
      mcb1_dram_a                             : out std_logic_vector(C1_MEM_ADDR_WIDTH-1 downto 0);
      mcb1_dram_ba                            : out std_logic_vector(C1_MEM_BANKADDR_WIDTH-1 downto 0);
      mcb1_dram_ras_n                         : out std_logic;
      mcb1_dram_cas_n                         : out std_logic;
      mcb1_dram_we_n                          : out std_logic;
      mcb1_dram_odt                           : out std_logic;
      mcb1_dram_reset_n                       : out std_logic;
      mcb1_dram_cke                           : out std_logic;
      mcb1_dram_dm                            : out std_logic;
      mcb1_dram_udqs                          : inout  std_logic;
      mcb1_dram_udqs_n                        : inout  std_logic;
      mcb1_rzq                                : inout  std_logic;
      mcb1_zio                                : inout  std_logic;
      mcb1_dram_udm                           : out std_logic;
      mcb1_dram_dqs                           : inout  std_logic;
      mcb1_dram_dqs_n                         : inout  std_logic;
      mcb1_dram_ck                            : out std_logic;
      mcb1_dram_ck_n                          : out std_logic;

      mcb3_dram_dq                            : inout  std_logic_vector(C3_NUM_DQ_PINS-1 downto 0);
      mcb3_dram_a                             : out std_logic_vector(C3_MEM_ADDR_WIDTH-1 downto 0);
      mcb3_dram_ba                            : out std_logic_vector(C3_MEM_BANKADDR_WIDTH-1 downto 0);
      mcb3_dram_ras_n                         : out std_logic;
      mcb3_dram_cas_n                         : out std_logic;
      mcb3_dram_we_n                          : out std_logic;
      mcb3_dram_odt                           : out std_logic;
      mcb3_dram_reset_n                       : out std_logic;
      mcb3_dram_cke                           : out std_logic;
      mcb3_dram_dm                            : out std_logic;
      mcb3_dram_udqs                          : inout  std_logic;
      mcb3_dram_udqs_n                        : inout  std_logic;
      mcb3_rzq                                : inout  std_logic;
      mcb3_zio                                : inout  std_logic;
      mcb3_dram_udm                           : out std_logic;
      mcb3_dram_dqs                           : inout  std_logic;
      mcb3_dram_dqs_n                         : inout  std_logic;
      mcb3_dram_ck                            : out std_logic;
      mcb3_dram_ck_n                          : out std_logic;

      c1_sys_clk_p                            : in  std_logic;
      c1_sys_clk_n                            : in  std_logic;
      c1_sys_rst_i                            : in  std_logic;
      c1_calib_done                           : out std_logic;
      c1_clk0                                 : out std_logic;
      c1_rst0                                 : out std_logic;

      c3_sys_clk_p                            : in  std_logic;
      c3_sys_clk_n                            : in  std_logic;
      c3_sys_rst_i                            : in  std_logic;
      c3_calib_done                           : out std_logic;
      c3_clk0                                 : out std_logic;
      c3_rst0                                 : out std_logic;

      c1_p0_cmd_clk                           : in std_logic;
      c1_p0_cmd_en                            : in std_logic;
      c1_p0_cmd_instr                         : in std_logic_vector(2 downto 0);
      c1_p0_cmd_bl                            : in std_logic_vector(5 downto 0);
      c1_p0_cmd_byte_addr                     : in std_logic_vector(29 downto 0);
      c1_p0_cmd_empty                         : out std_logic;
      c1_p0_cmd_full                          : out std_logic;
      c1_p0_wr_clk                            : in std_logic;
      c1_p0_wr_en                             : in std_logic;
      c1_p0_wr_mask                           : in std_logic_vector(C1_P0_MASK_SIZE - 1 downto 0);
      c1_p0_wr_data                           : in std_logic_vector(C1_P0_DATA_PORT_SIZE - 1 downto 0);
      c1_p0_wr_full                           : out std_logic;
      c1_p0_wr_empty                          : out std_logic;
      c1_p0_wr_count                          : out std_logic_vector(6 downto 0);
      c1_p0_wr_underrun                       : out std_logic;
      c1_p0_wr_error                          : out std_logic;
      c1_p0_rd_clk                            : in std_logic;
      c1_p0_rd_en                             : in std_logic;
      c1_p0_rd_data                           : out std_logic_vector(C1_P0_DATA_PORT_SIZE - 1 downto 0);
      c1_p0_rd_full                           : out std_logic;
      c1_p0_rd_empty                          : out std_logic;
      c1_p0_rd_count                          : out std_logic_vector(6 downto 0);
      c1_p0_rd_overflow                       : out std_logic;
      c1_p0_rd_error                          : out std_logic;

      c3_p0_cmd_clk                           : in std_logic;
      c3_p0_cmd_en                            : in std_logic;
      c3_p0_cmd_instr                         : in std_logic_vector(2 downto 0);
      c3_p0_cmd_bl                            : in std_logic_vector(5 downto 0);
      c3_p0_cmd_byte_addr                     : in std_logic_vector(29 downto 0);
      c3_p0_cmd_empty                         : out std_logic;
      c3_p0_cmd_full                          : out std_logic;
      c3_p0_wr_clk                            : in std_logic;
      c3_p0_wr_en                             : in std_logic;
      c3_p0_wr_mask                           : in std_logic_vector(C3_P0_MASK_SIZE - 1 downto 0);
      c3_p0_wr_data                           : in std_logic_vector(C3_P0_DATA_PORT_SIZE - 1 downto 0);
      c3_p0_wr_full                           : out std_logic;
      c3_p0_wr_empty                          : out std_logic;
      c3_p0_wr_count                          : out std_logic_vector(6 downto 0);
      c3_p0_wr_underrun                       : out std_logic;
      c3_p0_wr_error                          : out std_logic;
      c3_p0_rd_clk                            : in std_logic;
      c3_p0_rd_en                             : in std_logic;
      c3_p0_rd_data                           : out std_logic_vector(C3_P0_DATA_PORT_SIZE - 1 downto 0);
      c3_p0_rd_full                           : out std_logic;
      c3_p0_rd_empty                          : out std_logic;
      c3_p0_rd_count                          : out std_logic_vector(6 downto 0);
      c3_p0_rd_overflow                       : out std_logic;
      c3_p0_rd_error                          : out std_logic
    );
  end component;

  COMPONENT ibctrl
    PORT(
          --General
          RESET : IN std_logic;
          CLK : IN std_logic;
          BAUDCLK : IN std_logic;

          --to/from IB uC
          RX : IN std_logic;
          TX : OUT std_logic;

          --to/from think
          PKTIN : OUT std_logic_vector(15 downto 0);
          PKTINCLK : OUT std_logic;

          PKTOUT : IN std_logic_vector(15 downto 0);
          PKTOUTCLK : IN std_logic
        );
  END COMPONENT;

  --Debug paths
  component chipscope_icon
    PORT (
           CONTROL0 : INOUT std_logic_vector(35 DOWNTO 0);
           CONTROL1 : INOUT std_logic_vector(35 DOWNTO 0)
         );
  end component;

  component chipscope_ila_uart
    PORT (
           CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
           CLK : IN STD_LOGIC;
           TRIG0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
         );
  end component;

  --Signals
  signal pllvalid : std_logic;
  signal mclk_bufg, fsmclk : std_logic;
  signal reset : std_logic;
  signal cyifclk_bufg : std_logic;

  signal adcbus : std_logic_vector(63 downto 0);
  signal adcbusclk : std_logic;

  signal cybus : std_logic_vector(15 downto 0);
  signal pktin : std_logic_vector(15 downto 0);
  signal cybusclk, pktinclk : std_logic;

  signal cs_control0, cs_control1 : std_logic_vector(35 downto 0);
  signal cs_trig_uart : std_logic_vector(3 downto 0);
  signal cyfa_out : std_logic_vector(1 downto 0);
  signal cysloe_out, cyslrd_out, cyslwr_out : std_logic;
  signal cypktend_out : std_logic;

  signal pktinib, pktoutib : std_logic_vector(NUM_IB*16-1 downto 0);
  signal pktinibclk, pktoutibclk : std_logic_vector(NUM_IB-1 downto 0);
  signal pktinadc, pktoutadc : std_logic_vector(15 downto 0);
  signal pktinadcclk, pktoutadcclk : std_logic;

  signal uartclk, baudclk : std_logic;
  signal txa_out, txb_out : std_logic;
  signal i : integer;
  signal cfgiba,cfgibb : std_logic_vector(15 downto 0);
  signal savea,saveb : std_logic;

  signal memclk, memclk180 : std_logic;
  signal c1_calib_done, c3_calib_done : std_logic;
  signal c1_clk0, c3_clk0, c1_rst0, c3_rst0 : std_logic;
  signal c1_p0_cmd_clk, c3_p0_cmd_clk : std_logic;
  signal c1_p0_cmd_en, c3_p0_cmd_en : std_logic;
  signal c1_p0_cmd_instr, c3_p0_cmd_instr : std_logic_vector(2 downto 0);
  signal c1_p0_cmd_bl, c3_p0_cmd_bl : std_logic_vector(5 downto 0);
  signal c1_p0_cmd_byte_addr, c3_p0_cmd_byte_addr : std_logic_vector(29 downto 0);
  signal c1_p0_cmd_empty, c3_p0_cmd_empty : std_logic;
  signal c1_p0_cmd_full, c3_p0_cmd_full : std_logic;
  signal c1_p0_wr_clk, c3_p0_wr_clk : std_logic;
  signal c1_p0_wr_en, c3_p0_wr_en : std_logic;
  signal c1_p0_wr_mask, c3_p0_wr_mask : std_logic_vector(7 downto 0);
  signal c1_p0_wr_data, c3_p0_wr_data : std_logic_vector(63 downto 0);
  signal c1_p0_wr_full, c3_p0_wr_full : std_logic;
  signal c1_p0_wr_empty, c3_p0_wr_empty : std_logic;
  signal c1_p0_wr_count, c3_p0_wr_count : std_logic_vector(6 downto 0);
  signal c1_p0_wr_underrun, c3_p0_wr_underrun : std_logic;
  signal c1_p0_wr_error, c3_p0_wr_error : std_logic;
  signal c1_p0_rd_clk, c3_p0_rd_clk : std_logic;
  signal c1_p0_rd_en, c3_p0_rd_en : std_logic;
  signal c1_p0_rd_data, c3_p0_rd_data : std_logic_vector(63 downto 0);
  signal c1_p0_rd_full, c3_p0_rd_full : std_logic;
  signal c1_p0_rd_empty, c3_p0_rd_empty : std_logic;
  signal c1_p0_rd_count, c3_p0_rd_count : std_logic_vector(6 downto 0);
  signal c1_p0_rd_overflow, c3_p0_rd_overflow : std_logic;
  signal c1_p0_rd_error, c3_p0_rd_error : std_logic;

begin
  --Clocking
  Inst_clkmgr : clkmgr
  PORT MAP(
            XTALIN => MCLK,

            MEMCLK => memclk,
            MEMCLK180 => memclk180,
            XTALOUT => mclk_bufg,
            XTALDIV2 => fsmclk,
            --XTALDIV4 =>
            --DDRCLK =>

            LOCKED => pllvalid
          );

  Inst_ifclk_bufg : BUFG
  port map(
            I => CYIFCLK,
            O => cyifclk_bufg
          );

  Inst_BR_GENERATOR: BR_GENERATOR
  PORT MAP(
            CLOCK => memclk,
            BAUD => baudclk
          );

  --Modules
  Inst_adc: adc
  port map(
            reset => reset,

            sdata => adc_sdata,
            sclk => adc_sclk,

            bclk_p => adc_bclk_p,
            bclk_n => adc_bclk_n,
            fclk_p => adc_fclk_p,
            fclk_n => adc_fclk_n,

            d1a_p => adc_d1a_p,
            d1a_n => adc_d1a_n,
            d1b_p => adc_d1b_p,
            d1b_n => adc_d1b_n,
            d2a_p => adc_d2a_p,
            d2a_n => adc_d2a_n,
            d2b_p => adc_d2b_p,
            d2b_n => adc_d2b_n,
            d3a_p => adc_d3a_p,
            d3a_n => adc_d3a_n,
            d3b_p => adc_d3b_p,
            d3b_n => adc_d3b_n,
            d4a_p => adc_d4a_p,
            d4a_n => adc_d4a_n,
            d4b_p => adc_d4b_p,
            d4b_n => adc_d4b_n,

            pll_data => pll_data,
            pll_clk => pll_clk,
            pll_le => pll_le,

            pktoutadc => pktoutadc,
            pktoutadcclk => pktoutadcclk,
            pktinadc => pktinadc,
            pktinadcclk => pktinadcclk
          );

  Inst_think: think
  generic map ( NUM_IB => NUM_IB )
  PORT MAP(
            RESET => reset,
            CLK => cyifclk_bufg,

            PKTBUS => cybus,
            PKTBUSCLK => cybusclk,

            PKTIN => pktin,
            PKTINCLK => pktinclk,

            PKTOUTADC => pktoutadc,
            PKTOUTADCCLK => pktoutadcclk,

            PKTOUTIB => pktoutib,
            PKTOUTIBCLK => pktoutibclk,

            PKTINIB => pktinib,
            PKTINIBCLK => pktinibclk
          );

  IB: for i in 0 to NUM_IB-1 generate
    Inst_IB : ibctrl
    port map (
               RESET => reset,
               CLK => cyifclk_bufg,
               BAUDCLK => baudclk,

               RX => RX(i),
               TX => TX(i),

               PKTIN => pktinib(i*16+15 downto i*16),
               PKTINCLK => pktinibclk(i),

               PKTOUT => pktoutib(i*16+15 downto i*16),
               PKTOUTCLK => pktoutibclk(i)
             );
  end generate IB;

  Inst_extbuffer: extbuffer PORT MAP(
                                  c1_sys_clk_p => memclk,
                                  c1_sys_clk_n => memclk180,
                                  c1_sys_rst_i => reset,
                                  c1_calib_done => c1_calib_done,
                                  c1_clk0 => c1_clk0,
                                  c1_rst0 => c1_rst0,

                                  c3_sys_clk_p => memclk,
                                  c3_sys_clk_n => memclk180,
                                  c3_sys_rst_i => reset,
                                  c3_calib_done => c3_calib_done,
                                  c3_clk0 => c3_clk0,
                                  c3_rst0 => c3_rst0,

                                  mcb1_dram_dq => mcb1_dram_dq,
                                  mcb1_dram_a => mcb1_dram_a,
                                  mcb1_dram_ba => mcb1_dram_ba,
                                  mcb1_dram_ras_n => mcb1_dram_ras_n,
                                  mcb1_dram_cas_n => mcb1_dram_cas_n,
                                  mcb1_dram_we_n => mcb1_dram_we_n,
                                  mcb1_dram_odt => mcb1_dram_odt,
                                  mcb1_dram_reset_n => mcb1_dram_reset_n,
                                  mcb1_dram_cke => mcb1_dram_cke,
                                  mcb1_dram_dm => mcb1_dram_dm,
                                  mcb1_dram_udqs => mcb1_dram_udqs,
                                  mcb1_dram_udqs_n => mcb1_dram_udqs_n,
                                  mcb1_rzq => mcb1_rzq,
                                  mcb1_zio => mcb1_zio,
                                  mcb1_dram_udm => mcb1_dram_udm,
                                  mcb1_dram_dqs => mcb1_dram_dqs,
                                  mcb1_dram_dqs_n => mcb1_dram_dqs_n,
                                  mcb1_dram_ck => mcb1_dram_ck,
                                  mcb1_dram_ck_n => mcb1_dram_ck_n,

                                  mcb3_dram_dq => mcb3_dram_dq,
                                  mcb3_dram_a => mcb3_dram_a,
                                  mcb3_dram_ba => mcb3_dram_ba,
                                  mcb3_dram_ras_n => mcb3_dram_ras_n,
                                  mcb3_dram_cas_n => mcb3_dram_cas_n,
                                  mcb3_dram_we_n => mcb3_dram_we_n,
                                  mcb3_dram_odt => mcb3_dram_odt,
                                  mcb3_dram_reset_n => mcb3_dram_reset_n,
                                  mcb3_dram_cke => mcb3_dram_cke,
                                  mcb3_dram_dm => mcb3_dram_dm,
                                  mcb3_dram_udqs => mcb3_dram_udqs,
                                  mcb3_dram_udqs_n => mcb3_dram_udqs_n,
                                  mcb3_rzq => mcb3_rzq,
                                  mcb3_zio => mcb3_zio,
                                  mcb3_dram_udm => mcb3_dram_udm,
                                  mcb3_dram_dqs => mcb3_dram_dqs,
                                  mcb3_dram_dqs_n => mcb3_dram_dqs_n,
                                  mcb3_dram_ck => mcb3_dram_ck,
                                  mcb3_dram_ck_n => mcb3_dram_ck_n,

                                  c1_p0_cmd_clk => c1_p0_cmd_clk,
                                  c1_p0_cmd_en => c1_p0_cmd_en,
                                  c1_p0_cmd_instr => c1_p0_cmd_instr,
                                  c1_p0_cmd_bl => c1_p0_cmd_bl,
                                  c1_p0_cmd_byte_addr => c1_p0_cmd_byte_addr,
                                  c1_p0_cmd_empty => c1_p0_cmd_empty,
                                  c1_p0_cmd_full => c1_p0_cmd_full,
                                  c1_p0_wr_clk => c1_p0_wr_clk,
                                  c1_p0_wr_en => c1_p0_wr_en,
                                  c1_p0_wr_mask => c1_p0_wr_mask,
                                  c1_p0_wr_data => c1_p0_wr_data,
                                  c1_p0_wr_full => c1_p0_wr_full,
                                  c1_p0_wr_empty => c1_p0_wr_empty,
                                  c1_p0_wr_count => c1_p0_wr_count,
                                  c1_p0_wr_underrun => c1_p0_wr_underrun,
                                  c1_p0_wr_error => c1_p0_wr_error,
                                  c1_p0_rd_clk => c1_p0_rd_clk,
                                  c1_p0_rd_en => c1_p0_rd_en,
                                  c1_p0_rd_data => c1_p0_rd_data,
                                  c1_p0_rd_full => c1_p0_rd_full,
                                  c1_p0_rd_empty => c1_p0_rd_empty,
                                  c1_p0_rd_count => c1_p0_rd_count,
                                  c1_p0_rd_overflow => c1_p0_rd_overflow,
                                  c1_p0_rd_error => c1_p0_rd_error,

                                  c3_p0_cmd_clk => c3_p0_cmd_clk,
                                  c3_p0_cmd_en => c3_p0_cmd_en,
                                  c3_p0_cmd_instr => c3_p0_cmd_instr,
                                  c3_p0_cmd_bl => c3_p0_cmd_bl,
                                  c3_p0_cmd_byte_addr => c3_p0_cmd_byte_addr,
                                  c3_p0_cmd_empty => c3_p0_cmd_empty,
                                  c3_p0_cmd_full => c3_p0_cmd_full,
                                  c3_p0_wr_clk => c3_p0_wr_clk,
                                  c3_p0_wr_en => c3_p0_wr_en,
                                  c3_p0_wr_mask => c3_p0_wr_mask,
                                  c3_p0_wr_data => c3_p0_wr_data,
                                  c3_p0_wr_full => c3_p0_wr_full,
                                  c3_p0_wr_empty => c3_p0_wr_empty,
                                  c3_p0_wr_count => c3_p0_wr_count,
                                  c3_p0_wr_underrun => c3_p0_wr_underrun,
                                  c3_p0_wr_error => c3_p0_wr_error,
                                  c3_p0_rd_clk => c3_p0_rd_clk,
                                  c3_p0_rd_en => c3_p0_rd_en,
                                  c3_p0_rd_data => c3_p0_rd_data,
                                  c3_p0_rd_full => c3_p0_rd_full,
                                  c3_p0_rd_empty => c3_p0_rd_empty,
                                  c3_p0_rd_count => c3_p0_rd_count,
                                  c3_p0_rd_overflow => c3_p0_rd_overflow,
                                  c3_p0_rd_error => c3_p0_rd_error
                                );

  --Debug
  Inst_chipscope_icon : chipscope_icon
  port map (
             CONTROL0 => cs_control0,
             CONTROL1 => cs_control1
           );

  Inst_chipscope_ila_uart : chipscope_ila_uart
  port map (
             CONTROL => cs_control1,
             CLK => baudclk,
             TRIG0 => cs_trig_uart
           );

  --Sort out rest of the connections
  reset <= not pllvalid;

  --Debug forced re-arrangement
  CYSLOE <= cysloe_out;
  CYSLRD <= cyslrd_out;
  CYSLWR <= cyslwr_out;
  CYPKTEND <= cypktend_out;

end Behavioral;
