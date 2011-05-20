----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:34:01 02/06/2011 
-- Design Name: 
-- Module Name:    outrouter - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity outrouter is
    Port ( 
		--ADC
		   ADCCLK : in  STD_LOGIC;
           ADCDATA : in  STD_LOGIC_VECTOR (15 downto 0);
		   VALID : in STD_LOGIC;
		--CY
           CYCLK : in  STD_LOGIC;
		   CYWRITE_STROBE : out STD_LOGIC;
           CYDATA : out  STD_LOGIC_VECTOR (15 downto 0);
		--DDR
           MEMCLK : in  STD_LOGIC;
		   MEMCTRL_BURST_DONE : out STD_LOGIC;
		   MEMCTRL : out STD_LOGIC_VECTOR (2 downto 0);
		   MEMDATAMASK : out STD_LOGIC_VECTOR (1 downto 0);
           MEMDATA : out  STD_LOGIC_VECTOR (15 downto 0);
		   MEMADDR : out STD_LOGIC_VECTOR (25 downto 0);
		--CTRL
           STOP : in  STD_LOGIC;
           STOPPED : out  STD_LOGIC);
end outrouter;

architecture Behavioral of outrouter is
signal cy_nextdata : std_logic_vector(15 downto 0);
signal todo : std_logic := '0';
begin
		process(ADCCLK,ADCDATA,VALID,todo,STOP)
		begin
				if(STOP = '0') then
						STOPPED <= '0';
						if(ADCCLK = '1' and ADCCLK'event and VALID = '1') then
								cy_nextdata <= ADCDATA;
								todo <= '1';
						end if;
				else
						STOPPED <= '1';
						todo <= '0';
				end if;
		end process;

		process(CYCLK,todo)
		begin
				if(todo = '1') then
						if(CYCLK = '1' and CYCLK'event) then
								CYDATA <= cy_nextdata;
						end if;
				CYWRITE_STROBE <= CYCLK;
				end if;
		end process;
end Behavioral;

