----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:17:16 11/19/2010 
-- Design Name: 
-- Module Name:    adc - Behavioral 
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

entity adcmgr is
    Port ( D0 : in  STD_LOGIC_VECTOR (7 downto 0);
           D1 : in  STD_LOGIC_VECTOR (7 downto 0);
		   SMPLCLK : in STD_LOGIC;
	 	   SEL : in STD_LOGIC_VECTOR (1 downto 0);
		   ZZ : in STD_LOGIC;
           CLK : out  STD_LOGIC;
           OE : out  STD_LOGIC;
           PD : out  STD_LOGIC;
   		   DATA : out STD_LOGIC_VECTOR (15 downto 0);
		   VALID : out STD_LOGIC);
end adcmgr;

architecture Behavioral of adcmgr is
begin
		process(SMPLCLK,SEL,ZZ)
		begin
				if(SEL = "00") then
						OE <= '1';
						PD <= '1';
				else
						OE <= ZZ;
						PD <= ZZ;
				end if;

				if(SMPLCLK'event and SMPLCLK = '1' and ZZ = '0' and not (SEL = "00")) then
						if(SEL(0) = '1') then
								DATA(7 downto 0) <= D0;
						else
								DATA(7 downto 0) <= "00000000";
						end if;
						if(SEL(1) = '1') then
								DATA(15 downto 8) <= D1;
						else
								DATA(15 downto 8) <= "00000000";
						end if;
						VALID <= '1';
				end if;

				if(ZZ = '0') then
						CLK <= SMPLCLK;
				else
						CLK <= '1';
						VALID <= '0';
				end if;
		end process;
end Behavioral;

