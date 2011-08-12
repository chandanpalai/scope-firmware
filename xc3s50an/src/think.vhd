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
        signal state : state_type;

        signal zz_out : STD_LOGIC := '1';
        signal cfgchnl_out : STD_LOGIC_VECTOR(1 downto 0) := "00";
        signal cfgclk_out : STD_LOGIC_VECTOR(7 downto 0) := "00000000";

begin
        FSM: process(RESET,DATAIN,DATACLK)
        begin
                if RESET = '1' then
                        state <= st0_magic;
                        ZZ <= '1';
                        CFGCLK <= "00000000";
                        CFGCHNL <= "00";
                else
                        if DATACLK'event and DATACLK = '0' then --use falling edge to ensure data has settled
                                case state is
                                        when st0_magic =>
                                                if DATAIN = x"3c2c" then --bugfix: hex changed to account for hw fault
                                                        state <= st1_data;
                                                end if;
                                        when st1_data =>
                                                zz_out <= DATAIN(15);
                                                cfgchnl_out <= DATAIN(9 downto 8);
                                                cfgclk_out <= DATAIN(7 downto 0);
                                                state <= st2_chk;
                                        when st2_chk =>
                                                if DATAIN = x"aae0" then
                                                        ZZ <= zz_out;
                                                        CFGCHNL <= cfgchnl_out;
                                                        CFGCLK <= cfgclk_out;
                                                end if;
                                                state <= st0_magic;
                                end case;
                        end if;
                end if;
        end process;
end Behavioral;

