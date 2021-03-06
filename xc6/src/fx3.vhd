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
  clk     : in std_logic; --must be the 2xfx3 frequency (200MHz)

  --FX3 interface
  slcs_n  : out std_logic;
  slwr_n  : out std_logic;
  sloe_n  : out std_logic;
  slrd_n  : out std_logic;
  flaga   : in std_logic;  --full flag for the current thread (0=full)
  flagb   : in std_logic;  --empty flag for thread 1 (0=empty) used te get cfg data
  pktend_n: out std_logic;
  fifoadr : out std_logic_vector(1 downto 0);
  dq      : inout std_logic_vector(31 downto 0);

  --internal interface
  adcdata      : in std_logic_vector(63 downto 0);
  adcdataclk   : in std_logic;
  adcdataen    : in std_logic;
  adcdatafull  : out std_logic;
  adcdataempty : out std_logic;

  cfgin     : in std_logic_vector(15 downto 0);
  cfginen   : in std_logic;
  cfginclk  : in std_logic;
  cfgout    : out std_logic_vector(15 downto 0);
  cfgoutclk : out std_logic
);
end fx3;


---------------------------------------------------------------------------
architecture Behavioral of fx3 is
---------------------------------------------------------------------------

  component cfgfifo16
    port (
           rst    : in std_logic;
           wr_clk : in std_logic;
           rd_clk : in std_logic;
           din    : in std_logic_vector(15 downto 0);
           wr_en  : in std_logic;
           rd_en  : in std_logic;
           dout   : out std_logic_vector(15 downto 0);
           full   : out std_logic;
           empty  : out std_logic
         );
  end component cfgfifo16;

  component adcpktfifo
    port (
           rst    : in std_logic;
           wr_clk : in std_logic;
           rd_clk : in std_logic;
           din    : in std_logic_vector(63 downto 0);
           wr_en  : in std_logic;
           rd_en  : in std_logic;
           dout   : out std_logic_vector(31 downto 0);
           full   : out std_logic;
           empty  : out std_logic
         );
  end component adcpktfifo;

  constant WR_ADC : std_logic := '0';
  constant WR_CFG : std_logic := '1';

  constant OUTEPCFG: std_logic_vector(1 downto 0) := "00"; --EP2
  constant INEPCFG : std_logic_vector(1 downto 0) := "01"; --EP4
  constant INEPADC : std_logic_vector(1 downto 0) := "10"; --EP6

  --FSM
  type state_type is (st0_default,
    st1_r_assertfifo, st2_r_sloe, st3_r_sample, st4_r_deassert,
    st1_w_assertfifo, st2_w_data, st3_w_pulse);
  signal state : state_type;
  --Keep track for clearing a packet when left idle
  signal byte_count     : unsigned(9 downto 0);
  signal inactive_count : unsigned(5 downto 0);

  signal writewhich : std_logic := WR_ADC;

  signal cfgbuf_empty : std_logic;
  signal cfgbuf_dout  : std_logic_vector(15 downto 0);
  signal cfgbuf_rden  : std_logic;

  signal adcbuf_empty : std_logic;
  signal adcbuf_dout  : std_logic_vector(31 downto 0);
  signal adcbuf_rden  : std_logic;

  signal flagdelay    : natural range 0 to 5 := 0;

begin

  adcdataempty <= adcbuf_empty;

  Inst_cfgfifo16 : cfgfifo16
  port map (
             rst    => sys_rst,
             wr_clk => cfginclk,
             rd_clk => clk,
             din    => cfgin,
             wr_en  => cfginen,
             rd_en  => cfgbuf_rden,
             dout   => cfgbuf_dout,
             empty  => cfgbuf_empty
             );

  Inst_adcpktfifo : adcpktfifo
  port map (
             wr_clk        => adcdataclk,
             rd_clk        => clk,
             rst           => sys_rst,
             din           => adcdata,
             wr_en         => adcdataen,
             rd_en         => adcbuf_rden,
             dout          => adcbuf_dout,
             empty         => adcbuf_empty,
             full          => adcdatafull
             );


  fsm : process(clk, sys_rst)
  begin
    if clk'event and clk = '1' then
      if sys_rst = '1' then
        state          <= st0_default;
        inactive_count <= TO_UNSIGNED(0, 6);
        byte_count     <= TO_UNSIGNED(0, 10);
        adcbuf_rden    <= '0';
        cfgbuf_rden    <= '0';
        flagdelay      <= 0;
      else
        case state is
          when st0_default =>
            slcs_n      <= '1';
            slwr_n      <= '1';
            sloe_n      <= '1';
            slrd_n      <= '1';
            fifoadr     <= "00";
            dq          <= (others => 'Z');
            adcbuf_rden <= '0';
            cfgbuf_rden <= '0';
            flagdelay   <= 0;

            if inactive_count = 63 and (not (byte_count = 0)) then
              pktend_n       <= '0';
              inactive_count <= TO_UNSIGNED(0, 6);
              byte_count     <= TO_UNSIGNED(0, 10);
            else
              pktend_n       <= '1';
              inactive_count <= inactive_count + 1;
            end if;

            if flagb = '1' then
              --Get config data from PC
              state <= st1_r_assertfifo;
            else
              --Handle any writes pending
              if cfgbuf_empty = '0' then
                writewhich <= WR_CFG;
                state      <= st1_w_assertfifo;
              elsif adcbuf_empty = '0' then
                writewhich <= WR_ADC;
                state      <= st1_w_assertfifo;
              else
                writewhich <= WR_ADC;
              end if;
            end if;

            --read states
          when st1_r_assertfifo =>
            slcs_n  <= '0';
            fifoadr <= OUTEPCFG;
            state   <= st2_r_sloe;
          when st2_r_sloe =>
            sloe_n <= '0';
            state  <= st3_r_sample;
          when st3_r_sample =>
            slrd_n    <= '0';
            cfgout    <= dq(23 downto 8);
            --TODO: check checksums and drop packet
            cfgoutclk <= '1';
            state     <= st4_r_deassert;
          when st4_r_deassert =>
            cfgoutclk <= '0';
            if flagb = '1' then
              state <= st3_r_sample;
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

            --wait for current-thread flag to update, then check
            if flagdelay = 5 then
              if flaga = '1' then
                state <= st2_w_data;
              else
                state <= st0_default;
              end if;
            else
              flagdelay <= flagdelay + 1;
            end if;
          when st2_w_data =>
            pktend_n <= '1';
            slwr_n   <= '0';
            if writewhich = WR_ADC then
              dq          <= adcbuf_dout;
              adcbuf_rden <= '1';
            else
              dq(7 downto 0)   <= x"AA";
              dq(23 downto 8)  <= cfgbuf_dout;
              dq(31 downto 24) <= x"0F";
              cfgbuf_rden      <= '1';
            end if;
            byte_count <= byte_count + 1;
            state <= st3_w_pulse;
          when st3_w_pulse =>
            adcbuf_rden <= '0';
            cfgbuf_rden <= '0';
            if flaga = '0' or adcbuf_empty = '1' or flagb = '1'
                or (cfgbuf_empty = '0' and writewhich = WR_ADC)
                or (cfgbuf_empty = '1' and writewhich = WR_CFG) then
              --full so stop, or end of adc data, or we have a waiting cfg packet (in either direction)
              dq             <= (others => 'Z');
              slwr_n         <= '1';
              inactive_count <= TO_UNSIGNED(0, 6);
              byte_count     <= TO_UNSIGNED(0, 10);
              state          <= st0_default;
            else
              --not full.
              state          <= st2_w_data;
              inactive_count <= TO_UNSIGNED(0, 6);
            end if;
        end case;
      end if;
    end if;
  end process;

end architecture Behavioral;

