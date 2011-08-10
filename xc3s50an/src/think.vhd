----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:17:29 06/23/2011 
-- Design Name: 
-- Module Name:    think - Behavioral 
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

entity think is
    Port ( DATAIN : in  STD_LOGIC_VECTOR (15 downto 0);
           DATACLK : in  STD_LOGIC;

           RESET : in STD_LOGIC;
           CLKIF : in STD_LOGIC;

           ZZ : out  STD_LOGIC;
           CFGCLK : out  STD_LOGIC_VECTOR (7 downto 0);
           CFGCHNL : out  STD_LOGIC_VECTOR (1 downto 0));
end think;

architecture Behavioral of think is
    type state_type is (st0_magic, st1_data, st2_chk);
    signal state, next_state : state_type;

    signal out_zz : STD_LOGIC := '1';
    signal out_cfgclk : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
    signal out_cfgchnl : STD_LOGIC_VECTOR(1 downto 0) := "00";

    signal data : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";

begin
    SYNC_PROC: process(CLKIF,RESET)
    begin
        if RESET = '1' then
            state <= st0_magic;
            ZZ <= '1';
            CFGCLK <= "00000000";
            CFGCHNL <= "00";
        else
            if CLKIF'event and CLKIF = '1' then
                state <= next_state;
                ZZ <= out_zz;
                CFGCLK <= out_cfgclk;
                CFGCHNL <= out_cfgchnl;
            end if;
        end if;
    end process;

    OUTPUT_DECODE: process(state, DATACLK, DATAIN, data)
    begin
        case(state) is 
            when st0_magic =>
            when st1_data =>
                if DATACLK = '1' then
                    data <= DATAIN;
                end if;
            when st2_chk =>
                if DATACLK = '1' and DATAIN = "1111000010101010" then --Todo: use checksum instead. 
                    out_zz <= data(15);
                    out_cfgchnl <= data(9 downto 8);
                    out_cfgclk <= data(7 downto 0);
                end if;
        end case;
    end process;

    NEXT_STATE_DECODE: process(state, DATAIN, DATACLK)
    begin
        next_state <= state;

        case(state) is
            when st0_magic =>
                if DATACLK = '1' and DATAIN = "0011110000111100" then
                    next_state <= st1_data;
                end if;
            when st1_data =>
                if DATACLK = '1' then
                    next_state <= st2_chk;
                end if;
            when st2_chk =>
                if DATACLK = '1' then
                    next_state <= st0_magic;
                end if;
            when others =>
                next_state <= st0_magic;
        end case;
    end process;

end Behavioral;

