----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:47:40 02/27/2011 
-- Design Name: 
-- Module Name:    div10 - Behavioral 
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

entity div10 is
    Port ( CLKIN : in  STD_LOGIC;
           CLKOUT : out  STD_LOGIC);
end div10;

architecture Behavioral of div10 is
		signal counter : STD_LOGIC_VECTOR(3 downto 0) := "0000";
		signal clkstate : STD_LOGIC := '0';
begin
		process(CLKIN)
		begin
				if(rising_edge(CLKIN)) then
						counter <= counter + 1;
						if(counter = "1001") then
								clkstate <= not clkstate;
								counter <= "0000";
						end if;
						CLKOUT <= clkstate;
				end if;
		end process;
end Behavioral;

