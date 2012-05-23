---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : memwrapper_tb.vhd
--
-- Abstract    : Test bench for the memwrapper module
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity memwrapper_tb is
---------------------------------------------------------------------------
generic (
          NUM_DQ_PINS        : integer := 16;
          MASK_SIZE          : integer := 16;
          MEM_ADDR_WIDTH     : integer := 14;
          MEM_BANKADDR_WIDTH : integer := 3;
          DATA_PORT_SIZE     : integer := 128
        );
end memwrapper_tb;


---------------------------------------------------------------------------
architecture Behavioral of memwrapper_tb is
---------------------------------------------------------------------------
  component memwrapper
    generic (
              NUM_DQ_PINS        : integer := 16;
              MASK_SIZE          : integer := 16;
              MEM_ADDR_WIDTH     : integer := 14;
              MEM_BANKADDR_WIDTH : integer := 3;
              DATA_PORT_SIZE     : integer := 128;
              SIMULATION         : string  := "TRUE"
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

  component ddr3_model_c3
    port (
           ck      : in    std_logic;
           ck_n    : in    std_logic;
           cke     : in    std_logic;
           cs_n    : in    std_logic;
           ras_n   : in    std_logic;
           cas_n   : in    std_logic;
           we_n    : in    std_logic;
           dm_tdqs : inout std_logic_vector((NUM_DQ_PINS/16) downto 0);
           ba      : in    std_logic_vector((MEM_BANKADDR_WIDTH - 1) downto 0);
           addr    : in    std_logic_vector((MEM_ADDR_WIDTH  - 1) downto 0);
           dq      : inout std_logic_vector((NUM_DQ_PINS - 1) downto 0);
           dqs     : inout std_logic_vector((NUM_DQ_PINS/16) downto 0);
           dqs_n   : inout std_logic_vector((NUM_DQ_PINS/16) downto 0);
           tdqs_n  : out   std_logic_vector((NUM_DQ_PINS/16) downto 0);
           odt     : in    std_logic;
           rst_n   : in    std_logic
           );
  end component ddr3_model_c3;

  signal fsmclk, ddrclk, adcclk, fx3clk, reset : std_logic;

  signal mem_dram_dq      : std_logic_vector(NUM_DQ_PINS-1 downto 0);
  signal mem_dram_a       : std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
  signal mem_dram_ba      : std_logic_vector(MEM_BANKADDR_WIDTH-1 downto 0);
  signal mem_dram_ras_n   : std_logic;
  signal mem_dram_cas_n   : std_logic;
  signal mem_dram_we_n    : std_logic;
  signal mem_dram_odt     : std_logic;
  signal mem_dram_reset_n : std_logic;
  signal mem_dram_cke     : std_logic;
  signal mem_dram_dm      : std_logic;
  signal mem_dram_udqs_p  : std_logic;
  signal mem_dram_udqs_n  : std_logic;
  signal mem_dram_udm     : std_logic;
  signal mem_dram_dqs_p   : std_logic;
  signal mem_dram_dqs_n   : std_logic;
  signal mem_dram_ck_p    : std_logic;
  signal mem_dram_ck_n    : std_logic;
  signal mem_rzq, mem_zio : std_logic;
  --Annoying interface signals for model (not real hardware)
  signal mem_dram_dqs_p_vector  : std_logic_vector(1 downto 0);
  signal mem_dram_dqs_n_vector  : std_logic_vector(1 downto 0);
  signal mem_dram_udqs_p_vector : std_logic_vector(1 downto 0);
  signal mem_dram_udqs_n_vector : std_logic_vector(1 downto 0);
  signal mem_dram_dm_vector     : std_logic_vector(1 downto 0);
  signal mem_cmd                : std_logic_vector(2 downto 0);
  signal mem_en1, mem_en2       : std_logic;

  signal adc_wr_en, adc_rd_en      : std_logic := '0';
  signal adc_wr_full, adc_rd_empty : std_logic;
  signal adc_wr_data, adc_rd_data  : std_logic_vector(63 downto 0);

begin

  -----------------------------------------------------------------------------
  --Annoying interface signals
  zio_pulldown : PULLDOWN port map (O => mem_zio);
  rzq_pulldown : PULLDOWN port map (O => mem_rzq);

  mem_cmd <= (mem_dram_ras_n & mem_dram_cas_n & mem_dram_we_n);

  process(mem_dram_ck_p)
  begin
    if mem_dram_ck_p'event and mem_dram_ck_p = '1' then
      if reset = '1' then
        mem_en1 <= '0';
        mem_en2 <= '0';
      elsif mem_cmd = "100" then
        mem_en2 <= '0';
      elsif mem_cmd = "101" then
        mem_en2 <= '1';
      else
        mem_en2 <= mem_en2;
      end if;
      mem_en1 <= mem_en2;
    end if;
  end process;

  mem_dram_dqs_p_vector(1 downto 0) <= (mem_dram_udqs_p & mem_dram_dqs_p)
                                        when mem_en2 = '0' and mem_en1 = '0'
                                      else
                                        "ZZ";
  mem_dram_dqs_n_vector(1 downto 0) <= (mem_dram_udqs_n & mem_dram_dqs_n)
                                        when mem_en2 = '0' and mem_en1 = '0'
                                      else
                                        "ZZ";

  mem_dram_dqs_p  <= mem_dram_dqs_p_vector(0)
                     when mem_en1 = '1' else 'Z';
  mem_dram_udqs_p <= mem_dram_dqs_p_vector(1)
                     when mem_en1 = '1' else 'Z';
  mem_dram_dqs_n  <= mem_dram_dqs_n_vector(0)
                     when mem_en1 = '1' else 'Z';
  mem_dram_udqs_n <= mem_dram_dqs_n_vector(0)
                     when mem_en1 = '1' else 'Z';

  mem_dram_dm_vector <= (mem_dram_udm & mem_dram_dm);
  -----------------------------------------------------------------------------


  Inst_memwrapper : memwrapper
  generic map (
                NUM_DQ_PINS        => NUM_DQ_PINS,
                MASK_SIZE          => MASK_SIZE,
                MEM_ADDR_WIDTH     => MEM_ADDR_WIDTH,
                MEM_BANKADDR_WIDTH => MEM_BANKADDR_WIDTH,
                DATA_PORT_SIZE     => DATA_PORT_SIZE,
                SIMULATION         => "TRUE"
                )
  port map (
             sys_rst           => reset,
             clk               => fsmclk,
             ddrclk            => ddrclk,
             mcb3_dram_dq      => mem_dram_dq,
             mcb3_dram_a       => mem_dram_a,
             mcb3_dram_ba      => mem_dram_ba,
             mcb3_dram_ras_n   => mem_dram_ras_n,
             mcb3_dram_cas_n   => mem_dram_cas_n,
             mcb3_dram_we_n    => mem_dram_we_n,
             mcb3_dram_odt     => mem_dram_odt,
             mcb3_dram_reset_n => mem_dram_reset_n,
             mcb3_dram_cke     => mem_dram_cke,
             mcb3_dram_dm      => mem_dram_dm,
             mcb3_dram_udqs_p  => mem_dram_udqs_p,
             mcb3_dram_udqs_n  => mem_dram_udqs_n,
             mcb3_rzq          => mem_rzq,
             mcb3_zio          => mem_zio,
             mcb3_dram_udm     => mem_dram_udm,
             mcb3_dram_dqs_p   => mem_dram_dqs_p,
             mcb3_dram_dqs_n   => mem_dram_dqs_n,
             mcb3_dram_ck_p    => mem_dram_ck_p,
             mcb3_dram_ck_n    => mem_dram_ck_n,
             adc_wr_clk        => adcclk,
             adc_wr_en         => adc_wr_en,
             adc_wr_data       => adc_wr_data,
             adc_wr_full       => adc_wr_full,
             adc_rd_clk        => fx3clk,
             adc_rd_en         => adc_rd_en,
             adc_rd_data       => adc_rd_data,
             adc_rd_empty      => adc_rd_empty
             );

  Inst_ddr3_model_c3 : ddr3_model_c3
  port map (
             ck      => mem_dram_ck_p,
             ck_n    => mem_dram_ck_n,
             cke     => mem_dram_cke,
             cs_n    => '0',
             ras_n   => mem_dram_ras_n,
             cas_n   => mem_dram_cas_n,
             we_n    => mem_dram_we_n,
             dm_tdqs => mem_dram_dm_vector,
             ba      => mem_dram_ba,
             addr    => mem_dram_a,
             dq      => mem_dram_dq,
             dqs     => mem_dram_dqs_p_vector,
             dqs_n   => mem_dram_dqs_n_vector,
             tdqs_n  => open,
             odt     => mem_dram_odt,
             rst_n   => mem_dram_reset_n
             );

  clk_adc : process
  begin
    adcclk <= '1';
    wait for 4 ns;
    adcclk <= '0';
    wait for 4 ns;
  end process;

  clk_fx3 : process
  begin
    fx3clk <= '1';
    wait for 5 ns;
    fx3clk <= '0';
    wait for 5 ns;
  end process;

  clk_fsm : process
  begin
    fsmclk <= '1';
    wait for 2.5 ns;
    fsmclk <= '0';
    wait for 2.5 ns;
  end process;

  clk_ddr : process
  begin
    ddrclk <= '1';
    wait for 1.25 ns;
    ddrclk <= '0';
    wait for 1.25 ns;
  end process;

  ctrl : process
  begin
    reset <= '0';
    wait for 100 ns;
    reset <= '1';
    wait for 100 ns;
    reset <= '0';

    wait for 40 us;

    wait until adcclk = '1';
    adc_wr_en <= '1';
    for i in 1 to 1000 loop
      if adc_wr_full = '0' then
        adc_wr_data <= std_logic_vector(to_unsigned(i, 64));
      else
        adc_wr_en <= '0';
        wait until adc_wr_full = '0';
      end if;
      wait until adcclk = '0';
      wait until adcclk = '1';
    end loop;
    adc_wr_en <= '0';

    wait;
  end process;

  fx3 : process
  begin
    wait until adc_rd_empty = '1';
    wait until fx3clk = '0';
    adc_rd_en <= '0';
    wait until adc_rd_empty = '0';
    wait until fx3clk = '0';
    adc_rd_en <= '1';
  end process;

end architecture Behavioral;

