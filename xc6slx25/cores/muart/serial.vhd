-- _Very_ loosely based on code by Arao Hayashida Filho

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

entity Minimal_UART_CORE is
        port(
                    --FPGA Internals
                    CLOCK : in std_logic; --16x BAUDCLK
                    BAUDCLK : in std_logic; --Baud Rate
                    OUTP : out std_logic_vector(7 downto 0); --Character received
                    INP : in std_logic_vector(7 downto 0); --Character to send
                    WR : in std_logic; --Transmit INP

                    EOC : out std_logic; --High when OUTP valid
                    EOT	: out std_logic; --High when finished transmitting

                    --UART Lines
                    RXD : in std_logic; --RX line
                    TXD	: out std_logic --TX line
            );
end Minimal_UART_CORE;

ARCHITECTURE PRINCIPAL OF Minimal_UART_CORE  is

        type STATE is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9);
        signal old_rxd : std_logic:='0';
        signal INPL : std_logic_vector(7 downto 0):=X"00";
        signal DATA : std_logic_vector(7 downto 0):=X"00";
        signal STATE_RXD, STATE_TXD : STATE := S0;
        signal TX_ENABLE : std_logic :='0';
        signal EOC_out : std_logic := '0';
        signal EOT_out : std_logic := '0';
begin

        EOC <= EOC_out;
        EOT <= EOT_out;

        RXD_STATE_MACHINE : process(STATE_RXD, BAUDCLK, old_rxd)
        begin
                if (BAUDCLK = '1' and BAUDCLK'event) then
                        case STATE_RXD is
                                when S0 =>
                                        EOC_out <= '0';
                                        if (old_rxd = '1' and RXD = '0') then
                                                STATE_RXD<=S1;
                                        else
                                                STATE_RXD<=S0;
                                        end if;
                                when S1 =>
                                        STATE_RXD<=S2;
                                        DATA(0) <= RXD;
                                when S2	=>
                                        STATE_RXD<=S3;
                                        DATA(1) <= RXD;
                                when S3	=>
                                        STATE_RXD<=S4;
                                        DATA(2) <= RXD;
                                when S4	=>
                                        STATE_RXD<=S5;
                                        DATA(3) <= RXD;
                                when S5	=>
                                        STATE_RXD<=S6;
                                        DATA(4) <= RXD;
                                when S6	=>
                                        STATE_RXD<=S7;
                                        DATA(5) <= RXD;
                                when S7	=>
                                        STATE_RXD<=S8;
                                        DATA(6) <= RXD;
                                when S8	=>
                                        STATE_RXD<=S9;
                                        DATA(7) <= RXD;
                                when S9	=>
                                        EOC_out <= '1';
                                        STATE_RXD<=S0;
                                        OUTP <= DATA;
                        end case;
                        old_rxd <= RXD;
                end if;
        end process RXD_STATE_MACHINE;

        TX_START : process (CLOCK, WR, EOT_out)
        begin
                if (EOT_out = '1') then
                        TX_ENABLE<='0';
                elsif (falling_edge(CLOCK)) then
                        if (WR='1') then
                                TX_ENABLE<='1';
                        end if;
                end if;
        end process TX_START;

        TXD_STATE_MACHINE : process(STATE_TXD, TX_ENABLE, INP, BAUDCLK)
        begin
                if (BAUDCLK = '1' and BAUDCLK'event) then
                        case STATE_TXD is
                                when S0 =>
                                        INPL<=INP;
                                        EOT_out <= '0';
                                        if (TX_ENABLE='1') then
                                                TXD<='0';
                                                STATE_TXD<=S1;
                                        else
                                                TXD<='1';
                                                STATE_TXD<=S0;
                                        end if;
                                when S1 =>
                                        TXD<=INPL(0);
                                        STATE_TXD<=S2;
                                when S2 =>
                                        TXD<=INPL(1);
                                        STATE_TXD<=S3;
                                when S3 =>
                                        TXD<=INPL(2);
                                        STATE_TXD<=S4;
                                when S4 =>
                                        TXD<=INPL(3);
                                        STATE_TXD<=S5;
                                when S5 =>
                                        TXD<=INPL(4);
                                        STATE_TXD<=S6;
                                when S6 =>
                                        TXD<=INPL(5);
                                        STATE_TXD<=S7;
                                when S7 =>
                                        TXD<=INPL(6);
                                        STATE_TXD<=S8;
                                when S8 =>
                                        TXD<=INPL(7);
                                        STATE_TXD<=S9;
                                when S9 =>
                                        TXD<='1';
                                        EOT_out <= '1';
                                        STATE_TXD<=S0;
                        end case;
                end if;
        end process TXD_STATE_MACHINE;
end PRINCIPAL ;
