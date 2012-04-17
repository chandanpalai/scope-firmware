---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : memwrapper.vhd
--
-- Abstract    : Abstracts away the MIG into some FIFOs
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity memwrapper is
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
end memwrapper;


---------------------------------------------------------------------------
architecture Behavioral of memwrapper is
---------------------------------------------------------------------------

  component ddr3mem
    generic (
      C3_P0_MASK_SIZE      : integer := 16;
      C3_P0_DATA_PORT_SIZE : integer := 128;
      C3_MEMCLK_PERIOD     : integer := 2500;
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
      DEBUG_EN : integer := 1;
      -- # = 1, Enable debug signals/controls,
      --   = 0, Disable debug signals/controls.
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
          c3_sys_clk          : in  std_logic;
          c3_sys_rst_i        : in  std_logic;
          c3_calib_done       : out std_logic;
          c3_clk0             : out std_logic;
          c3_rst0             : out std_logic;
          mcb3_dram_dqs       : inout  std_logic;
          mcb3_dram_dqs_n     : inout  std_logic;
          mcb3_dram_ck        : out std_logic;
          mcb3_dram_ck_n      : out std_logic;
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
  end component ddr3mem;

  --64*256/128*128 sized
  component mem64to128fifo
    port (
           rst           : in std_logic;
           wr_clk        : in std_logic;
           rd_clk        : in std_logic;
           din           : in std_logic_vector(63 downto 0);
           wr_en         : in std_logic;
           rd_en         : in std_logic;
           dout          : out std_logic_vector(127 downto 0);
           full          : out std_logic;
           empty         : out std_logic;
           rd_data_count : out std_logic_vector(7 downto 0);
           wr_data_count : out std_logic_vector(8 downto 0)
         );
  end component mem64to128fifo;

  component mem128to64fifo
    port (
           rst           : in std_logic;
           wr_clk        : in std_logic;
           rd_clk        : in std_logic;
           din           : in std_logic_vector(127 downto 0);
           wr_en         : in std_logic;
           rd_en         : in std_logic;
           dout          : out std_logic_vector(63 downto 0);
           full          : out std_logic;
           empty         : out std_logic;
           rd_data_count : out std_logic_vector(8 downto 0);
           wr_data_count : out std_logic_vector(7 downto 0)
         );
  end component mem128to64fifo;

  constant CMD_WRITE    : std_logic_vector(2 downto 0) := "000";
  constant CMD_READ     : std_logic_vector(2 downto 0) := "001";
  constant CMD_WRITE_AP : std_logic_vector(2 downto 0) := "010";
  constant CMD_READ_AP  : std_logic_vector(2 downto 0) := "011";
  constant CMD_REFRESH  : std_logic_vector(2 downto 0) := "100";

  signal c3_calib_done       : std_logic;
  signal c3_clk0, c3_rst0    : std_logic;
  signal c3_p0_cmd_clk       : std_logic;
  signal c3_p0_cmd_en        : std_logic;
  signal c3_p0_cmd_instr     : std_logic_vector(2 downto 0);
  signal c3_p0_cmd_bl        : std_logic_vector(5 downto 0);
  signal c3_p0_cmd_byte_addr : std_logic_vector(29 downto 0);
  signal c3_p0_cmd_empty     : std_logic;
  signal c3_p0_cmd_full      : std_logic;
  signal c3_p0_wr_clk        : std_logic;
  signal c3_p0_wr_en         : std_logic;
  signal c3_p0_wr_full       : std_logic;
  signal c3_p0_wr_empty      : std_logic;
  signal c3_p0_wr_count      : std_logic_vector(6 downto 0);
  signal c3_p0_wr_underrun   : std_logic;
  signal c3_p0_wr_error      : std_logic;
  signal c3_p0_rd_clk        : std_logic;
  signal c3_p0_rd_en         : std_logic;
  signal c3_p0_rd_full       : std_logic;
  signal c3_p0_rd_empty      : std_logic;
  signal c3_p0_rd_count      : std_logic_vector(6 downto 0);
  signal c3_p0_rd_overflow   : std_logic;
  signal c3_p0_rd_error      : std_logic;

  signal c3_p0_wr_data : std_logic_vector(DATA_PORT_SIZE-1 downto 0);
  signal c3_p0_rd_data : std_logic_vector(DATA_PORT_SIZE-1 downto 0);
  signal c3_p0_wr_mask : std_logic_vector(MASK_SIZE-1 downto 0);


  signal adc_wrbuf_en, adc_rdbuf_en       : std_logic := '0';
  signal adc_wrbuf_data, adc_rdbuf_data   : std_logic_vector(127 downto 0);
  signal adc_wrbuf_full, adc_rdbuf_full   : std_logic;
  signal adc_wrbuf_empty, adc_rdbuf_empty : std_logic;

  signal adc_wrbuf_wr_count, adc_rdbuf_wr_count : std_logic_vector(8 downto 0);
  signal adc_wrbuf_rd_count, adc_rdbuf_rd_count : std_logic_vector(7 downto 0);

  type state_type is (st0_default, st1_read, st1_write);
  signal state : state_type := st0_default;

  --Max location for a 2GBit/16bit wide module, appearing as a 128bit wide module
  signal wr_loc, rd_loc : natural range 0 to ((2*1024*1024*1024)/128)-1;

begin
  --Tie the address pins as required by ug388 pg. 51
  c3_p0_cmd_byte_addr(3 downto 0) <= "0000";

  --Keep the clocks synchronised to the FSM
  c3_p0_cmd_clk <= clk;
  c3_p0_wr_clk  <= clk;
  c3_p0_rd_clk  <= clk;

  Inst_ddr3mem : ddr3mem
  generic map (
                C3_P0_MASK_SIZE => MASK_SIZE,
                C3_P0_DATA_PORT_SIZE => DATA_PORT_SIZE,
                C3_MEMCLK_PERIOD => 2500,
                C3_RST_ACT_LOW => 0,
                DEBUG_EN => 1,
                C3_CALIB_SOFT_IP => "TRUE",
                C3_SIMULATION => "FALSE",
                C3_MEM_ADDR_ORDER => "ROW_BANK_COLUMN",
                C3_NUM_DQ_PINS => NUM_DQ_PINS,
                C3_MEM_ADDR_WIDTH => MEM_ADDR_WIDTH,
                C3_MEM_BANKADDR_WIDTH => MEM_BANKADDR_WIDTH
                )
  port map (
             mcb3_dram_dq => mcb3_dram_dq,
             mcb3_dram_a => mcb3_dram_a,
             mcb3_dram_ba => mcb3_dram_ba,
             mcb3_dram_ras_n => mcb3_dram_ras_n,
             mcb3_dram_cas_n => mcb3_dram_cas_n,
             mcb3_dram_we_n => mcb3_dram_we_n,
             mcb3_dram_odt => mcb3_dram_odt,
             mcb3_dram_cke => mcb3_dram_cke,
             mcb3_dram_dm => mcb3_dram_dm,
             mcb3_rzq => mcb3_rzq,
             mcb3_zio => mcb3_zio,
             mcb3_dram_dqs => mcb3_dram_dqs_p,
             mcb3_dram_dqs_n => mcb3_dram_dqs_n,
             mcb3_dram_ck => mcb3_dram_ck_p,
             mcb3_dram_ck_n => mcb3_dram_ck_n,
             mcb3_dram_udqs => mcb3_dram_udqs_p,
             mcb3_dram_udqs_n => mcb3_dram_udqs_n,
             mcb3_dram_udm => mcb3_dram_udm,
             mcb3_dram_reset_n => mcb3_dram_reset_n,

             c3_sys_clk => ddrclk,
             c3_sys_rst_i => sys_rst,
             c3_calib_done => c3_calib_done,
             c3_clk0 => c3_clk0,
             c3_rst0 => c3_rst0,

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


  Inst_adcwrbuf : mem64to128fifo
  port map (
             rst           => sys_rst,

             wr_clk        => adc_wr_clk,
             wr_en         => adc_wr_en,
             din           => adc_wr_data,

             rd_clk        => clk,
             rd_en         => adc_wrbuf_en,
             dout          => adc_wrbuf_data,

             full          => adc_wrbuf_full,
             empty         => adc_wrbuf_empty,
             rd_data_count => adc_wrbuf_rd_count,
             wr_data_count => adc_wrbuf_wr_count
             );

  Inst_adcrdbuf : mem128to64fifo
  port map (
             rst           => sys_rst,

             wr_clk        => clk,
             wr_en         => adc_rdbuf_en,
             din           => adc_rdbuf_data,

             rd_clk        => adc_rd_clk,
             rd_en         => adc_rd_en,
             dout          => adc_rd_data,

             full          => adc_rdbuf_full,
             empty         => adc_rdbuf_empty,
             rd_data_count => adc_rdbuf_rd_count,
             wr_data_count => adc_rdbuf_wr_count
             );

  ctrl : process(clk, sys_rst)
  begin
    if clk'event and clk = '1' then
      if sys_rst = '1' then
        state        <= st0_default;
        adc_wrbuf_en <= '0';
        adc_rdbuf_en <= '0';
        c3_p0_cmd_en <= '0';
        c3_p0_wr_en  <= '0';
        c3_p0_rd_en  <= '0';
        wr_loc       <= 0;
        rd_loc       <= 0;
      else
        case state is
          when st0_default =>
            adc_wrbuf_en <= '0';
            adc_rdbuf_en <= '0';
            c3_p0_cmd_en <= '0';
            c3_p0_wr_en  <= '0';
            c3_p0_rd_en  <= '0';

            if adc_wrbuf_empty = '0' and c3_p0_wr_full = '0' then
              state <= st1_write;
            elsif adc_rdbuf_full = '0' and c3_p0_rd_full = '0' then
              state <= st1_read;
            end if;

          when st1_read =>

          when st1_write =>
            if adc_wrbuf_empty = '1' then
              state <= st0_default;
            else
              if c3_p0_wr_full = '0' then
                adc_wrbuf_en  <= '1';
                c3_p0_wr_en   <= '1';
                c3_p0_wr_mask <= x"FFFF";
                c3_p0_wr_data <= adc_wrbuf_data;
              else
                adc_wrbuf_en <= '0';
                c3_p0_wr_en  <= '0';
                if c3_p0_cmd_empty = '0' then
                  c3_p0_cmd_en    <= '1';
                  c3_p0_cmd_instr <= CMD_WRITE;
                  c3_p0_cmd_byte_addr(29 downto 4) <= std_logic_vector(to_unsigned(wr_loc, 25));
                  c3_p0_cmd_bl    <= "111111";
                  state           <= st0_default;
                end if;
              end if;
            end if;

        end case;
      end if;
    end if;
  end  process;

end architecture Behavioral;

