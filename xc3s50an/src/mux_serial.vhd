----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:54:48 11/17/2010 
-- Design Name: 
-- Module Name:    mux_serial - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux_serial is
    Port ( LOAD : in  STD_LOGIC;
		   EN : in STD_LOGIC;
		   CLKOUT : in STD_LOGIC;
           CTRL : in  STD_LOGIC_VECTOR (15 downto 0);
           CLK : out  STD_LOGIC;
           CS : out  STD_LOGIC;
           DATA : out  STD_LOGIC;
		   DONE : out STD_LOGIC);
end mux_serial;

architecture Behavioral of mux_serial is
		signal intregister : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
		signal i : STD_LOGIC_VECTOR(4 downto 0) := "00000";
		signal state_clkout : STD_LOGIC := '0';
begin
		process(LOAD,CLKOUT,EN)
		begin
				if(LOAD = '1') then
						CS <= '1';
						intregister <= CTRL;
						i <= "00000";
						DONE <= '0';
				elsif (rising_edge(CLKOUT) and EN = '1') then
						intregister <= intregister(14 downto 0) & '0';
						DATA <= intregister(15);
						i <= i + 1;
						if (i = "10000") then
								CS <= '0';
								CLK <= '0';
								DONE <= '1';
						end if;
				end if;

				if (EN = '1') then
						CLK <= state_clkout;
						state_clkout <= not state_clkout;
				end if;
		end process;
end Behavioral;

