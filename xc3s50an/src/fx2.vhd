----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    21:39:09 06/22/2011
-- Design Name:
-- Module Name:    fx2 - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fx2 is
        Port ( --to fpga internals
                     INDATA : in  STD_LOGIC_VECTOR (15 downto 0);
                     INDATACLK : in  STD_LOGIC;
                     INDATAEN : in STD_LOGIC;

                     OUTDATA : out  STD_LOGIC_VECTOR (15 downto 0);
                     OUTDATACLK : out  STD_LOGIC;

                     CLKIF : in  STD_LOGIC;
                     RESET : in STD_LOGIC;

           --to IC
                     FD : inout  STD_LOGIC_VECTOR (15 downto 0);

                     FLAGA : in  STD_LOGIC; --!EP4EF
                     FLAGB : in  STD_LOGIC; --!EP6EF
                     FLAGC : in  STD_LOGIC; --!EP6FF

                     SLOE : out  STD_LOGIC;
                     SLRD : out  STD_LOGIC;
                     SLWR : out  STD_LOGIC;

                     FIFOADR : out  STD_LOGIC_VECTOR (1 downto 0);
                     PKTEND : out  STD_LOGIC);
end fx2;

architecture Behavioral of fx2 is
        --state machine
        type state_type is (st0_default,
        st1_r_assertfifo, st2_r_sloe, st3_r_sample, st4_r_deassert, st5_r_next,
        st1_w_assertfifo, st2_w_data, st3_w_pulse, st4_w_next);
        signal state, next_state : state_type;
        signal out_signals : STD_LOGIC_VECTOR(2 downto 0);
        signal byte_count : unsigned(7 downto 0); --Max value 511 so overflow indicates send packet
        constant OUTEP : STD_LOGIC_VECTOR(1 downto 0) := "01"; -- EP4
        constant INEP : STD_LOGIC_VECTOR(1 downto 0) := "10"; -- EP6
        constant FIFO_OE : STD_LOGIC_VECTOR(2 downto 0) := "110"; -- SLOE
        constant FIFO_READ : STD_LOGIC_VECTOR(2 downto 0) := "100"; -- SLOE + SLRD
        constant FIFO_WRITE : STD_LOGIC_VECTOR(2 downto 0) := "011"; -- SLWR
        constant FIFO_NOP : STD_LOGIC_VECTOR(2 downto 0) := "111"; -- NOP

        --FIFO Buffer
        COMPONENT usbbuffer
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

        signal ub_rden, ub_empty : STD_LOGIC;
        signal ub_dout : STD_LOGIC_VECTOR(15 downto 0);
begin
        --Add the FIFO Buffer
        inst_usbbuffer : usbbuffer
        PORT MAP (
                         wr_clk => INDATACLK,
                         rd_clk => CLKIF,
                         din => INDATA,
                         wr_en => INDATAEN,
                         rd_en => ub_rden,
                         dout => ub_dout,
                       --  full => ub_full, --signal currently ignored. Link out to zz?
                         empty => ub_empty
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

        OUTPUT_DECODE : process(state, CLKIF, FD, ub_dout) --add relevant inputs here
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

                                        ub_rden <= '0';

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
                                        FIFOADR <= INEP;
                                when st2_w_data =>
                                        FD <= ub_dout;
                                        ub_rden <= '1';
                                        out_signals <= FIFO_WRITE;
                                        byte_count <= byte_count + 1;
                                when st3_w_pulse =>
                                        out_signals <= FIFO_NOP;
                                        ub_rden <= '0';
                                when st4_w_next =>
                                        if (not (byte_count = 0)) then
                                                PKTEND <= '0';
                                        end if;
                        end case;
                end if;

        end process;

        SLOE <= out_signals(0);
        SLRD <= out_signals(1);
        SLWR <= out_signals(2);

        NEXT_STATE_DECODE : process(state, FLAGA, FLAGB, FLAGC, ub_empty)
        begin
                next_state <= state; --default involves no changing

                case state is
                        when st0_default =>
                                if FLAGA = '1' then --some data in EP4
                                        next_state <= st1_r_assertfifo;
                                elsif ub_empty = '0' then --not empty
                                        next_state <= st1_w_assertfifo;
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
                                if FLAGA = '1' then --still more
                                        next_state <= st2_r_sloe;
                                else
                                        next_state <= st0_default;
                                end if;

                        --write states
                        when st1_w_assertfifo =>
                                next_state <= st2_w_data;
                        when st2_w_data =>
                                if FLAGC = '1' then
                                        next_state <= st3_w_pulse;
                                end if;
                        when st3_w_pulse =>
                                next_state <= st4_w_next;
                        when st4_w_next =>
                                if ub_empty = '0' then --still not empty
                                        next_state <= st2_w_data;
                                else
                                        next_state <= st0_default;
                                end if;

                        when others =>
                                next_state <= state; --lets hope the problem gets solved by OUTPUT_DECODE.. :S
                end case;
        end process;
end Behavioral;

