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
  COMPONENT adc
    PORT(
          DA : IN std_logic_vector(7 downto 0);
          DB : IN std_logic_vector(7 downto 0);
          ZZ : IN std_logic;
          CLKM : IN std_logic;
          CFGCLK : IN std_logic_vector(7 downto 0);
          CFGCHNL : IN std_logic_vector(1 downto 0);
          DATA : OUT std_logic_vector(15 downto 0);
          DATACLK : OUT std_logic;
          PD : OUT std_logic;
          OE : OUT std_logic;
          CLKSMPL : OUT std_logic
        );
  END COMPONENT;

  COMPONENT fx2
    PORT(
          ADCDATA : IN std_logic_vector(15 downto 0);
          ADCDATACLK : IN std_logic;

          CFGDATA : IN std_logic_vector(15 downto 0);
          CFGDATACLK : IN std_logic;

          OUTDATA : OUT std_logic_vector(15 downto 0);
          OUTDATACLK : OUT std_logic;

          CLKIF : IN std_logic;
          RESET : IN std_logic;

          FLAGA : IN std_logic;
          FLAGB : IN std_logic;
          FLAGC : IN std_logic;
          FD : INOUT std_logic_vector(15 downto 0);
          SLOE : OUT std_logic;
          SLRD : OUT std_logic;
          SLWR : OUT std_logic;
          FIFOADR : OUT std_logic_vector(1 downto 0);
          PKTEND : OUT std_logic
        );
  END COMPONENT;

  COMPONENT think
    PORT(
          DATAIN : IN std_logic_vector(15 downto 0);
          DATACLK : IN std_logic;

          RESET : IN std_logic;
          CLKIF : IN std_logic;
          ZZ : OUT std_logic;
          CFGCLK : OUT std_logic_vector(7 downto 0);
          CFGCHNL : OUT std_logic_vector(1 downto 0);

          CFGIBA : out STD_LOGIC_VECTOR(15 downto 0);
          CFGIBB : out STD_LOGIC_VECTOR(15 downto 0);
          SAVEA : out STD_LOGIC;
          SAVEB : out STD_LOGIC
        );
  END COMPONENT;

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

  COMPONENT inputBoard
    PORT(
          RESET : IN std_logic;
          CLK : IN std_logic;
          BAUDCLK : IN std_logic;
          CFGIB : IN std_logic_vector(15 downto 0);
          SAVE : IN std_logic;
          DATAOUT : out std_logic_vector(15 downto 0);
          DATACLK : out std_logic;
          RX : IN std_logic;
          TX : OUT std_logic
        );
  END COMPONENT;


  component chipscope_icon
    PORT (
           CONTROL0 : INOUT std_logic_vector(35 DOWNTO 0));
  end component;

  component chipscope_ila_uart
    PORT (
           CONTROL : INOUT std_logic_vector(35 DOWNTO 0);
           CLK : IN STD_LOGIC;
           TRIG0 : IN std_logic_vector(3 DOWNTO 0));
  end component;

  COMPONENT BR_GENERATOR
    PORT(
          CLOCK : IN std_logic;
          BAUD : OUT std_logic
        );
  END COMPONENT;

  COMPONENT ddrbuffer
    PORT(
          cntrl0_rst_dqs_div_in : IN std_logic;
          reset_in_n : IN std_logic;
          cntrl0_burst_done : IN std_logic;
          cntrl0_user_command_register : IN std_logic_vector(2 downto 0);
          cntrl0_user_data_mask : IN std_logic_vector(1 downto 0);
          cntrl0_user_input_data : IN std_logic_vector(15 downto 0);
          cntrl0_user_input_address : IN std_logic_vector(25 downto 0);
          clk_int : IN std_logic;
          clk90_int : IN std_logic;
          dcm_lock : IN std_logic;
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
          cntrl0_rst_dqs_div_out : OUT std_logic;
          cntrl0_init_val : OUT std_logic;
          cntrl0_ar_done : OUT std_logic;
          cntrl0_user_data_valid : OUT std_logic;
          cntrl0_auto_ref_req : OUT std_logic;
          cntrl0_user_cmd_ack : OUT std_logic;
          cntrl0_clk_tb : OUT std_logic;
          cntrl0_clk90_tb : OUT std_logic;
          cntrl0_sys_rst_tb : OUT std_logic;
          cntrl0_sys_rst90_tb : OUT std_logic;
          cntrl0_sys_rst180_tb : OUT std_logic;
          cntrl0_user_output_data : OUT std_logic_vector(15 downto 0);
          cntrl0_ddr_ck : OUT std_logic_vector(0 to 0);
          cntrl0_ddr_ck_n : OUT std_logic_vector(0 to 0)
        );
  END COMPONENT;

  signal zz : std_logic;
  signal cfgclk : std_logic_vector(7 downto 0);
  signal cfgchnl : std_logic_vector(1 downto 0);
  signal dcmlocked, memdcmlocked, alllocked : std_logic;
  signal reset : std_logic;
  signal mclk_out : std_logic;
  signal adcbus : std_logic_vector(15 downto 0);
  signal adcbusclk : std_logic;
  signal cybus : std_logic_vector(15 downto 0);
  signal cybusclk : std_logic;
  signal adcintclk : std_logic;
  signal adcsmplclk : std_logic;
  signal adcpd_out : std_logic;
  signal adcoe_out : std_logic;
  signal cfgdata : std_logic_vector(15 downto 0);
  signal cfgdataclk : std_logic;

  signal cs_control_uart : std_logic_vector(35 downto 0);
  signal cs_uart : std_logic_vector(3 downto 0);

  signal cysloe_out : std_logic;
  signal cyslrd_out : std_logic;
  signal cyslwr_out : std_logic;
  signal cyfifoadr_out : std_logic_vector(1 downto 0);

  signal clk_baud : std_logic;
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
  Inst_adc: adc
  PORT MAP(
            DA => ADCDA,
            DB => ADCDB,
            DATA => adcbus,
            DATACLK => adcbusclk,
            ZZ => zz,
            PD => adcpd_out,
            OE => adcoe_out,
            CLKSMPL => adcsmplclk,
            CLKM => adcintclk,
            CFGCLK => cfgclk,
            CFGCHNL => cfgchnl
          );

  Inst_fx2: fx2
  PORT MAP(
            ADCDATA => adcbus,
            ADCDATACLK => adcbusclk,

            CFGDATA => cfgdata,
            CFGDATACLK => cfgdataclk,

            OUTDATA => cybus,
            OUTDATACLK => cybusclk,

            CLKIF => CYIFCLK,
            RESET => reset,
            FD => CYFD,
            FLAGA => CYFLAGA,
            FLAGB => CYFLAGB,
            FLAGC => CYFLAGC,
            SLOE => cysloe_out,
            SLRD => cyslrd_out,
            SLWR => cyslwr_out,
            FIFOADR => cyfifoadr_out,
            PKTEND => CYPKTEND
          );

  Inst_think: think
  PORT MAP(
            DATAIN => cybus,
            DATACLK => cybusclk,

            RESET => reset,
            CLKIF => CYIFCLK,
            ZZ => zz,
            CFGCLK => cfgclk,
            CFGCHNL => cfgchnl,
            CFGIBA => cfgiba,
            CFGIBB => cfgibb,
            SAVEA => savea,
            SAVEB => saveb
          );

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

  Inst_inputBoardA: inputBoard
  PORT MAP(
            RESET => reset,
            CLK => mclk_out,
            BAUDCLK => clk_baud,
            CFGIB => cfgiba,
            SAVE => savea,
            RX => RXA,
            TX => txa_out
          );

  Inst_inputBoardB: inputBoard
  PORT MAP(
            RESET => reset,
            CLK => mclk_out,
            BAUDCLK => clk_baud,
            CFGIB => cfgibb,
            SAVE => saveb,
            RX => RXB,
            TX => txb_out
          );


  Inst_chipscope_icon : chipscope_icon
  port map (
             CONTROL0 => cs_control_uart
           );

  Inst_chipscope_ila_uart : chipscope_ila_uart
  port map (
             CONTROL => cs_control_uart,
             CLK => clk_baud,
             TRIG0 => cs_uart
           );

  Inst_BR_GENERATOR: BR_GENERATOR
  PORT MAP(
            CLOCK => mclk_out,
            BAUD => clk_baud
          );

  alllocked <= dcmlocked and memdcmlocked;
  reset <= not alllocked;

  ADCCLK <= adcsmplclk;
  ADCPD <= adcpd_out;
  ADCOE <= adcoe_out;

  CYSLOE <= cysloe_out;
  CYSLRD <= cyslrd_out;
  CYSLWR <= cyslwr_out;
  CYFIFOADR <= cyfifoadr_out;

  TXA <= txa_out;
  TXB <= txb_out;

  cs_uart(0) <= RXA;
  cs_uart(1) <= txa_out;
  cs_uart(2) <= RXB;
  cs_uart(3) <= txb_out;


  Inst_ddrbuffer: ddrbuffer
  PORT MAP(
            --Clocks
            reset_in_n => reset,
            dcm_lock => dcmlocked,
            clk_int => ddrclk,
            clk90_int => ddrclk90,

            --to mem device
            cntrl0_ddr_dqs => cntrl0_ddr_dqs,
            cntrl0_ddr_ck => cntrl0_ddr_ck,
            cntrl0_ddr_ck_n => cntrl0_ddr_ck_n,
            cntrl0_ddr_dq => cntrl0_ddr_dq,
            cntrl0_ddr_a => cntrl0_ddr_a,
            cntrl0_ddr_ba => cntrl0_ddr_ba,
            cntrl0_ddr_cke => cntrl0_ddr_cke,
            cntrl0_ddr_cs_n => cntrl0_ddr_cs_n,
            cntrl0_ddr_ras_n => cntrl0_ddr_ras_n,
            cntrl0_ddr_cas_n => cntrl0_ddr_cas_n,
            cntrl0_ddr_we_n => cntrl0_ddr_we_n,
            cntrl0_ddr_dm => cntrl0_ddr_dm,

            --to (non-existant) loop-back
            cntrl0_rst_dqs_div_in => rstdqsdiv,
            cntrl0_rst_dqs_div_out => rstdqsdiv,

            --to FPGA
            cntrl0_burst_done => ddrburstdone,
            cntrl0_init_val => ddrinit,
            cntrl0_ar_done => ddrardone,
            cntrl0_user_data_valid => ddruserdatavalid,
            cntrl0_auto_ref_req => ddrarrequest,
            cntrl0_user_cmd_ack => ddrcmdack,
            cntrl0_user_command_register => ddrcmd_register,
            cntrl0_user_data_mask => ddruserdata_mask,
            cntrl0_user_output_data => ddruserout_data,
            cntrl0_user_input_data => ddruserin_data,
            cntrl0_user_input_address => ddraddr

          --to (non-existant) TB
          --cntrl0_clk_tb => ,
          --cntrl0_clk90_tb => ,
          --cntrl0_sys_rst_tb => ,
          --cntrl0_sys_rst90_tb => ,
          --cntrl0_sys_rst180_tb => ,
          );
end Behavioral;
