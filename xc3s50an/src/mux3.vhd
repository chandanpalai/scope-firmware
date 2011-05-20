----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:01:44 03/07/2011 
-- Design Name: 
-- Module Name:    mux16 - Behavioral 
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

entity mux3 is
    Port ( D0 : in  STD_LOGIC_VECTOR (2 downto 0);
           D1 : in  STD_LOGIC_VECTOR (2 downto 0);
           SEL : in  STD_LOGIC;
           D : out  STD_LOGIC_VECTOR (2 downto 0));
end mux3;

architecture Behavioral of mux3 is

begin
		process(SEL,D0,D1)
		begin
				if(SEL = '1') then
						D <= D1;
				else
						D <= D0;
				end if;
		end process;
end Behavioral;

