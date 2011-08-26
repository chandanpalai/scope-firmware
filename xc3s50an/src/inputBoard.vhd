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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity inputBoard is
        Port ( RESET : in  STD_LOGIC;
               CLK : in  STD_LOGIC;
               BAUDCLK : in STD_LOGIC;
               CFGIB : in  STD_LOGIC_VECTOR (15 downto 0);
               SAVE : in  STD_LOGIC;
               ERR : out  STD_LOGIC;
               RX : in STD_LOGIC;
               TX : out STD_LOGIC);
end inputBoard;

architecture Behavioral of inputBoard is
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

        signal curByte : std_logic_vector (1 downto 0) := "00";
        type packet is array(2 downto 0) of std_logic_vector(7 downto 0);
        signal curPacket : packet;

        signal devId : std_logic_vector(7 downto 0);

        signal ready,outValid,sent,inValid : std_logic;
        signal inData,outData : std_logic_vector(7 downto 0);

        type state_type is (st_what, st_r_byte, st_r_parse,
        st_w_byte, st_w_byte2, st_w_regs, st_w_ack);
        signal state : state_type;
begin
        Inst_Minimal_UART_CORE: Minimal_UART_CORE PORT MAP(
		CLOCK => CLK,
                BAUDCLK => BAUDCLK,
		EOC => outValid,
		EOT => sent,
		OUTP => outData,
		INP => inData,
		WR => inValid,
		RXD => RX,
		TXD => TX
	);

        process(RESET,CLK,SAVE,outValid,ready,sent,outData,ready)
        begin
                if RESET = '1' then
                        state <= st_what;
                        ERR <= '1';
                        curByte <= "00";
                        devId <= x"00";
                        inValid <= '0';
                elsif CLK'event and CLK = '1' then
                        case state is
                                when st_what =>
                                        if outValid = '1' then
                                                state <= st_r_byte;
                                        elsif SAVE = '1' then
                                                state <= st_w_regs;
                                        end if;
                                when st_r_byte =>
                                        curPacket(CONV_INTEGER(curByte)) <= outData;
                                        if curByte = 2 then
                                                curByte <= "00";
                                                state <= st_r_parse;
                                        else
                                                curByte <= curByte + '1';
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
                                        if sent = '0' then
                                                inData <= curPacket(CONV_INTEGER(curByte));
                                                inValid <= '1';
                                                state <= st_w_byte2;
                                        end if;
                                when st_w_byte2 =>
                                        inValid <= '0';
                                        if curByte = 2 then
                                                curByte <= "00";
                                                state <= st_what;
                                        elsif ready = '1' then
                                                curByte <= curByte + '1';
                                                state <= st_w_byte;
                                        end if;

                        end case;
                end if;
        end process;

end Behavioral;

