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
         adc_d2a_p : in std_logic;
         adc_d2a_n : in std_logic;
         adc_d3a_p : in std_logic;
         adc_d3a_n : in std_logic;
         adc_d4a_p : in std_logic;
         adc_d4a_n : in std_logic;

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
           --ADC interface
           sdata : out std_logic;
           sclk : out std_logic;

           bclk_p : in std_logic;
           bclk_n : in std_logic;
           fclk_p : in std_logic;
           fclk_n : in std_logic;

           d1a_p : in std_logic;
           d1a_n : in std_logic;
           d2a_p : in std_logic;
           d2a_n : in std_logic;
           d3a_p : in std_logic;
           d3a_n : in std_logic;
           d4a_p : in std_logic;
           d4a_n : in std_logic;

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

  COMPONENT fx2ctrl
    PORT(
          --General
          RESET : IN std_logic;
          CLK : IN std_logic;

          --to/from FX2
          FLAGA : IN std_logic;
          FLAGB : IN std_logic;
          FLAGC : IN std_logic;
          FD : INOUT std_logic_vector(15 downto 0);
          SLOE : OUT std_logic;
          SLRD : OUT std_logic;
          SLWR : OUT std_logic;
          FIFOADR : OUT std_logic_vector(1 downto 0);
          PKTEND : OUT std_logic;

          --from ADC
          ADCDATA : IN std_logic_vector(63 downto 0);
          ADCDATACLK : IN std_logic;

          --to/from think
          PKTBUS : OUT std_logic_vector(15 downto 0);
          PKTBUSCLK : OUT std_logic;

          PKTIN : IN std_logic_vector(15 downto 0);
          PKTINCLK : IN std_logic
        );
  END COMPONENT;

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

  COMPONENT dualmcb
    PORT(
          c13_clk0 : IN std_logic;
          c13_clk_2x_0 : IN std_logic;
          c13_clk_2x_180 : IN std_logic;
          c13_mcb_drp_clk : IN std_logic;
          c13_clk_locked : IN std_logic;
          c13_sys_rst_i : IN std_logic;
          c13_calib_done : OUT std_logic;
          c13_rst0 : OUT std_logic;

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
          mcb3_dram_ck_n : OUT std_logic;

          c1_p0_cmd_clk : IN std_logic;
          c1_p0_cmd_en : IN std_logic;
          c1_p0_cmd_instr : IN std_logic_vector(2 downto 0);
          c1_p0_cmd_bl : IN std_logic_vector(5 downto 0);
          c1_p0_cmd_byte_addr : IN std_logic_vector(29 downto 0);
          c1_p0_wr_clk : IN std_logic;
          c1_p0_wr_en : IN std_logic;
          c1_p0_wr_mask : IN std_logic_vector(7 downto 0);
          c1_p0_wr_data : IN std_logic_vector(63 downto 0);
          c1_p0_rd_clk : IN std_logic;
          c1_p0_rd_en : IN std_logic;
          c1_p0_cmd_empty : OUT std_logic;
          c1_p0_cmd_full : OUT std_logic;
          c1_p0_wr_full : OUT std_logic;
          c1_p0_wr_empty : OUT std_logic;
          c1_p0_wr_count : OUT std_logic_vector(6 downto 0);
          c1_p0_wr_underrun : OUT std_logic;
          c1_p0_wr_error : OUT std_logic;
          c1_p0_rd_data : OUT std_logic_vector(63 downto 0);
          c1_p0_rd_full : OUT std_logic;
          c1_p0_rd_empty : OUT std_logic;
          c1_p0_rd_count : OUT std_logic_vector(6 downto 0);
          c1_p0_rd_overflow : OUT std_logic;
          c1_p0_rd_error : OUT std_logic;

          c3_p0_cmd_clk : IN std_logic;
          c3_p0_cmd_en : IN std_logic;
          c3_p0_cmd_instr : IN std_logic_vector(2 downto 0);
          c3_p0_cmd_bl : IN std_logic_vector(5 downto 0);
          c3_p0_cmd_byte_addr : IN std_logic_vector(29 downto 0);
          c3_p0_wr_clk : IN std_logic;
          c3_p0_wr_en : IN std_logic;
          c3_p0_wr_mask : IN std_logic_vector(7 downto 0);
          c3_p0_wr_data : IN std_logic_vector(63 downto 0);
          c3_p0_rd_clk : IN std_logic;
          c3_p0_rd_en : IN std_logic;
          c3_p0_cmd_empty : OUT std_logic;
          c3_p0_cmd_full : OUT std_logic;
          c3_p0_wr_full : OUT std_logic;
          c3_p0_wr_empty : OUT std_logic;
          c3_p0_wr_count : OUT std_logic_vector(6 downto 0);
          c3_p0_wr_underrun : OUT std_logic;
          c3_p0_wr_error : OUT std_logic;
          c3_p0_rd_data : OUT std_logic_vector(63 downto 0);
          c3_p0_rd_full : OUT std_logic;
          c3_p0_rd_empty : OUT std_logic;
          c3_p0_rd_count : OUT std_logic_vector(6 downto 0);
          c3_p0_rd_overflow : OUT std_logic;
          c3_p0_rd_error : OUT std_logic
        );
  END COMPONENT;


  --Debug paths
  component chipscope_icon
    PORT (
           CONTROL0 : INOUT std_logic_vector(35 DOWNTO 0);
           CONTROL1 : INOUT std_logic_vector(35 DOWNTO 0)
         );
  end component;

  component chipscope_ila_fx2
    PORT (
           CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
           CLK : IN STD_LOGIC;
           TRIG0 : IN STD_LOGIC_VECTOR(24 DOWNTO 0)
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
  signal cs_trig_fx2 : std_logic_vector(24 downto 0);
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
  signal c13_calib_done : std_logic;
  signal c13_clk0, c13_rst0 : std_logic;
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
            sdata => adc_sdata,
            sclk => adc_sclk,

            bclk_p => adc_bclk_p,
            bclk_n => adc_bclk_n,
            fclk_p => adc_fclk_p,
            fclk_n => adc_fclk_n,

            d1a_p => adc_d1a_p,
            d1a_n => adc_d1a_n,
            d2a_p => adc_d2a_p,
            d2a_n => adc_d2a_n,
            d3a_p => adc_d3a_p,
            d3a_n => adc_d3a_n,
            d4a_p => adc_d4a_p,
            d4a_n => adc_d4a_n,

            pll_data => pll_data,
            pll_clk => pll_clk,
            pll_le => pll_le,

            pktoutadc => pktoutadc,
            pktoutadcclk => pktoutadcclk,
            pktinadc => pktinadc,
            pktinadcclk => pktinadcclk
          );

  Inst_fx2ctrl: fx2ctrl
  PORT MAP(
            RESET => reset,
            CLK => cyifclk_bufg,

            FLAGA => CYFLAGA,
            FLAGB => CYFLAGB,
            FLAGC => CYFLAGC,
            FD => CYFD,
            SLOE => cysloe_out,
            SLRD => cyslrd_out,
            SLWR => cyslwr_out,
            FIFOADR => cyfa_out,
            PKTEND => cypktend_out,

            ADCDATA => adcbus,
            ADCDATACLK => adcbusclk,

            PKTBUS => cybus,
            PKTBUSCLK => cybusclk,

            PKTIN => pktin,
            PKTINCLK => pktinclk
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

  Inst_dualmcb: dualmcb PORT MAP(
                                  c13_clk_2x_0 => memclk,
                                  c13_clk_2x_180 => memclk180,
                                  c13_mcb_drp_clk => fsmclk,
                                  c13_clk_locked => pllvalid,
                                  c13_sys_rst_i => reset,
                                  c13_calib_done => c13_calib_done,
                                  c13_clk0 => c13_clk0,
                                  c13_rst0 => c13_rst0,

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

  Inst_chipscope_ila_fx2 : chipscope_ila_fx2
  port map (
             CONTROL => cs_control0,
             CLK => mclk_bufg,
             TRIG0 => cs_trig_fx2
           );
  Inst_chipscope_ila_uart : chipscope_ila_uart
  port map (
             CONTROL => cs_control1,
             CLK => baudclk,
             TRIG0 => cs_trig_uart
           );

  cs_trig_fx2(15 downto 0) <= CYFD;
  cs_trig_fx2(17 downto 16) <= cyfa_out;
  cs_trig_fx2(18) <= CYFLAGA;
  cs_trig_fx2(19) <= CYFLAGB;
  cs_trig_fx2(20) <= CYFLAGC;
  cs_trig_fx2(21) <= cysloe_out;
  cs_trig_fx2(22) <= cyslrd_out;
  cs_trig_fx2(23) <= cyslwr_out;
  cs_trig_fx2(24) <= cypktend_out;

  --Sort out rest of the connections
  reset <= not pllvalid;

  --Debug forced re-arrangement
  CYSLOE <= cysloe_out;
  CYSLRD <= cyslrd_out;
  CYSLWR <= cyslwr_out;
  CYPKTEND <= cypktend_out;

end Behavioral;
