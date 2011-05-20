----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:46:25 11/17/2010 
-- Design Name: 
-- Module Name:    muxmgr - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity muxmgr is
    Port ( MULTWARN : in  STD_LOGIC_VECTOR (1 downto 0);
           DIVWARN : in  STD_LOGIC_VECTOR (1 downto 0);
	  	   DONE : in STD_LOGIC;
		   LOAD : out STD_LOGIC;
		   ENOUT : out STD_LOGIC;
           CTRL : out  STD_LOGIC_VECTOR (15 downto 0));
end muxmgr;

architecture Behavioral of muxmgr is
signal posmul0 : STD_LOGIC_VECTOR (2 downto 0) := "110";
signal posmul1 : STD_LOGIC_VECTOR (2 downto 0) := "110";
signal posdiv0 : STD_LOGIC_VECTOR (2 downto 0) := "001";
signal posdiv1 : STD_LOGIC_VECTOR (2 downto 0) := "001";
signal send : STD_LOGIC := '0';

begin
	process(MULTWARN, DIVWARN, DONE)
	begin
			if(DONE = '1') then
					LOAD <= '0';
					ENOUT <= '0';
			end if;

			if (falling_edge(MULTWARN(0))) then
					posmul0 <= posmul0 - 1;
					CTRL(3 downto 0) <= posmul0 & '1';
				--	send <= '1';
			end if;
			if (falling_edge(MULTWARN(1))) then
					posmul1 <= posmul1 - 1;
					CTRL(7 downto 4) <= posmul1 & '1';
				--	send <= '1';
			end if; 
			if (rising_edge(DIVWARN(0))) then
					posdiv0 <= posdiv0 + 1;
					CTRL(11 downto 8) <= posdiv0 & '1';
				--	send <= '1';
			end if;
			if (rising_edge(DIVWARN(1))) then
					posdiv1 <= posdiv1 + 1;
					CTRL(15 downto 12) <= posdiv1 & '1';
				--	send <= '1';
			end if;

			if(send = '1') then
					LOAD <= '1';
					ENOUT <= '1';
				--	send <= '0';
			end if;
	end process;
end Behavioral;

