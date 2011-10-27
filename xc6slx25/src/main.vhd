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

entity main is
  Port ( ADCDA : in  std_logic_vector (7 downto 0);
         ADCDB : in  std_logic_vector (7 downto 0);
         ADCCLK : out  STD_LOGIC;
         ADCPD : out  STD_LOGIC;
         ADCOE : out  STD_LOGIC;

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

         MCLK : in STD_LOGIC;

         RXA : in STD_LOGIC;
         TXA : out STD_LOGIC;
         RXB : in STD_LOGIC;
         TXB : out STD_LOGIC;

         m1_dram_dq : INOUT std_logic_vector(15 downto 0);
         m1_dram_udqs : INOUT std_logic;
         m1_dram_udqs_n : INOUT std_logic;
         m1_rzq : INOUT std_logic;
         m1_zio : INOUT std_logic;
         m1_dram_dqs : INOUT std_logic;
         m1_dram_dqs_n : INOUT std_logic;
         m1_dram_a : OUT std_logic_vector(12 downto 0);
         m1_dram_ba : OUT std_logic_vector(2 downto 0);
         m1_dram_ras_n : OUT std_logic;
         m1_dram_cas_n : OUT std_logic;
         m1_dram_we_n : OUT std_logic;
         m1_dram_odt : OUT std_logic;
         m1_dram_reset_n : OUT std_logic;
         m1_dram_cke : OUT std_logic;
         m1_dram_dm : OUT std_logic;
         m1_dram_udm : OUT std_logic;
         m1_dram_ck : OUT std_logic;
         m1_dram_ck_n : OUT std_logic;

         m3_dram_dq : INOUT std_logic_vector(15 downto 0);
         m3_dram_udqs : INOUT std_logic;
         m3_dram_udqs_n : INOUT std_logic;
         m3_rzq : INOUT std_logic;
         m3_zio : INOUT std_logic;
         m3_dram_dqs : INOUT std_logic;
         m3_dram_dqs_n : INOUT std_logic;
         m3_dram_a : OUT std_logic_vector(12 downto 0);
         m3_dram_ba : OUT std_logic_vector(2 downto 0);
         m3_dram_ras_n : OUT std_logic;
         m3_dram_cas_n : OUT std_logic;
         m3_dram_we_n : OUT std_logic;
         m3_dram_odt : OUT std_logic;
         m3_dram_reset_n : OUT std_logic;
         m3_dram_cke : OUT std_logic;
         m3_dram_dm : OUT std_logic;
         m3_dram_udm : OUT std_logic;
         m3_dram_ck : OUT std_logic;
         m3_dram_ck_n : OUT std_logic
       );
end main;

architecture Behavioral of main is

  --Clocking
  component maindcm
    port(
          -- Clock in ports
          XTALIN : in std_logic;
          -- Clock out ports
          MEMCLK : out std_logic;
          BAUDCLK : out std_logic;

          LOCKED : out std_logic
        );
  end component;

  component sampledcm
    port(
          -- Clock in ports
          XTALIN : in std_logic;
          -- Clock out ports
          XTALOUT : out std_logic;
          FSMCLK : out std_logic;

          LOCKED : out std_logic
        );
  end component;

  COMPONENT BR_GENERATOR
    PORT(
          CLOCK : IN std_logic;
          BAUD : OUT std_logic
        );
  END COMPONENT;

  --Modules
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

          --to/from IBA
          PKTOUTA : OUT std_logic_vector(15 downto 0);
          PKTOUTACLK : OUT std_logic;

          PKTINA : IN std_logic_vector(15 downto 0);
          PKTINACLK : IN std_logic;

          --to/from IBB
          PKTOUTB : OUT std_logic_vector(15 downto 0);
          PKTOUTBCLK : OUT std_logic;

          PKTINB : IN std_logic_vector(15 downto 0);
          PKTINBCLK : IN std_logic
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

  COMPONENT mig_38
    PORT(
          --External interfoce
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

          --Clock + Reset
          c1_sys_clk : IN std_logic;
          c1_sys_rst_i : IN std_logic;
          c1_calib_done : OUT std_logic;
          c1_clk0 : OUT std_logic;
          c1_rst0 : OUT std_logic;

          c3_sys_clk : IN std_logic;
          c3_sys_rst_i : IN std_logic;
          c3_calib_done : OUT std_logic;
          c3_clk0 : OUT std_logic;
          c3_rst0 : OUT std_logic;

          --Internal ports
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

          c1_p1_cmd_clk : IN std_logic;
          c1_p1_cmd_en : IN std_logic;
          c1_p1_cmd_instr : IN std_logic_vector(2 downto 0);
          c1_p1_cmd_bl : IN std_logic_vector(5 downto 0);
          c1_p1_cmd_byte_addr : IN std_logic_vector(29 downto 0);
          c1_p1_wr_clk : IN std_logic;
          c1_p1_wr_en : IN std_logic;
          c1_p1_wr_mask : IN std_logic_vector(7 downto 0);
          c1_p1_wr_data : IN std_logic_vector(63 downto 0);
          c1_p1_rd_clk : IN std_logic;
          c1_p1_rd_en : IN std_logic;
          c1_p1_cmd_empty : OUT std_logic;
          c1_p1_cmd_full : OUT std_logic;
          c1_p1_wr_full : OUT std_logic;
          c1_p1_wr_empty : OUT std_logic;
          c1_p1_wr_count : OUT std_logic_vector(6 downto 0);
          c1_p1_wr_underrun : OUT std_logic;
          c1_p1_wr_error : OUT std_logic;
          c1_p1_rd_data : OUT std_logic_vector(63 downto 0);
          c1_p1_rd_full : OUT std_logic;
          c1_p1_rd_empty : OUT std_logic;
          c1_p1_rd_count : OUT std_logic_vector(6 downto 0);
          c1_p1_rd_overflow : OUT std_logic;
          c1_p1_rd_error : OUT std_logic;

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
          c3_p0_rd_error : OUT std_logic;
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

          c3_p1_cmd_clk : IN std_logic;
          c3_p1_cmd_en : IN std_logic;
          c3_p1_cmd_instr : IN std_logic_vector(2 downto 0);
          c3_p1_cmd_bl : IN std_logic_vector(5 downto 0);
          c3_p1_cmd_byte_addr : IN std_logic_vector(29 downto 0);
          c3_p1_wr_clk : IN std_logic;
          c3_p1_wr_en : IN std_logic;
          c3_p1_wr_mask : IN std_logic_vector(7 downto 0);
          c3_p1_wr_data : IN std_logic_vector(63 downto 0);
          c3_p1_rd_clk : IN std_logic;
          c3_p1_rd_en : IN std_logic;
          c3_p1_wr_full : OUT std_logic;
          c3_p1_wr_empty : OUT std_logic;
          c3_p1_wr_count : OUT std_logic_vector(6 downto 0);
          c3_p1_wr_underrun : OUT std_logic;
          c3_p1_wr_error : OUT std_logic;
          c3_p1_rd_data : OUT std_logic_vector(63 downto 0);
          c3_p1_rd_full : OUT std_logic;
          c3_p1_rd_empty : OUT std_logic;
          c3_p1_rd_count : OUT std_logic_vector(6 downto 0);
          c3_p1_rd_overflow : OUT std_logic;
          c3_p1_rd_error : OUT std_logic;
          c3_p1_cmd_empty : OUT std_logic;
          c3_p1_cmd_full : OUT std_logic
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
  signal dcmlocked, sampledcmlocked, alllocked : std_logic;
  signal mclk_bufg, fsmclk : std_logic;
  signal reset : std_logic;
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

  signal pktouta, pktina, pktoutb, pktinb, pktoutadc : std_logic_vector(15 downto 0);
  signal pktoutaclk, pktinaclk, pktoutbclk, pktinbclk, pktoutadcclk : std_logic;

  signal uartclk, baudclk : std_logic;
  signal txa_out, txb_out : std_logic;
  signal cfgiba,cfgibb : std_logic_vector(15 downto 0);
  signal savea,saveb : std_logic;

  signal memclk : std_logic;
  signal c1_p0_cmd_clk, c1_p1_cmd_clk, c3_p0_cmd_clk, c3_p1_cmd_clk : std_logic;
  signal c1_p0_cmd_en, c1_p1_cmd_en, c3_p0_cmd_en, c3_p1_cmd_en : std_logic;
  signal c1_p0_cmd_instr, c1_p1_cmd_instr : std_logic_vector(2 downto 0);
  signal c3_p0_cmd_instr, c3_p1_cmd_instr : std_logic_vector(2 downto 0);
  signal c1_p0_cmd_bl, c1_p1_cmd_bl, c3_p0_cmd_bl, c3_p1_cmd_bl : std_logic_vector(5 downto 0);
  signal c1_p0_cmd_byte_addr, c1_p1_cmd_byte_addr : std_logic_vector(29 downto 0);
  signal c3_p0_cmd_byte_addr, c3_p1_cmd_byte_addr : std_logic_vector(29 downto 0);
  signal c1_p0_wr_clk, c1_p1_wr_clk, c3_p0_wr_clk, c3_p1_wr_clk : std_logic;
  signal c1_p0_wr_en, c1_p1_wr_en, c3_p0_wr_en, c3_p1_wr_en : std_logic;
  signal c1_p0_wr_mask, c1_p1_wr_mask, c3_p0_wr_mask, c3_p1_wr_mask : std_logic_vector(7 downto 0);
  signal c1_p0_wr_data, c1_p1_wr_data : std_logic_vector(63 downto 0);
  signal c3_p0_wr_data, c3_p1_wr_data : std_logic_vector(63 downto 0);
  signal c1_p0_rd_clk, c1_p1_rd_clk, c3_p0_rd_clk, c3_p1_rd_clk : std_logic;
  signal c1_p0_rd_en, c1_p1_rd_en, c3_p0_rd_en, c3_p1_rd_en : std_logic;
begin
  --Clocking
  Inst_maindcm : maindcm
  port map(
            XTALIN => mclk_bufg,

            MEMCLK => memclk, --400MHz
            BAUDCLK => uartclk, --20MHz

            LOCKED => dcmlocked
          );

  Inst_sampledcm : sampledcm
  port map(
            XTALIN => MCLK,

            XTALOUT => mclk_bufg, --150MHz
            FSMCLK => fsmclk, --375MHz

            LOCKED => sampledcmlocked
          );

  Inst_BR_GENERATOR: BR_GENERATOR
  PORT MAP(
            CLOCK => uartclk,
            BAUD => baudclk
          );

  --Modules
  Inst_fx2ctrl: fx2ctrl
  PORT MAP(
            RESET => reset,
            CLK => CYIFCLK,

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
  PORT MAP(
            RESET => reset,
            CLK => CYIFCLK,

            PKTBUS => cybus,
            PKTBUSCLK => cybusclk,

            PKTIN => pktin,
            PKTINCLK => pktinclk,

            PKTOUTADC => pktoutadc,
            PKTOUTADCCLK => pktoutadcclk,

            PKTOUTA => pktouta,
            PKTOUTACLK => pktoutaclk,

            PKTINA => pktina,
            PKTINACLK => pktinaclk,

            PKTOUTB => pktoutb,
            PKTOUTBCLK => pktoutbclk,

            PKTINB => pktinb,
            PKTINBCLK => pktinbclk
          );

  Inst_ibctrla: ibctrl
  PORT MAP(
            RESET => reset,
            CLK => CYIFCLK,
            BAUDCLK => baudclk,

            RX => RXA,
            TX => txa_out,

            PKTIN => pktina,
            PKTINCLK => pktinaclk,

            PKTOUT => pktouta,
            PKTOUTCLK => pktoutaclk
          );

  Inst_ibctrlb: ibctrl
  PORT MAP(
            RESET => reset,
            CLK => CYIFCLK,
            BAUDCLK => baudclk,

            RX => RXB,
            TX => txb_out,

            PKTIN => pktinb,
            PKTINCLK => pktinbclk,

            PKTOUT => pktoutb,
            PKTOUTCLK => pktoutbclk
          );

  Inst_mig_38: mig_38
  PORT MAP(
            mcb1_dram_dq => m1_dram_dq,
            mcb1_dram_a => m1_dram_a,
            mcb1_dram_ba => m1_dram_ba,
            mcb1_dram_ras_n => m1_dram_ras_n,
            mcb1_dram_cas_n => m1_dram_cas_n,
            mcb1_dram_we_n => m1_dram_we_n,
            mcb1_dram_odt => m1_dram_odt,
            mcb1_dram_reset_n => m1_dram_reset_n,
            mcb1_dram_cke => m1_dram_cke,
            mcb1_dram_dm => m1_dram_dm,
            mcb1_dram_udqs => m1_dram_udqs,
            mcb1_dram_udqs_n => m1_dram_udqs_n,
            mcb1_rzq => m1_rzq,
            mcb1_zio => m1_zio,
            mcb1_dram_udm => m1_dram_udm,
            mcb1_dram_dqs => m1_dram_dqs,
            mcb1_dram_dqs_n => m1_dram_dqs_n,
            mcb1_dram_ck => m1_dram_ck,
            mcb1_dram_ck_n => m1_dram_ck_n,

            mcb3_dram_dq => m3_dram_dq,
            mcb3_dram_a => m3_dram_a,
            mcb3_dram_ba => m3_dram_ba,
            mcb3_dram_ras_n => m3_dram_ras_n,
            mcb3_dram_cas_n => m3_dram_cas_n,
            mcb3_dram_we_n => m3_dram_we_n,
            mcb3_dram_odt => m3_dram_odt,
            mcb3_dram_reset_n => m3_dram_reset_n,
            mcb3_dram_cke => m3_dram_cke,
            mcb3_dram_dm => m3_dram_dm,
            mcb3_dram_udqs => m3_dram_udqs,
            mcb3_dram_udqs_n => m3_dram_udqs_n,
            mcb3_rzq => m3_rzq,
            mcb3_zio => m3_zio,
            mcb3_dram_udm => m3_dram_udm,
            mcb3_dram_dqs => m3_dram_dqs,
            mcb3_dram_dqs_n => m3_dram_dqs_n,
            mcb3_dram_ck => m3_dram_ck,
            mcb3_dram_ck_n => m3_dram_ck_n,

            c1_sys_clk => memclk,
            c1_sys_rst_i => reset,
            --	c1_calib_done => ,
            --	c1_clk0 => ,
            --	c1_rst0 => ,
            --
            c3_sys_clk => memclk,
            c3_sys_rst_i => reset,
          --	c3_calib_done => ,
          --	c3_clk0 => ,
          --	c3_rst0 => ,
          --
          	c1_p0_cmd_clk => c1_p0_cmd_clk,
          	c1_p0_cmd_en => c1_p0_cmd_en,
          	c1_p0_cmd_instr => c1_p0_cmd_instr,
          	c1_p0_cmd_bl => c1_p0_cmd_bl,
          	c1_p0_cmd_byte_addr => c1_p0_cmd_byte_addr,
          --	c1_p0_cmd_empty => ,
          --	c1_p0_cmd_full => ,
          	c1_p0_wr_clk => c1_p0_wr_clk,
          	c1_p0_wr_en => c1_p0_wr_en,
          	c1_p0_wr_mask => c1_p0_wr_mask,
          	c1_p0_wr_data => c1_p0_wr_data,
          --	c1_p0_wr_full => ,
          --	c1_p0_wr_empty => ,
          --	c1_p0_wr_count => ,
          --	c1_p0_wr_underrun => ,
          --	c1_p0_wr_error => ,
          	c1_p0_rd_clk => c1_p0_rd_clk,
          	c1_p0_rd_en => c1_p0_rd_en,
          --	c1_p0_rd_data => ,
          --	c1_p0_rd_full => ,
          --	c1_p0_rd_empty => ,
          --	c1_p0_rd_count => ,
          --	c1_p0_rd_overflow => ,
          --	c1_p0_rd_error => ,
          --
          	c1_p1_cmd_clk => c1_p1_cmd_clk,
          	c1_p1_cmd_en => c1_p1_cmd_en,
          	c1_p1_cmd_instr => c1_p1_cmd_instr,
          	c1_p1_cmd_bl => c1_p1_cmd_bl,
          	c1_p1_cmd_byte_addr => c1_p1_cmd_byte_addr,
          --	c1_p1_cmd_empty => ,
          --	c1_p1_cmd_full => ,
          	c1_p1_wr_clk => c1_p1_wr_clk,
          	c1_p1_wr_en => c1_p1_wr_en,
          	c1_p1_wr_mask => c1_p1_wr_mask,
          	c1_p1_wr_data => c1_p1_wr_data,
          --	c1_p1_wr_full => ,
          --	c1_p1_wr_empty => ,
          --	c1_p1_wr_count => ,
          --	c1_p1_wr_underrun => ,
          --	c1_p1_wr_error => ,
          	c1_p1_rd_clk => c1_p1_rd_clk,
          	c1_p1_rd_en => c1_p1_rd_en,
          --	c1_p1_rd_data => ,
          --	c1_p1_rd_full => ,
          --	c1_p1_rd_empty => ,
          --	c1_p1_rd_count => ,
          --	c1_p1_rd_overflow => ,
          --	c1_p1_rd_error => ,
          --
          	c3_p0_cmd_clk => c3_p0_cmd_clk,
          	c3_p0_cmd_en => c3_p0_cmd_en,
          	c3_p0_cmd_instr => c3_p0_cmd_instr,
          	c3_p0_cmd_bl => c3_p0_cmd_bl,
          	c3_p0_cmd_byte_addr => c3_p0_cmd_byte_addr,
          --	c3_p0_cmd_empty => ,
          --	c3_p0_cmd_full => ,
          	c3_p0_wr_clk => c3_p0_wr_clk,
          	c3_p0_wr_en => c3_p0_wr_en,
          	c3_p0_wr_mask => c3_p0_wr_mask,
          	c3_p0_wr_data => c3_p0_wr_data,
          --	c3_p0_wr_full => ,
          --	c3_p0_wr_empty => ,
          --	c3_p0_wr_count => ,
          --	c3_p0_wr_underrun => ,
          --	c3_p0_wr_error => ,
          	c3_p0_rd_clk => c3_p0_rd_clk,
          	c3_p0_rd_en => c3_p0_rd_en,
          --	c3_p0_rd_data => ,
          --	c3_p0_rd_full => ,
          --	c3_p0_rd_empty => ,
          --	c3_p0_rd_count => ,
          --	c3_p0_rd_overflow => ,
          --	c3_p0_rd_error => ,
          --
          	c3_p1_cmd_clk => c3_p1_cmd_clk,
          	c3_p1_cmd_en => c3_p1_cmd_en,
          	c3_p1_cmd_instr => c3_p1_cmd_instr,
          	c3_p1_cmd_bl => c3_p1_cmd_bl,
          	c3_p1_cmd_byte_addr => c3_p1_cmd_byte_addr,
          --	c3_p1_cmd_empty => ,
          --	c3_p1_cmd_full => ,
          	c3_p1_wr_clk => c3_p0_wr_clk,
          	c3_p1_wr_en => c3_p0_wr_en,
          	c3_p1_wr_mask => c3_p1_wr_mask,
          	c3_p1_wr_data => c3_p1_wr_data,
          --	c3_p1_wr_full => ,
          --	c3_p1_wr_empty => ,
          --	c3_p1_wr_count => ,
          --	c3_p1_wr_underrun => ,
          --	c3_p1_wr_error => ,
          	c3_p1_rd_clk => c3_p1_rd_clk,
          	c3_p1_rd_en => c3_p1_rd_en--,
          --	c3_p1_rd_data => ,
          --	c3_p1_rd_full => ,
          --	c3_p1_rd_empty => ,
          --	c3_p1_rd_count => ,
          --	c3_p1_rd_overflow => ,
          --	c3_p1_rd_error =>
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

  cs_trig_uart(0) <= RXA;
  cs_trig_uart(1) <= txa_out;
  cs_trig_uart(2) <= RXB;
  cs_trig_uart(3) <= txb_out;

  --Sort out rest of the connections
  alllocked <= dcmlocked and sampledcmlocked;
  reset <= not alllocked;

  --Debug forced re-arrangement
  TXA <= txa_out;
  TXB <= txb_out;
  CYSLOE <= cysloe_out;
  CYSLRD <= cyslrd_out;
  CYSLWR <= cyslwr_out;
  CYPKTEND <= cypktend_out;

end Behavioral;
