--------------------------------------------------------------------------------
-- Engineer:       Ali Lown
--
-- Create Date:    21:39:09 06/22/2011
-- Module Name:    fx2 - Behavioral
-- Project Name:   USB Digital Oscilloscope
-- Target Devices: xc3s50a(n)
-- Description:    Handles communication to the fx2's slave FIFOs.
--                 Refer to the fx2 and pc source code for the other end.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fx2 is
  Port ( --to fpga internals
         ADCDATA : in  STD_LOGIC_VECTOR (15 downto 0);
         ADCDATACLK : in  STD_LOGIC;

         CFGDATA : in STD_LOGIC_VECTOR (15 downto 0);
         CFGDATACLK : in STD_LOGIC;

         OUTDATA : out  STD_LOGIC_VECTOR (15 downto 0);
         OUTDATACLK : out  STD_LOGIC;

         CLKIF : in  STD_LOGIC;
         RESET : in STD_LOGIC;

         --to IC
         FD : inout  STD_LOGIC_VECTOR (15 downto 0);

         FLAGA : in  STD_LOGIC; --!EP4EF
         FLAGB : in  STD_LOGIC; --!EP8FF
         FLAGC : in  STD_LOGIC; --!EP6FF

         SLOE : out  STD_LOGIC;
         SLRD : out  STD_LOGIC;
         SLWR : out  STD_LOGIC;

         FIFOADR : out  STD_LOGIC_VECTOR (1 downto 0);
         PKTEND : out  STD_LOGIC);
end fx2;

architecture Behavioral of fx2 is
  constant WR_ADC : STD_LOGIC := '0';
  constant WR_CFG : STD_LOGIC := '1';

  constant OUTEP : STD_LOGIC_VECTOR(1 downto 0) := "01";       --EP4
  constant INEPADC : STD_LOGIC_VECTOR(1 downto 0) := "10";     --EP6
  constant INEPCFG : STD_LOGIC_VECTOR(1 downto 0) := "11";     --EP8

  constant FIFO_OE : STD_LOGIC_VECTOR(2 downto 0) := "110";    --OE
  constant FIFO_READ : STD_LOGIC_VECTOR(2 downto 0) := "100";  --OE + RD
  constant FIFO_WRITE : STD_LOGIC_VECTOR(2 downto 0) := "011"; --WR
  constant FIFO_NOP : STD_LOGIC_VECTOR(2 downto 0) := "111";   --NOP

  --state machine
  type state_type is (st0_default,
  st1_r_assertfifo, st2_r_sloe, st3_r_sample, st4_r_deassert, st5_r_next,
  st1_w_assertfifo, st2_w_data, st3_w_pulse, st4_w_next);
  signal state, next_state : state_type;
  signal out_signals : STD_LOGIC_VECTOR(2 downto 0);
  signal writewhich : STD_LOGIC := WR_ADC;
  --Max value 511, since overflow = packet
  signal byte_count : unsigned(7 downto 0);


  --FIFO Buffer
  COMPONENT fx2buffer
    PORT (
           wr_clk : IN STD_LOGIC;
           rd_clk : IN STD_LOGIC;
           din : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
           wr_en : IN STD_LOGIC;
           rd_en : IN STD_LOGIC;
           dout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
           full : OUT STD_LOGIC;
           empty : OUT STD_LOGIC
         );
  END COMPONENT;

  signal adc_dout : STD_LOGIC_VECTOR(15 downto 0);
  signal adc_rden, adc_empty, adc_full : STD_LOGIC;
  signal cfg_dout : STD_LOGIC_VECTOR(15 downto 0);
  signal cfg_rden, cfg_empty, cfg_full : STD_LOGIC;
begin
  --Add the FX2 buffers
  inst_adcbuffer : fx2buffer
  PORT MAP (
             wr_clk => ADCDATACLK,
             rd_clk => CLKIF,
             din => ADCDATA,
             wr_en => '1',
             rd_en => adc_rden,
             dout => adc_dout,
             full => adc_full,
             empty => adc_empty
           );
  inst_cfgbuffer : fx2buffer
  PORT MAP (
             wr_clk => CFGDATACLK,
             rd_clk => CLKIF,
             din => CFGDATA,
             wr_en => '1',
             rd_en => cfg_rden,
             dout => cfg_dout,
             full => cfg_full,
             empty => cfg_empty
           );

  --State machine for FX2 communications
  SYNC_PROC : process(CLKIF,RESET)
  begin
    if RESET = '1' then
      state <= st0_default;
    else
      if CLKIF'event and CLKIF = '1' then
        state <= next_state;
      end if;
    end if;
  end process;

  OUTPUT_DECODE : process(state, CLKIF, FD, writewhich)
  begin
    if CLKIF = '1' and CLKIF'event then
      case state is
        when st0_default =>
          FIFOADR <= "00";
          out_signals <= FIFO_NOP;
          PKTEND <= '1';
          FD <= "ZZZZZZZZZZZZZZZZ";
          OUTDATA <= "0000000000000000";
          OUTDATACLK <= '0';

          byte_count <= TO_UNSIGNED(0,8);

          adc_rden <= '0';
          cfg_rden <= '0';

        --read states
        when st1_r_assertfifo =>
          FIFOADR <= OUTEP;
        when st2_r_sloe =>
          out_signals <= FIFO_OE;
        when st3_r_sample =>
          out_signals <= FIFO_READ;
        when st4_r_deassert =>
          out_signals <= FIFO_NOP;
          OUTDATA <= FD;
          OUTDATACLK <= '1';
        when st5_r_next =>
          OUTDATACLK <= '0';

        --write states
        when st1_w_assertfifo =>
          if writewhich = WR_ADC then
            FIFOADR <= INEPADC;
          else
            FIFOADR <= INEPCFG;
          end if;
        when st2_w_data =>
          if writewhich = WR_ADC then
            FD <= adc_dout;
            adc_rden <= '1';
          else --writewhich = WR_CFG
            FD <= cfg_dout;
            cfg_rden <= '1';
          end if;
          out_signals <= FIFO_WRITE;
          byte_count <= byte_count + 1;
        when st3_w_pulse =>
          out_signals <= FIFO_NOP;
          adc_rden <= '0';
          cfg_rden <= '0';
        when st4_w_next =>
          if (not (byte_count = 0)) then
            PKTEND <= '0';
          end if;
      end case;
    end if;

    SLOE <= out_signals(0);
    SLRD <= out_signals(1);
    SLWR <= out_signals(2);
  end process;

  NEXT_STATE_DECODE : process(state, FLAGA, FLAGB, FLAGC,
                              writewhich, adc_empty, cfg_empty)
  begin
    next_state <= state; --default involves no changing

    case state is
      when st0_default =>
        if FLAGA = '1' then --some data in EP4
          next_state <= st1_r_assertfifo;
        elsif cfg_empty = '0' then
          next_state <= st1_w_assertfifo;
          writewhich <= WR_CFG;
        elsif adc_empty = '0' then
          next_state <= st1_w_assertfifo;
          writewhich <= WR_ADC;
        end if;

      --read states
      when st1_r_assertfifo =>
        next_state <= st2_r_sloe;
      when st2_r_sloe =>
        next_state <= st3_r_sample;
      when st3_r_sample =>
        next_state <= st4_r_deassert;
      when st4_r_deassert =>
        next_state <= st5_r_next;
      when st5_r_next =>
        if FLAGA = '1' then
          next_state <= st2_r_sloe;
        else
          next_state <= st0_default;
        end if;

      --write states
      when st1_w_assertfifo =>
        next_state <= st2_w_data;
      when st2_w_data =>
        if writewhich = WR_ADC then
          if FLAGC = '1' then
            next_state <= st3_w_pulse;
          end if;
        else --writewhich = WR_CFG
          if FLAGB = '1' then
            next_state <= st3_w_pulse;
          end if;
        end if;
      when st3_w_pulse =>
        next_state <= st4_w_next;
      when st4_w_next =>
        if writewhich = WR_ADC then
          --Finish ADC buffer
          if adc_empty = '0' then
            next_state <= st2_w_data;
          else
            next_state <= st0_default;
          end if;
        else --writewhich = WR_CFG
          --Finish CFG packet
          if cfg_empty = '0' then
            next_state <= st2_w_data;
          else
            next_state <= st0_default;
          end if;
        end if;

        when others =>
      end case;
    end process;
  end Behavioral;
