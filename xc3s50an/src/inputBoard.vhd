----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:38:54 08/14/2011 
-- Design Name: 
-- Module Name:    inputBoard - Behavioral 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity inputBoard is
        Port ( RESET : in  STD_LOGIC;
               CLK : in  STD_LOGIC;
               CFGIB : in  STD_LOGIC_VECTOR (15 downto 0);
               SAVE : in  STD_LOGIC;
               ERR : out  STD_LOGIC;
               RX : in STD_LOGIC;
               TX : out STD_LOGIC);
end inputBoard;

architecture Behavioral of inputBoard is
        COMPONENT uartTop
                PORT(
                            clr : IN std_logic;
                            clk : IN std_logic;
                            serIn : IN std_logic;
                            txData : IN std_logic_vector(7 downto 0);
                            newTxData : IN std_logic;
                            baudFreq : IN std_logic_vector(11 downto 0);
                            baudLimit : IN std_logic_vector(15 downto 0);          
                            serOut : OUT std_logic;
                            txBusy : OUT std_logic;
                            rxData : OUT std_logic_vector(7 downto 0);
                            newRxData : OUT std_logic;
                            baudClk : OUT std_logic
                    );
        END COMPONENT;

        --Setup for a 33MHz clock, and 1.25MBaud
        --16xbaudRate / gcd(clkFreq,16*baudRate)
        constant baudFreq : std_logic_vector(11 downto 0) := x"014";
        --clkFreq / gcd(clkFreq,16*baudrate) - baudFreq
        constant baudLimit : std_logic_vector(15 downto 0) := x"000d";

        signal newTxData, txBusy, newRxData : std_logic;
        signal txData, rxData : std_logic_vector(7 downto 0);

        signal curByte : integer := 0;
        type packet is array(2 downto 0) of std_logic_vector(7 downto 0);
        signal curPacket : packet;

        signal devId : std_logic_vector(7 downto 0);

        type state_type is (st_what, st_r_byte, st_r_parse,
        st_w_byte, st_w_byte2, st_w_regs, st_w_ack);
        signal state : state_type;
begin
        Inst_uartTop: uartTop PORT MAP(
                                              clr => RESET,
                                              clk => CLK,
                                              serIn => RX,
                                              serOut => TX,
                                              txData => txData,
                                              newTxData => newTxData,
                                              txBusy => txBusy,
                                              rxData => rxData,
                                              newRxData => newRxData,
                                              baudFreq => baudFreq,
                                              baudLimit => baudLimit
                                      --baudClk => 
                                      );

        process(RESET,CLK,SAVE,newTxData,txBusy,newRxData)
        begin
                if RESET = '1' then
                        state <= st_what;
                        ERR <= '1';
                        curByte <= 0;
                        devId <= x"00";
                elsif CLK'event and CLK = '1' then
                        case state is
                                when st_what =>
                                        if newRxData = '1' then
                                                state <= st_r_byte;
                                        elsif SAVE = '1' then
                                                state <= st_w_regs;
                                        end if;
                                when st_r_byte =>
                                        curPacket(curByte) <= rxData;
                                        if curByte = 2 then
                                                curByte <= 0;
                                                state <= st_r_parse;
                                        else
                                                curByte <= curByte + 1;
                                                state <= st_r_byte;
                                        end if;
                                when st_r_parse =>
                                        case curPacket(0) is
                                                when x"02" => --init
                                                        devId <= curPacket(1);
                                                        ERR <= '0';
                                                when x"01" => --ack
                                                        case curPacket(2) is
                                                                when x"C0" =>
                                                                when x"C1" =>
                                                                when x"FF" =>
                                                                        ERR <= '1';
                                                                when others =>
                                                        end case;
                                                when others =>
                                        end case;
                                        state <= st_w_ack;
                                when st_w_regs =>
                                        curPacket(0) <= x"10";
                                        curPacket(1) <= CFGIB(7 downto 0);
                                        curPacket(2) <= CFGIB(15 downto 8);
                                        state <= st_w_byte;
                                when st_w_ack =>
                                        curPacket(1) <= curPacket(0);
                                        curPacket(0) <= x"01";
                                        curPacket(2) <= x"00";
                                        state <= st_w_byte;
                                when st_w_byte =>
                                        txData <= curPacket(curByte);
                                        newTxData <= '1';
                                        state <= st_w_byte2;
                                when st_w_byte2 =>
                                        newTxData <= '0';
                                        if curByte = 2 then
                                                curByte <= 0;
                                                state <= st_what;
                                        elsif txBusy = '0' then
                                                curByte <= curByte + 1;
                                                state <= st_w_byte;
                                        end if;

                        end case;
                end if;
        end process;

end Behavioral;

