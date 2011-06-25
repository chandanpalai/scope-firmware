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
--use IEEE.NUMERIC_STD.ALL;

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

           FLAGA : in  STD_LOGIC; --!EP2EF
           FLAGB : in  STD_LOGIC; --!EP4EF
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
                            st1_w_assertfifo, st2_w_slwr, st3_w_write, st4_w_deassert, st5_w_next);
        signal state, next_state : state_type;

        signal out_sloe, out_slrd, out_slwr, out_pktend : STD_LOGIC;
        signal out_fifoadr : STD_LOGIC_VECTOR (1 downto 0);
        signal out_fd, out_data : STD_LOGIC_VECTOR (15 downto 0);

        signal out_outdataclk : STD_LOGIC;

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

        signal ub_rst, ub_wrclk, ub_rdclk, ub_wren, ub_rden, ub_full, ub_empty : STD_LOGIC;
        signal ub_din, ub_dout : STD_LOGIC_VECTOR(15 downto 0);
begin
        --Add the FIFO Buffer
        inst_usbbuffer : usbbuffer
        PORT MAP (
            wr_clk => ub_wrclk,
            rd_clk => ub_rdclk,
            din => ub_din,
            wr_en => ub_wren,
            rd_en => ub_rden,
            dout => ub_dout,
            full => ub_full,
            empty => ub_empty
        );

        --State machine for FX2 communications
        SYNC_PROC : process(CLKIF,RESET)
        begin
                if CLKIF'event and CLKIF = '1' then
                        if RESET = '1' then
                                state <= st0_default;
                                SLOE <= '1';
                                SLRD <= '1';
                                SLWR <= '1';
                                FIFOADR <= "00";
                                PKTEND <= '1';
                                FD <= "ZZZZZZZZZZZZZZZZ";
                        else
                                state <= next_state;

                                SLOE <= out_sloe;
                                SLRD <= out_slrd;
                                SLWR <= out_slwr;
                                FIFOADR <= out_fifoadr;
                                PKTEND <= out_pktend;
                                FD <= out_fd;
                                
                                OUTDATA <= out_data;
                                OUTDATACLK <= out_outdataclk;
                        end if;
                end if;
        end process;

        OUTPUT_DECODE : process(state, FD, ub_dout) --add relevant inputs here
        begin
                case state is
                        when st0_default =>
                                out_sloe <= '1';
                                out_slrd <= '1';
                                out_slwr <= '1';
                                out_fifoadr <= "00";
                                out_pktend <= '1';
                                out_fd <= "ZZZZZZZZZZZZZZZZ";
                                out_data <= "0000000000000000";
                                out_outdataclk <= '0';

                                ub_rden <= '0';

                        --read states
                        when st1_r_assertfifo =>
                                out_fifoadr <= "00"; --Read from EP2
                        when st2_r_sloe =>
                                out_sloe <= '0';
                        when st3_r_sample =>
                                out_slrd <= '0';
                        when st4_r_deassert =>
								out_data <= FD;
                                out_outdataclk <= '1';
                                out_slrd <= '1';
                                out_sloe <= '1';
                        when st5_r_next =>
                                out_outdataclk <= '0';

                        --write states
                        when st1_w_assertfifo =>
                            out_fifoadr <= "10"; --Write to EP6
                        when st2_w_slwr =>
                            out_slwr <= '0';
                        when st3_w_write =>
                            out_fd <= ub_dout;
                            ub_rden <= '1';
                        when st4_w_deassert =>
                            ub_rden <= '0';
                            out_slwr <= '1';
                        when st5_w_next =>

                        when others =>
                end case;
        end process;

        NEXT_STATE_DECODE : process(state, FLAGA, FLAGB, FLAGC, ub_empty, ub_full) --add relevant inputs here
        begin
                next_state <= state; --default involves no changing

                case state is
                        when st0_default =>
                                if FLAGA = '1' then --some data in EP2
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
                            next_state <= st2_w_slwr;
                        when st2_w_slwr =>
                            if FLAGC = '1' then
                                next_state <= st3_w_write;
                            end if;
                        when st3_w_write =>
                            next_state <= st4_w_deassert;
                        when st4_w_deassert =>
                            next_state <= st5_w_next;
                        when st5_w_next =>
                            if ub_empty = '0' then --still not empty
                                next_state <= st2_w_slwr;
                            else
                                next_state <= st0_default;
                            end if;

                        when others =>
                                next_state <= state; --lets hope the problem gets solved by OUTPUT_DECODE.. :S
                end case;
        end process;

        --Front end for FPGA view
        process(INDATA, INDATACLK, INDATAEN, ub_full, CLKIF)
        begin
            if ub_full = '0' then
                ub_din <= INDATA;
                ub_wrclk <= INDATACLK;
                ub_wren <= INDATAEN;
            end if;
            ub_rdclk <= CLKIF;
        end process;

end Behavioral;

