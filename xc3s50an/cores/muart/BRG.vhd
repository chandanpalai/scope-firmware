-- _Very_ loosely based on code by Arao Hayashida Filho

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

entity BR_GENERATOR is
        generic (DIVIDER_WIDTH: integer := 8);
        Port (
                     CLOCK : in std_logic;
                     BAUD     : out std_logic
             );
end BR_GENERATOR;

architecture PRINCIPAL of BR_GENERATOR is


-- Change the following constant to your desired baud rate
-- One Hz equal to one bit per second

        signal COUNT_BRG : STD_LOGIC_VECTOR(DIVIDER_WIDTH-1 downto 0):=(others=>'0');

        constant BRDVD : std_logic_vector(DIVIDER_WIDTH-1 downto 0) := X"1B"; -- 1.25MBaud from 33.333MHz ~ 27
begin
        process (CLOCK)
        begin
                if (CLOCK = '1' and CLOCK'event) then
                        if (COUNT_BRG = BRDVD) then
                                BAUD <= '1';
                                COUNT_BRG <= (others => '0');
                        else
                                BAUD <= '0';
                                COUNT_BRG <= COUNT_BRG + '1';
                        end if;
                end if;
        end process;
end PRINCIPAL;
