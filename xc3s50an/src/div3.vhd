----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:47:40 02/27/2011 
-- Design Name: 
-- Module Name:    div3 - Behavioral 
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
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity div3 is
    Port ( CLKIN : in  STD_LOGIC;
           CLKOUT : out  STD_LOGIC);
end div3;

architecture Behavioral of div3 is
		signal counter : STD_LOGIC_VECTOR(2 downto 0) := "000";
		signal clkstate : STD_LOGIC := '1';
begin
		process(CLKIN)
		begin
				if(rising_edge(CLKIN)) then
						counter <= counter + 1;
						if(counter = "010") then
								counter <= "000";
								clkstate <= '1';
						end if;
				end if;
				if(CLKIN = '0' and counter = "001") then
						clkstate <= '0';
				end if;
				CLKOUT <= clkstate;
		end process;
end Behavioral;

