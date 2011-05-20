----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:35:36 11/18/2010 
-- Design Name: 
-- Module Name:    sampleclk - Behavioral 
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

entity sampleclk is
    Port ( CLKIN : in  STD_LOGIC;
           sel : in  STD_LOGIC_VECTOR (2 downto 0);
           CLK : out  STD_LOGIC);
end sampleclk;

architecture Behavioral of sampleclk is
		signal i : STD_LOGIC_VECTOR(5 downto 0) := "000000";
		signal clkstate : STD_LOGIC := '0';
begin
		process(CLKIN)
		begin
				if(rising_edge(CLKIN)) then
						if (i = "000000") then
								clkstate <= not(clkstate);
								case sel is
										when "000" => i <= "000000";
										when "001" => i <= "000001"; 
										when "010" => i <= "000010";
										when "011" => i <= "000100";
										when "100" => i <= "001000";
										when "101" => i <= "010000";
										when "110" => i <= "100000";
										when "111" => i <= "111111";
										when others => null;
								end case;
						else
								i <= i - 1;
						end if;
				end if;
		end process;

		CLK <= CLKIN when sel = "000" else clkstate;

end Behavioral;

