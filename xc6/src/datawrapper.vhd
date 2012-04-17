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
  c3_p0_cmd_clk       : out std_logic;
  c3_p0_cmd_en        : out std_logic;
  c3_p0_cmd_instr     : out std_logic_vector(2 downto 0);
  c3_p0_cmd_bl        : out std_logic_vector(5 downto 0);
  c3_p0_cmd_byte_addr : out std_logic_vector(29 downto 0);
  c3_p0_cmd_empty     : in std_logic;
  c3_p0_cmd_full      : in std_logic;
  c3_p0_wr_clk        : out std_logic;
  c3_p0_wr_en         : out std_logic;
  c3_p0_wr_mask       : out std_logic_vector(15 downto 0);
  c3_p0_wr_data       : out std_logic_vector(127 downto 0);
  c3_p0_wr_full       : in std_logic;
  c3_p0_wr_empty      : in std_logic;
  c3_p0_wr_count      : in std_logic_vector(6 downto 0);
  c3_p0_wr_underrun   : in std_logic;
  c3_p0_wr_error      : in std_logic;
  c3_p0_rd_clk        : out std_logic;
  c3_p0_rd_en         : out std_logic;
  c3_p0_rd_data       : in std_logic_vector(127 downto 0);
  c3_p0_rd_full       : in std_logic;
  c3_p0_rd_empty      : in std_logic;
  c3_p0_rd_count      : in std_logic_vector(6 downto 0);
  c3_p0_rd_overflow   : in std_logic;
  c3_p0_rd_error      : in std_logic;

  --FX3 interface
  fx3_adcdata    : out std_logic_vector(63 downto 0);
  fx3_adcdataclk : out std_logic;
  fx3_adcdataen  : out std_logic
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

  signal dcm_fb : std_logic;
  signal slowclk : std_logic;

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
             CLKIN    => fsmclk,
             DSSEN    => open,
             PSCLK    => open,
             PSEN     => open,
             PSINCDEC => open,
             RST      => sys_rst
             );

  --Tie pins low as required by ug388 pg. 51
  c3_p0_cmd_byte_addr(3 downto 0) <= "0000";

  --No need for 3 different clocks!
  c3_p0_cmd_clk <= clk;
  c3_p0_wr_clk  <= clk;
  c3_p0_rd_clk  <= clk;

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
            if adc_datard_rd_count < "100010000000000" then
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
          when st2_restore =>
        end case;
      end if;
    end if;
  end process;

end architecture Behavioral;

