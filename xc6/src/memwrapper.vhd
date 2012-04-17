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
port
(
  sys_rst : in std_logic;
  clk     : in std_logic;

  --MCB interface
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

  --ADC FIFO interface
  adc_wr_clk  : in std_logic;
  adc_wr_en   : in std_logic;
  adc_wr_data : in std_logic_vector(63 downto 0);
  adc_wr_full : out std_logic;

  adc_rd_clk   : in std_logic;
  adc_rd_en    : in std_logic;
  adc_rd_data  : out std_logic_vector(63 downto 0);
  adc_rd_empty : out std_logic;

);
end memwrapper;


---------------------------------------------------------------------------
architecture Behavioral of memwrapper is
---------------------------------------------------------------------------

  component memfifo
    port (
           rst    : in std_logic;
           wr_clk : in std_logic;
           rd_clk : in std_logic;
           din    : in std_logic_vector(63 downto 0);
           wr_en  : in std_logic;
           rd_en  : in std_logic;
           dout   : out std_logic_vector(127 downto 0);
           full   : out std_logic;
           empty  : out std_logic
         );
  end component memfifo;

  signal adc_wrbuf_clk, adc_rdbuf_clk     : std_logic;
  signal adc_wrbuf_en, adc_rdbuf_en       : std_logic;
  signal adc_wrbuf_data, adc_rdbuf_data   : std_logic_vector(127 downto 0);
  signal adc_wrbuf_full, adc_rdbuf_full   : std_logic;
  signal adc_wrbuf_empty, adc_rdbuf_empty : std_logic;

  type state_type is (st0_default, st1_read, st1_write);
  signal state : state_type := st0_default;

begin

  Inst_adcwrbuf : memfifo
  port map (
             rst    => sys_rst,
             wr_clk => adc_wr_clk,
             rd_clk => adc_wrbuf_clk,
             din    => adc_wr_data,
             wr_en  => adc_wr_en,
             rd_en  => adc_wrbuf_en,
             dout   => adc_wrbuf_data,
             full   => adc_wrbuf_full,
             empty  => adc_wrbuf_empty
             );

  Inst_adcrdbuf : memfifo
  port map (
             rst    => sys_rst,
             wr_clk => adc_rdbuf_clk,
             rd_clk => adc_rd_clk,
             din    => adc_rdbuf_data,
             wr_en  => adc_rdbuf_en,
             rd_en  => adc_rd_en,
             dout   => adc_rd_data,
             full   => adc_rdbuf_full,
             empty  => adc_rdbuf_empty
             );

  ctrl : process(clk, sys_rst)
  begin
    if clk'event and clk = '1' then
      if sys_rst = '1' then
        state <= st0_default;
      else
        case state is
          when st0_default =>
            if adc_wrbuf_empty = '0' then
              state <= st1_write;
            elsif adc_rdbuf_empty = '0'
              state <= st1_read;
            end if;
          when st1_read =>
          when st1_write =>
        end case;
      end if;
    end if;
  end  process;

end architecture Behavioral;

