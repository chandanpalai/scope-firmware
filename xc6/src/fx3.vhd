---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : fx3.vhd
--
-- Abstract    : Implements communication to an FX3 via the slave fifo
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity fx3 is
---------------------------------------------------------------------------
port
(
  sys_rst : in std_logic;
  clk     : in std_logic;

  --FX3 interface
  slcs_n  : out std_logic;
  slwr_n  : out std_logic;
  sloe_n  : out std_logic;
  slrd_n  : out std_logic;
  flaga   : in std_logic;
  flagb   : in std_logic;
  pktend_n: out std_logic;
  fifoadr : out std_logic_vector(1 downto 0);
  dq      : inout std_logic_vector(31 downto 0);

  --internal interface
  adcdata      : in std_logic_vector(63 downto 0);
  adcdataclk   : out std_logic;
  adcdatafull  : in std_logic;
  adcdataempty : in std_logic;

  cfgin    : in std_logic_vector(15 downto 0);
  cfginclk : in std_logic;

  cfgout    : out std_logic_vector(15 downto 0);
  cfgoutclk : out std_logic
);
end fx3;


---------------------------------------------------------------------------
architecture Behavioral of fx3 is
---------------------------------------------------------------------------

  component cfgbuf
    PORT (
           rst    : in STD_LOGIC;
           wr_clk : in STD_LOGIC;
           rd_clk : in STD_LOGIC;
           din    : in STD_LOGIC_VECTOR(15 DOWNTO 0);
           wr_en  : in STD_LOGIC;
           rd_en  : in STD_LOGIC;
           dout   : out STD_LOGIC_VECTOR(15 DOWNTO 0);
           full   : out STD_LOGIC;
           empty  : out STD_LOGIC
         );
  end component cfgbuf;

  constant WR_ADC : std_logic := '0';
  constant WR_CFG : std_logic := '1';

  constant OUTEPCFG: std_logic_vector(1 downto 0) := "00"; --EP2
  constant INEPCFG : std_logic_vector(1 downto 0) := "01"; --EP4
  constant INEPADC : std_logic_vector(1 downto 0) := "01"; --EP6

  --FSM
  type state_type is (st0_default,
    st1_r_assertfifo, st2_r_sloe, st3_r_sample, st4_r_deassert, st5_r_next,
    st1_w_assertfifo, st2_w_data, st3_w_pulse, st4_w_next);
  signal state : state_type;
  --Keep track for clearing a packet when left idle
  signal byte_count     : unsigned(9 downto 0);
  signal inactive_count : unsigned(5 downto 0);

  signal writewhich : std_logic := WR_ADC;

  signal cfgbuf_empty, cfgbuf_full : std_logic;
  signal cfgbuf_dout : std_logic_vector(15 downto 0);
  signal cfgbuf_rdclk : std_logic;

begin
  Inst_cfgbuf : cfgbuf
  port map (
             rst    => sys_rst,
             wr_clk => cfginclk,
             rd_clk => cfgbuf_rdclk,
             din    => cfgin,
             wr_en  => '1',
             rd_en  => '1',
             dout   => cfgbuf_dout,
             full   => cfgbuf_full,
             empty  => cfgbuf_empty
             );

  fsm : process(clk, sys_rst)
  begin
    if clk'event and clk = '1' then
      if sys_rst = '1' then
        state <= st0_default;
        inactive_count <= TO_UNSIGNED(0, 6);
        byte_count <= TO_UNSIGNED(0, 10);
      else
        case state is
          when st0_default =>
            slcs_n  <= '1';
            slwr_n  <= '1';
            sloe_n  <= '1';
            slrd_n  <= '1';
            fifoadr <= "00";
            dq      <= (others => 'Z');
            if inactive_count = 63 and (not (byte_count = 0)) then
              pktend_n <= '0';
              inactive_count <= TO_UNSIGNED(0, 6);
              byte_count <= TO_UNSIGNED(0, 10);
            else
              pktend_n <= '1';
              inactive_count <= inactive_count + 1;
            end if;

            if flaga = '0' then
              state <= st1_r_assertfifo;
            else
              if cfgbuf_empty = '0' then
                writewhich <= WR_CFG;
              else
                writewhich <= WR_ADC;
              end if;
              state <= st1_w_assertfifo;
            end if;

            --read states
          when st1_r_assertfifo =>
            slcs_n <= '0';
            fifoadr <= OUTEPCFG;
            state <= st2_r_sloe;
          when st2_r_sloe =>
            sloe_n <= '0';
            state <= st3_r_sample;
          when st3_r_sample =>
            slrd_n <= '0';
            cfgout <= dq(23 downto 8);
            cfgoutclk <= '1';
            state <= st4_r_deassert;
          when st4_r_deassert =>
            slrd_n <= '1';
          when st5_r_next =>
            cfgoutclk <= '0';
            if flaga = '1' then
              state <= st2_r_sloe;
            else
              state <= st0_default;
            end if;

            --write states
          when st1_w_assertfifo =>
            inactive_count <= TO_UNSIGNED(0, 6);
            slcs_n         <= '0';
            if writewhich = WR_ADC then
              fifoadr <= inEPADC;
            else
              fifoadr <= inEPCFG;
            end if;
            if flagb = '1' then
              state <= st2_w_data;
            end if;
          when st2_w_data =>
            pktend_n <= '1';
            slwr_n   <= '0';
            if writewhich = WR_ADC then
              dq <= adcdata(31 downto 0);
            else
              dq(7 downto 0) <= x"AA";
              dq(23 downto 8) <= cfgbuf_dout;
              dq(31 downto 24) <= x"0F";
            end if;
            byte_count <= byte_count + 1;
            state <= st3_w_pulse;
          when st3_w_pulse =>
            slwr_n <= '1';
            state <= st4_w_next;
          when st4_w_next =>
            if flaga = '0' then
              dq <= (others => 'Z');
              pktend_n <= '0';
              byte_count <= TO_UNSIGNED(0, 10);
              inactive_count <= TO_UNSIGNED(0, 6);
              state <= st2_w_data;
            else
              state <= st0_default;
            end if;
        end case;
      end if;
    end if;
  end process;

end architecture Behavioral;

