----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:59:27 03/07/2011 
-- Design Name: 
-- Module Name:    config - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: What is effectively a very long set of if statements. 
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

entity config is
    Port ( DATA : in STD_LOGIC_VECTOR(63 downto 0);
		   INT : in STD_LOGIC;
		   STOP : out  STD_LOGIC;
           STOPPED : in  STD_LOGIC;
           ADCCLKSEL : out  STD_LOGIC_VECTOR (2 downto 0);
           ADCSEL : out  STD_LOGIC_VECTOR (1 downto 0));
end config;

architecture Behavioral of config is
		signal state : std_logic := '1';
begin
		process(DATA,INT,STOPPED)
		begin
				STOP <= state;
				if(rising_edge(INT)) then
						case(DATA(15 downto 0)) is
								when "0000000011000000" => --0x00C0 - ADC
										ADCCLKSEL <= DATA(18 downto 16);
										ADCSEL <= DATA(20 downto 19);
								when "0000000011000001" => --0x00C1 - Internal
										state <= DATA(16);
								when "0000000011000010" => --0x00C2 - Probes
								when others =>
						end case;
				end if;
		end process;

end Behavioral;
