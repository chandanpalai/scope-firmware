--------------------------------------------------------------------------------
-- Engineer:       Ali Lown
--
-- Create Date:    21:39:09 06/22/2011
-- Module Name:    fx2ctrl - Behavioral
-- Project Name:   USB Digital Oscilloscope
-- Target Devices: xc3s50a(n)
-- Description:    Handles communication to the fx2ctrl's slave FIFOs.
--                 Refer to the fx2ctrl and pc source code for the other end.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fx2ctrl is
  Port (
         RESET : in STD_LOGIC;
         CLK : in  STD_LOGIC;

         FLAGA : in  STD_LOGIC; --!EP4EF
         FLAGB : in  STD_LOGIC; --!EP8FF
         FLAGC : in  STD_LOGIC; --!EP6FF
         FD : inout  STD_LOGIC_VECTOR (15 downto 0);
         SLOE : out  STD_LOGIC;
         SLRD : out  STD_LOGIC;
         SLWR : out  STD_LOGIC;
         FIFOADR : out  STD_LOGIC_VECTOR (1 downto 0);
         PKTEND : out  STD_LOGIC;

         ADCDATA : in  STD_LOGIC_VECTOR (15 downto 0);
         ADCDATACLK : in  STD_LOGIC;

         PKTBUS : out  STD_LOGIC_VECTOR (15 downto 0);
         PKTBUSCLK : out  STD_LOGIC;

         PKTIN : in STD_LOGIC_VECTOR (15 downto 0);
         PKTINCLK : in STD_LOGIC
       );
end fx2ctrl;

architecture Behavioral of fx2ctrl is

  constant MAGIC : STD_LOGIC_VECTOR(7 downto 0) := x"AF";
  constant DEST_HOST : STD_LOGIC_VECTOR(7 downto 0) := x"00";

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
  st1_w_assertfifo, st2_w_data, st2_w_data_cfg2, st3_w_pulse_adc,
  st3_w_pulse_cfg, st4_w_next);
  signal state : state_type;
  signal out_signals : STD_LOGIC_VECTOR(2 downto 0);
  signal writewhich : STD_LOGIC := WR_ADC;
  --Max value 511, since overflow = packet
  signal byte_count : unsigned(8 downto 0);
  signal inactive_count : unsigned(5 downto 0);


  --FIFO Buffer
  COMPONENT fx2buffer
    PORT (
           rst : IN STD_LOGIC;
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

  COMPONENT pkt16fifo
    PORT(
          DATAIN : IN std_logic_vector(15 downto 0);
          WRCLK : IN std_logic;
          RDCLK : IN std_logic;
          RESET : IN std_logic;
          DATAOUT : OUT std_logic_vector(15 downto 0);
          FULL : OUT std_logic;
          EMPTY : OUT std_logic
        );
  END COMPONENT;

  signal adc_dout : STD_LOGIC_VECTOR(15 downto 0);
  signal adc_rdclk, adc_empty, adc_full : STD_LOGIC;
  signal cfg_dout : STD_LOGIC_VECTOR(15 downto 0);
  signal cfg_rdclk, cfg_empty, cfg_full : STD_LOGIC;
begin
  --Add the FX2 buffers
  inst_adcbuffer : fx2buffer
  PORT MAP (
             rst => RESET,
             wr_clk => ADCDATACLK,
             rd_clk => CLK,
             din => ADCDATA,
             wr_en => '1',
             rd_en => adc_rdclk,
             dout => adc_dout,
             full => adc_full,
             empty => adc_empty
           );
  inst_pktbuffer : pkt16fifo
  PORT MAP (
             RESET => RESET,
             DATAIN => PKTIN,
             WRCLK => PKTINCLK,
             DATAOUT => cfg_dout,
             RDCLK => cfg_rdclk,
             FULL => cfg_full,
             EMPTY => cfg_empty
           );

  --State machine for FX2 communications
  FX2 : process(RESET, state, CLK, FD, writewhich, out_signals, FLAGA, FLAGB,
                FLAGC, adc_empty, cfg_empty)
  begin
    if RESET = '1' then
        inactive_count <= TO_UNSIGNED(0, 6);
        byte_count <= TO_UNSIGNED(0,9);
        state <= st0_default;
    else
      if CLK = '1' and CLK'event then
        case state is
          when st0_default =>
            FIFOADR <= "00";
            out_signals <= FIFO_NOP;
            FD <= "ZZZZZZZZZZZZZZZZ";
            PKTBUS <= x"0000";
            PKTBUSCLK <= '0';

            if inactive_count = 63 and (not (byte_count = 0)) then
              PKTEND <= '0';
              inactive_count <= TO_UNSIGNED(0, 6);
              byte_count <= TO_UNSIGNED(0,9);
            else
              PKTEND <= '1';
              inactive_count <= inactive_count + 1;
            end if;

            adc_rdclk <= '0';
            cfg_rdclk <= '0';

            if FLAGA = '1' then
              state <= st1_r_assertfifo;
            elsif cfg_empty = '0' then
              state <= st1_w_assertfifo;
              writewhich <= WR_CFG;
            elsif adc_empty = '0' then
              state <= st1_w_assertfifo;
              writewhich <= WR_ADC;
            end if;

          --read states
          when st1_r_assertfifo =>
            FIFOADR <= OUTEP;
            state <= st2_r_sloe;
          when st2_r_sloe =>
            out_signals <= FIFO_OE;
            state <= st3_r_sample;
          when st3_r_sample =>
            out_signals <= FIFO_READ;
            PKTBUS <= FD;
            PKTBUSCLK <= '1';
            state <= st4_r_deassert;
          when st4_r_deassert =>
            out_signals <= FIFO_NOP;
            state <= st5_r_next;
          when st5_r_next =>
            PKTBUSCLK <= '0';
            if FLAGA = '1' then
              state <= st2_r_sloe;
            else
              state <= st0_default;
            end if;

          --write states
          when st1_w_assertfifo =>
            inactive_count <= TO_UNSIGNED(0, 6);
            if writewhich = WR_ADC then
              if FLAGC = '1' then
                FIFOADR <= INEPADC;
                state <= st2_w_data;
              end if;
            else --writewhich = WR_CFG
              if FLAGB = '1' then
                FIFOADR <= INEPCFG;
                state <= st2_w_data;
              end if;
            end if;
          when st2_w_data =>
            PKTEND <= '1';
            if writewhich = WR_ADC then
              FD <= adc_dout;
              adc_rdclk <= '1';
              state <= st3_w_pulse_adc;
            else --writewhich = WR_CFG
              FD(7 downto 0) <= MAGIC;
              FD(15 downto 8) <= DEST_HOST;
              cfg_rdclk <= '1';
              state <= st3_w_pulse_cfg;
            end if;
            out_signals <= FIFO_WRITE;
            byte_count <= byte_count + 1;
          when st2_w_data_cfg2 =>
            FD <= cfg_dout;
            cfg_rdclk <= '0';
            out_signals <= FIFO_WRITE;
            byte_count <= byte_count + 1;
            state <= st3_w_pulse_adc;
          when st3_w_pulse_adc =>
            out_signals <= FIFO_NOP;
            adc_rdclk <= '0';
            state <= st4_w_next;
          when st3_w_pulse_cfg =>
            out_signals <= FIFO_NOP;
            state <= st2_w_data_cfg2;
          when st4_w_next =>
            if FLAGA = '1' then
              FD <= "ZZZZZZZZZZZZZZZZ";
              PKTEND <= '0';
              byte_count <= TO_UNSIGNED(0,9);
              inactive_count <= TO_UNSIGNED(0, 6);
              state <= st1_r_assertfifo;
            else
              if writewhich = WR_ADC then
                --Finish ADC buffer
                if adc_empty = '0' then
                  state <= st2_w_data;
                else
                  state <= st0_default;
                end if;
              else --writewhich = WR_CFG
                --Finish CFG packet
                if cfg_empty = '0' then
                  state <= st2_w_data;
                else
                  state <= st0_default;
                end if;
              end if;
            end if;
        end case;
      end if;
    end if;

    SLOE <= out_signals(0);
    SLRD <= out_signals(1);
    SLWR <= out_signals(2);
  end process;
end Behavioral;
