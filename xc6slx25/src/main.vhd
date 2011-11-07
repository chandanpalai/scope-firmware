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
generic
(
  NUM_IB : integer := 4
);
  Port (
         --ADC Lines
         adc_sdata : out std_logic;
         adc_sclk : out std_logic;
         adc_bclk : in std_logic;
         adc_bclk_n : in std_logic;
         adc_fclk : in std_logic;
         adc_fclk_n : in std_logic;
         adc_d1a : in std_logic;
         adc_d1a_n : in std_logic;
         adc_d2a : in std_logic;
         adc_d2a_n : in std_logic;
         adc_d3a : in std_logic;
         adc_d3a_n : in std_logic;
         adc_d4a : in std_logic;
         adc_d4a_n : in std_logic;

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
  signal pktoutadc : std_logic_vector(15 downto 0);
  signal pktoutadcclk : std_logic;

  signal uartclk, baudclk : std_logic;
  signal txa_out, txb_out : std_logic;
  signal i : integer;
  signal cfgiba,cfgibb : std_logic_vector(15 downto 0);
  signal savea,saveb : std_logic;

  signal memclk, memclk180 : std_logic;

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


  Inst_BR_GENERATOR: BR_GENERATOR
  PORT MAP(
            CLOCK => memclk,
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
  generic map ( NUM_IB => NUM_IB )
  PORT MAP(
            RESET => reset,
            CLK => CYIFCLK,

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
              CLK => CYIFCLK,
              BAUDCLK => baudclk,

              RX => RX(i),
              TX => TX(i),

              PKTIN => pktinib(i*16+15 downto i*16),
              PKTINCLK => pktinibclk(i),

              PKTOUT => pktoutib(i*16+15 downto i*16),
              PKTOUTCLK => pktoutibclk(i)
             );
  end generate IB;

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
