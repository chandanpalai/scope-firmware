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

         cntrl0_ddr_dq : INOUT std_logic_vector(7 downto 0);
         cntrl0_ddr_dqs : INOUT std_logic_vector(0 to 0);
         cntrl0_ddr_a : OUT std_logic_vector(12 downto 0);
         cntrl0_ddr_ba : OUT std_logic_vector(1 downto 0);
         cntrl0_ddr_cke : OUT std_logic;
         cntrl0_ddr_cs_n : OUT std_logic;
         cntrl0_ddr_ras_n : OUT std_logic;
         cntrl0_ddr_cas_n : OUT std_logic;
         cntrl0_ddr_we_n : OUT std_logic;
         cntrl0_ddr_dm : OUT std_logic_vector(0 to 0);
         cntrl0_ddr_ck : OUT std_logic_vector(0 to 0);
         cntrl0_ddr_ck_n : OUT std_logic_vector(0 to 0)

       );
end main;

architecture Behavioral of main is

  --Clocking
  COMPONENT maindcm
    PORT(
          CLKIN_IN : IN std_logic;
          CLKFX_OUT : OUT std_logic;
          CLKIN_IBUFG_OUT : OUT std_logic;
          CLK0_OUT : OUT std_logic;
          CLK2X_OUT : OUT std_logic;
          LOCKED_OUT : OUT std_logic
        );
  END COMPONENT;

  COMPONENT memdcm
    PORT(
          CLKIN_IN : IN std_logic;
          CLKFX_OUT : OUT std_logic;
          CLK0_OUT : OUT std_logic;
          CLK90_OUT : OUT std_logic;
          LOCKED_OUT : OUT std_logic
        );
  END COMPONENT;

  COMPONENT BR_GENERATOR
    PORT(
          CLOCK : IN std_logic;
          BAUD : OUT std_logic
        );
  END COMPONENT;

  --Modules
  COMPONENT adcctrl
    PORT(
          --General
          RESET : IN std_logic;
          CLK : IN std_logic;

          --to/from ADC
          DA : IN std_logic_vector(7 downto 0);
          DB : IN std_logic_vector(7 downto 0);
          PD : OUT std_logic;
          OE : OUT std_logic;
          SMPLCLK : OUT std_logic;

          --Config
          PKTOUT : IN std_logic_vector(15 downto 0);
          PKTOUTCLK : IN std_logic;

          --to fx2ctrl
          DATA : OUT std_logic_vector(15 downto 0);
          DATACLK : OUT std_logic
  );
  END COMPONENT;

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
          ADCDATA : IN std_logic_vector(15 downto 0);
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

  COMPONENT ddrbuffer
    PORT(
          --General
          reset_in_n : IN std_logic;
          clk_int : IN std_logic;
          clk90_int : IN std_logic;
          dcm_lock : IN std_logic;

          --to/from reset dqs delay loopback
          cntrl0_rst_dqs_div_in : IN std_logic;
          cntrl0_rst_dqs_div_out : OUT std_logic;

          --to/from DDR SDRAM
          cntrl0_ddr_dq : INOUT std_logic_vector(7 downto 0);
          cntrl0_ddr_dqs : INOUT std_logic_vector(0 to 0);
          cntrl0_ddr_a : OUT std_logic_vector(12 downto 0);
          cntrl0_ddr_ba : OUT std_logic_vector(1 downto 0);
          cntrl0_ddr_cke : OUT std_logic;
          cntrl0_ddr_cs_n : OUT std_logic;
          cntrl0_ddr_ras_n : OUT std_logic;
          cntrl0_ddr_cas_n : OUT std_logic;
          cntrl0_ddr_we_n : OUT std_logic;
          cntrl0_ddr_dm : OUT std_logic_vector(0 to 0);
          cntrl0_ddr_ck : OUT std_logic_vector(0 to 0);
          cntrl0_ddr_ck_n : OUT std_logic_vector(0 to 0);

          --from Internal - data path
          cntrl0_user_input_data : IN std_logic_vector(15 downto 0);
          cntrl0_user_input_address : IN std_logic_vector(25 downto 0);
          cntrl0_user_data_mask : IN std_logic_vector(1 downto 0);
          cntrl0_user_command_register : IN std_logic_vector(2 downto 0);
          cntrl0_burst_done : IN std_logic;

          --to Internal - data path
          cntrl0_user_output_data : OUT std_logic_vector(15 downto 0);
          cntrl0_user_data_valid : OUT std_logic;

          cntrl0_user_cmd_ack : OUT std_logic;
          cntrl0_init_val : OUT std_logic;

          --to/from Internal - AR
          cntrl0_ar_done : OUT std_logic;
          cntrl0_auto_ref_req : OUT std_logic;

          --to Testbench
          cntrl0_clk_tb : OUT std_logic;
          cntrl0_clk90_tb : OUT std_logic;
          cntrl0_sys_rst_tb : OUT std_logic;
          cntrl0_sys_rst90_tb : OUT std_logic;
          cntrl0_sys_rst180_tb : OUT std_logic
  );
  END COMPONENT;

  --Debug paths
  component chipscope_icon
    PORT (
           CONTROL0 : INOUT std_logic_vector(35 DOWNTO 0));
  end component;

  component chipscope_ila_fx2
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CLK : IN STD_LOGIC;
    TRIG0 : IN STD_LOGIC_VECTOR(23 DOWNTO 0));

end component;

  --Signals
  signal dcmlocked, memdcmlocked, alllocked : std_logic;
  signal reset : std_logic;
  signal mclk_out : std_logic;
  signal adcbus : std_logic_vector(15 downto 0);
  signal adcbusclk : std_logic;
  signal adcintclk : std_logic;

  signal adcclk_out : std_logic;

  signal cybus : std_logic_vector(15 downto 0);
  signal pktin : std_logic_vector(15 downto 0);
  signal cybusclk, pktinclk : std_logic;

  signal cs_control : std_logic_vector(35 downto 0);
  signal cs_trig : std_logic_vector(23 downto 0);
  signal cyfa_out : std_logic_vector(1 downto 0);
  signal cysloe_out, cyslrd_out, cyslwr_out : std_logic;

  signal pktouta, pktina, pktoutb, pktinb, pktoutadc : std_logic_vector(15 downto 0);
  signal pktoutaclk, pktinaclk, pktoutbclk, pktinbclk, pktoutadcclk : std_logic;

  signal baudclk : std_logic;
  signal txa_out, txb_out : std_logic;
  signal cfgiba,cfgibb : std_logic_vector(15 downto 0);
  signal savea,saveb : std_logic;

  signal ddrrawclk, ddrclk, ddrclk90 : std_logic;
  signal rstdqsdiv : std_logic;
  signal ddrinit, ddrardone : std_logic;
  signal ddruserdatavalid, ddrarrequest : std_logic;
  signal ddruserout_data, ddruserin_data : std_logic_vector (15 downto 0);
  signal ddraddr : std_logic_vector (25 downto 0);
  signal ddruserdata_mask : std_logic_vector (1 downto 0);
  signal ddrcmdack : std_logic;
  signal ddrcmd_register : std_logic_vector (2 downto 0);
  signal ddrburstdone : std_logic;

begin
  --Clocking
  Inst_maindcm: maindcm
  PORT MAP(
            CLKIN_IN => MCLK, --33.333MHz
            CLK0_OUT => mclk_out, --33.333MHz
            CLKFX_OUT => ddrrawclk, --166.667MHz
            --CLK2X_OUT => --66.666MHz
            LOCKED_OUT => dcmlocked
          );

  Inst_memdcm: memdcm
  PORT MAP(
            CLKIN_IN => ddrrawclk, --166.667MHz
            CLKFX_OUT => adcintclk, --200MHz
            CLK0_OUT => ddrclk, --166.667MHz
            CLK90_OUT => ddrclk90, --166.667MHz PHS:90
            LOCKED_OUT => memdcmlocked
          );

  Inst_BR_GENERATOR: BR_GENERATOR
  PORT MAP(
            CLOCK => adcintclk,
            BAUD => baudclk
          );

  --Modules
  Inst_adcctrl: adcctrl
  PORT MAP(
            RESET => reset,
            CLK => adcintclk,

            DA => ADCDA,
            DB => ADCDB,
            PD => ADCPD,
            OE => ADCOE,
            SMPLCLK => adcclk_out,

            PKTOUT => pktoutadc,
            PKTOUTCLK => pktoutadcclk,

            DATA => adcbus,
            DATACLK => adcbusclk
          );

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
            PKTEND => CYPKTEND,

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
            CLK => mclk_out,
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
            CLK => mclk_out,
            BAUDCLK => baudclk,

            RX => RXB,
            TX => txb_out,

            PKTIN => pktinb,
            PKTINCLK => pktinbclk,

            PKTOUT => pktoutb,
            PKTOUTCLK => pktoutbclk
          );

  Inst_ddrbuffer: ddrbuffer
  PORT MAP(
            reset_in_n => reset,
            clk_int => ddrclk,
            clk90_int => ddrclk90,
            dcm_lock => dcmlocked,

            cntrl0_rst_dqs_div_in => rstdqsdiv,
            cntrl0_rst_dqs_div_out => rstdqsdiv,

            cntrl0_ddr_dq => cntrl0_ddr_dq,
            cntrl0_ddr_dqs => cntrl0_ddr_dqs,
            cntrl0_ddr_a => cntrl0_ddr_a,
            cntrl0_ddr_ba => cntrl0_ddr_ba,
            cntrl0_ddr_cke => cntrl0_ddr_cke,
            cntrl0_ddr_cs_n => cntrl0_ddr_cs_n,
            cntrl0_ddr_ras_n => cntrl0_ddr_ras_n,
            cntrl0_ddr_cas_n => cntrl0_ddr_cas_n,
            cntrl0_ddr_we_n => cntrl0_ddr_we_n,
            cntrl0_ddr_dm => cntrl0_ddr_dm,
            cntrl0_ddr_ck => cntrl0_ddr_ck,
            cntrl0_ddr_ck_n => cntrl0_ddr_ck_n,

            cntrl0_user_input_data => ddruserin_data,
            cntrl0_user_input_address => ddraddr,
            cntrl0_user_data_mask => ddruserdata_mask,
            cntrl0_user_command_register => ddrcmd_register,
            cntrl0_burst_done => ddrburstdone,

            cntrl0_user_output_data => ddruserout_data,
            cntrl0_user_data_valid => ddruserdatavalid,

            cntrl0_user_cmd_ack => ddrcmdack,
            cntrl0_init_val => ddrinit,

            cntrl0_ar_done => ddrardone,
            cntrl0_auto_ref_req => ddrarrequest
          );

  --Debug
  Inst_chipscope_icon : chipscope_icon
  port map (
             CONTROL0 => cs_control
           );

  Inst_chipscope_ila_fx2 : chipscope_ila_fx2
  port map (
    CONTROL => cs_control,
    CLK => adcintclk,
    TRIG0 => cs_trig);

  cs_trig(15 downto 0) <= cybus;
  cs_trig(16) <= CYFLAGA;
  cs_trig(17) <= adcclk_out;
  cs_trig(18) <= cybusclk;
  cs_trig(20 downto 19) <= cyfa_out;
  cs_trig(21) <= cysloe_out;
  cs_trig(22) <= cyslrd_out;
  cs_trig(23) <= cyslwr_out;

  CYFIFOADR <= cyfa_out;
  CYSLOE <= cysloe_out;
  CYSLRD <= cyslrd_out;
  CYSLWR <= cyslwr_out;

  ADCCLK <= adcclk_out;


  --Sort out rest of the connections
  alllocked <= dcmlocked and memdcmlocked;
  reset <= not alllocked;

  --Debug forced re-arrangement
  TXA <= txa_out;
  TXB <= txb_out;

end Behavioral;
