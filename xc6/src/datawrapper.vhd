---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : datawrapper.vhd
--
-- Abstract    : Redirects the data from the adc buffer to either the DDR3 memory module, or to the FX3 depending on load
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------------------------
entity datawrapper is
---------------------------------------------------------------------------
generic
(
  NUM_DQ_PINS        : integer := 16;
  MASK_SIZE          : integer := 16;
  MEM_ADDR_WIDTH     : integer := 14;
  MEM_BANKADDR_WIDTH : integer := 3;
  DATA_PORT_SIZE     : integer := 128
);
port
(
  sys_rst : in std_logic;
  clk     : in std_logic;

  --Think interface
  cfg : inout std_logic_vector(4 downto 0);

  --ADC data interface
  adc_datard          : in std_logic_vector(63 downto 0);
  adc_datard_clk      : out std_logic;
  adc_datard_en       : out std_logic;
  adc_datard_full     : in std_logic;
  adc_datard_empty    : in std_logic;
  adc_datard_rd_count : in std_logic_vector(14 downto 0);
  adc_datard_wr_count : in std_logic_vector(14 downto 0);

  --DDR interface
  ddrclk            : in std_logic;
  mcb3_dram_dq      : inout  std_logic_vector(NUM_DQ_PINS-1 downto 0);
  mcb3_dram_a       : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
  mcb3_dram_ba      : out std_logic_vector(MEM_BANKADDR_WIDTH-1 downto 0);
  mcb3_dram_ras_n   : out std_logic;
  mcb3_dram_cas_n   : out std_logic;
  mcb3_dram_we_n    : out std_logic;
  mcb3_dram_odt     : out std_logic;
  mcb3_dram_reset_n : out std_logic;
  mcb3_dram_cke     : out std_logic;
  mcb3_dram_dm      : out std_logic;
  mcb3_dram_udqs_p  : inout  std_logic;
  mcb3_dram_udqs_n  : inout  std_logic;
  mcb3_rzq          : inout  std_logic;
  mcb3_zio          : inout  std_logic;
  mcb3_dram_udm     : out std_logic;
  mcb3_dram_dqs_p   : inout  std_logic;
  mcb3_dram_dqs_n   : inout  std_logic;
  mcb3_dram_ck_p    : out std_logic;
  mcb3_dram_ck_n    : out std_logic;

  --FX3 interface
  fx3_adcdata      : out std_logic_vector(63 downto 0);
  fx3_adcdataclk   : out std_logic;
  fx3_adcdataen    : out std_logic;
  fx3_adcdatafull  : in std_logic;
  fx3_adcdataempty : in std_logic
);
end datawrapper;


---------------------------------------------------------------------------
architecture Behavioral of datawrapper is
---------------------------------------------------------------------------

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

  component memwrapper
    generic (
              NUM_DQ_PINS        : integer := 16;
              MASK_SIZE          : integer := 16;
              MEM_ADDR_WIDTH     : integer := 14;
              MEM_BANKADDR_WIDTH : integer := 3;
              DATA_PORT_SIZE     : integer := 128
            );
    port (
            sys_rst : in std_logic;
            clk     : in std_logic;

            --MCB interface
            ddrclk            : in std_logic;
            mcb3_dram_dq      : inout  std_logic_vector(NUM_DQ_PINS-1 downto 0);
            mcb3_dram_a       : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
            mcb3_dram_ba      : out std_logic_vector(MEM_BANKADDR_WIDTH-1 downto 0);
            mcb3_dram_ras_n   : out std_logic;
            mcb3_dram_cas_n   : out std_logic;
            mcb3_dram_we_n    : out std_logic;
            mcb3_dram_odt     : out std_logic;
            mcb3_dram_reset_n : out std_logic;
            mcb3_dram_cke     : out std_logic;
            mcb3_dram_dm      : out std_logic;
            mcb3_dram_udqs_p  : inout  std_logic;
            mcb3_dram_udqs_n  : inout  std_logic;
            mcb3_rzq          : inout  std_logic;
            mcb3_zio          : inout  std_logic;
            mcb3_dram_udm     : out std_logic;
            mcb3_dram_dqs_p   : inout  std_logic;
            mcb3_dram_dqs_n   : inout  std_logic;
            mcb3_dram_ck_p    : out std_logic;
            mcb3_dram_ck_n    : out std_logic;

            --ADC FIFO interface
            adc_wr_clk  : in std_logic;
            adc_wr_en   : in std_logic;
            adc_wr_data : in std_logic_vector(63 downto 0);
            adc_wr_full : out std_logic;

            adc_rd_clk   : in std_logic;
            adc_rd_en    : in std_logic;
            adc_rd_data  : out std_logic_vector(63 downto 0);
            adc_rd_empty : out std_logic
          );
  end component memwrapper;

  signal dcm_fb : std_logic;
  signal slowclk : std_logic;

  signal mem_adc_wr_en, mem_adc_rd_en      : std_logic;
  signal mem_adc_wr_data, mem_adc_rd_data  : std_logic_vector(63 downto 0);
  signal mem_adc_wr_full, mem_adc_rd_empty : std_logic;

  type state_type is (st0_direct, st1_save, st2_restore);
  signal state : state_type := st0_direct;

begin
  Inst_dcm : DCM_SP
  generic map (
                TimingChecksOn        => true,
                InstancePath          => "*",
                Xon                   => true,
                MsgOn                 => false,
                CLKDV_DIVIDE          => 4.0,
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
             CLK0     => dcm_fb,
             CLK180   => open,
             CLK270   => open,
             CLK2X    => open,
             CLK2X180 => open,
             CLK90    => open,
             CLKDV    => slowclk,
             CLKFX    => open,
             CLKFX180 => open,
             LOCKED   => open,
             PSDONE   => open,
             STATUS   => open,
             CLKFB    => dcm_fb,
             CLKIN    => clk,
             DSSEN    => open,
             PSCLK    => open,
             PSEN     => open,
             PSINCDEC => open,
             RST      => sys_rst
             );

  Inst_memwrapper : memwrapper
  generic map (
                NUM_DQ_PINS        => NUM_DQ_PINS,
                MASK_SIZE          => MASK_SIZE,
                MEM_ADDR_WIDTH     => MEM_ADDR_WIDTH,
                MEM_BANKADDR_WIDTH => MEM_BANKADDR_WIDTH,
                DATA_PORT_SIZE     => DATA_PORT_SIZE
                )
  port map (
             sys_rst           => sys_rst,
             clk               => clk,
             ddrclk            => ddrclk,
             mcb3_dram_dq      => mcb3_dram_dq,
             mcb3_dram_a       => mcb3_dram_a,
             mcb3_dram_ba      => mcb3_dram_ba,
             mcb3_dram_ras_n   => mcb3_dram_ras_n,
             mcb3_dram_cas_n   => mcb3_dram_cas_n,
             mcb3_dram_we_n    => mcb3_dram_we_n,
             mcb3_dram_odt     => mcb3_dram_odt,
             mcb3_dram_reset_n => mcb3_dram_reset_n,
             mcb3_dram_cke     => mcb3_dram_cke,
             mcb3_dram_dm      => mcb3_dram_dm,
             mcb3_dram_udqs_p  => mcb3_dram_udqs_p,
             mcb3_dram_udqs_n  => mcb3_dram_udqs_n,
             mcb3_rzq          => mcb3_rzq,
             mcb3_zio          => mcb3_zio,
             mcb3_dram_udm     => mcb3_dram_udm,
             mcb3_dram_dqs_p   => mcb3_dram_dqs_p,
             mcb3_dram_dqs_n   => mcb3_dram_dqs_n,
             mcb3_dram_ck_p    => mcb3_dram_ck_p,
             mcb3_dram_ck_n    => mcb3_dram_ck_n,
             adc_wr_clk        => clk,
             adc_wr_en         => mem_adc_wr_en,
             adc_wr_data       => mem_adc_wr_data,
             adc_wr_full       => mem_adc_wr_full,
             adc_rd_clk        => clk,
             adc_rd_en         => mem_adc_rd_en,
             adc_rd_data       => mem_adc_rd_data,
             adc_rd_empty      => mem_adc_rd_empty
             );

  cfg <= (others => 'Z');

  ctrl : process(slowclk, sys_rst)
  begin
    if slowclk'event and slowclk = '1' then
      if sys_rst = '1' then
        state <= st0_direct;
      else
        case state is
          when st0_direct =>
            --constant of ~2/3 full?
            if adc_datard_rd_count < "100010000000000" and fx3_adcdatafull = '0' then
              fx3_adcdata    <= adc_datard;
              adc_datard_clk <= slowclk;
              adc_datard_en  <= '1';
              fx3_adcdataclk <= slowclk;
              fx3_adcdataen  <= '1';
            else
              state         <= st1_save;
              fx3_adcdataen <= '0';
              adc_datard_en <= '0';
            end if;

          when st1_save =>
            if mem_adc_wr_full = '0' or adc_datard_empty = '0' then
              mem_adc_wr_data <= adc_datard;
              adc_datard_clk  <= clk;
              adc_datard_en   <= '1';
              mem_adc_wr_en   <= '1';
            else
              adc_datard_en <= '0';
              mem_adc_wr_en <= '0';
              state         <= st2_restore;
            end if;

          when st2_restore =>
            if mem_adc_wr_empty = '0' and fx3_adcdatafull = '0' then
              fx3_adcdata    <= mem_adc_rd_data;
              mem_adc_rd_en  <= '1';
              fx3_adcdataclk <= clk;
              fx3_adcdataen  <= '1';
            else
              mem_adc_rd_en <= '0';
              fx3_adcdataen <= '0';
              state         <= st1_save;
            end if;
        end case;
      end if;
    end if;
  end process;

end architecture Behavioral;

