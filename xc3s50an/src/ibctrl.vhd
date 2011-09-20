--------------------------------------------------------------------------------
-- Engineer:       Ali Lown
--
-- Create Date:    19:38:54 08/14/2011
-- Module Name:    ibctrl - Behavioral
-- Project Name:   USB Digital Oscilloscope
-- Target Devices: xc3s50a(n)
-- Description:    Handles communications to/from the input boards uC's.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ibctrl is
  Port ( RESET : in  STD_LOGIC;
         CLK : in  STD_LOGIC;
         BAUDCLK : in STD_LOGIC;

         RX : in STD_LOGIC;
         TX : out STD_LOGIC;

         PKTIN : out STD_LOGIC_VECTOR(15 downto 0);
         PKTINCLK : out STD_LOGIC;

         PKTOUT : in STD_LOGIC_VECTOR(15 downto 0);
         PKTOUTCLK : in STD_LOGIC
);
end ibctrl;

architecture Behavioral of ibctrl is
  COMPONENT Minimal_UART_CORE
    PORT(
          CLOCK : IN std_logic;
          BAUDCLK : IN std_logic;
          RXD : IN std_logic;
          INP : IN std_logic_vector(7 downto 0);
          WR : IN std_logic;
          OUTP : OUT std_logic_vector(7 downto 0);
          EOC : OUT std_logic;
          TXD : OUT std_logic;
          EOT : OUT std_logic
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

  constant CONST_MAGIC : std_logic_vector(7 downto 0) := x"AF";

  subtype packet_i is integer range 0 to 2;
  signal curByte : packet_i;
  type packet is array(2 downto 0) of std_logic_vector(7 downto 0);
  signal curPacket : packet;

  signal devId : std_logic_vector(7 downto 0);

  signal txClk,sent,rxClk : std_logic;
  signal txData,rxData : std_logic_vector(7 downto 0);

  signal ib_packet : std_logic_vector(15 downto 0);
  signal ib_rdclk, ib_full, ib_empty : std_logic;

  type stout_type is (st0_magic, st0_magic_sent, st1_reg, st1_reg_sent, st2_value, st2_value_sent);
  signal st_out : stout_type;
  type stin_type is (st0_magic, st1_reg, st2_value);
  signal st_in : stin_type;

  signal rnw : std_logic;
  signal reg : std_logic_vector(6 downto 0);
begin
  Inst_Minimal_UART_CORE: Minimal_UART_CORE
  PORT MAP(
            CLOCK => CLK,
            BAUDCLK => BAUDCLK,
            EOC => rxClk,
            EOT => sent,
            OUTP => rxData,
            INP => txData,
            WR => txClk,
            RXD => RX,
            TXD => TX
          );

  Inst_ibctrlfifo: pkt16fifo
  PORT MAP(
            DATAIN => PKTOUT,
            WRCLK => PKTOUTCLK,
            DATAOUT => ib_packet,
            RDCLK => ib_rdclk,
            FULL => ib_full,
            EMPTY => ib_empty,
            RESET => RESET
          );

  HOSTOUT: process(RESET, CLK, ib_empty, ib_full, sent)
  begin
    if RESET = '1' then
      st_out <= st0_magic;
      txClk <= '0';
    else
      if CLK'event and CLK = '1' then
        case st_out is
          when st0_magic =>
            ib_rdclk <= '0';
            txClk <= '0';

            if ib_empty = '0' then
              txData <= CONST_MAGIC;
              txClk <= '1';
              st_out <= st0_magic_sent;
            end if;
          when st0_magic_sent =>
            txClk <= '0';
            if sent = '1' then
              st_out <= st1_reg;
            end if;
          when st1_reg =>
            txData <= ib_packet(7 downto 0);
            txClk <= '1';
            st_out <= st1_reg_sent;
          when st1_reg_sent =>
            txClk <= '0';
            if sent = '1' then
              st_out <= st2_value;
            end if;
          when st2_value =>
            txData <= ib_packet(15 downto 8);
            txClk <= '1';
            st_out <= st2_value_sent;
          when st2_value_sent =>
            txClk <= '0';
            if sent = '1' then
              st_out <= st0_magic;
              ib_rdclk <= '1';
            end if;
        end case;
      end if;
    end if;
  end process;


  HOSTIN: process(RESET, CLK, rxClk)
  begin
    if RESET = '1' then
      st_in <= st0_magic;
    else
      if rxClk'event and rxClk = '1' then
        case st_in is
          when st0_magic =>
            PKTINCLK <= '0';

            if rxData = CONST_MAGIC then
              st_in <= st1_reg;
            end if;
          when st1_reg =>
            rnw <= rxData(0);
            reg <= rxData(7 downto 1);
          when st2_value =>
            PKTIN(0) <= rnw;
            PKTIN(7 downto 1) <= reg;
            PKTIN(15 downto 8) <= rxData;
            PKTINCLK <= '1';
        end case;
      end if;
    end if;
  end process;
end Behavioral;
