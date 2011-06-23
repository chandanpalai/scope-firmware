----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:44:57 06/22/2011 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adc is
    Port ( DA : in  STD_LOGIC_VECTOR (7 downto 0);
           DB : in  STD_LOGIC_VECTOR (7 downto 0);
           DATA : out  STD_LOGIC_VECTOR (15 downto 0);
           DATAEN : out STD_LOGIC;

           ZZ : in STD_LOGIC;
           PD : out STD_LOGIC;
           OE : out STD_LOGIC;

           CLKSMPL : out  STD_LOGIC;
		   CLKM : in STD_LOGIC;
           CFGCLK : in  STD_LOGIC_VECTOR (7 downto 0);
           CFGCHNL : in  STD_LOGIC_VECTOR (1 downto 0));
end adc;

architecture Behavioral of adc is
		signal iclk : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
		signal smplclk : STD_LOGIC := '0';
        signal en : STD_LOGIC := '1';
begin
		--CLK SYSTEM
		process(CLKM, CFGCLK, en)
		begin
				if CLKM = '1' and en = '1' then
						iclk <= std_logic_vector(unsigned(iclk) + 1);
						if iclk = CFGCLK then
								iclk <= "00000000";
								smplclk <= not smplclk;
						end if;
				end if;
				CLKSMPL <= smplclk;
                DATAEN <= en;
		end process;

		--DATA FLOW
        process(smplclk, DA, DB)
        begin
                if smplclk = '1' then
                        if CFGCHNL(0) = '1' then
                                DATA(7 downto 0) <= DA;
                        else
                                DATA(7 downto 0) <= "00000000";
                        end if;
                        if CFGCHNL(1) = '1' then
                                DATA(15 downto 8) <= DB;
                        else
                                DATA(15 downto 8) <= "00000000";
                        end if;
                end if;
        end process;

        --SLEEPING
        process(ZZ)
        begin
                if ZZ = '1' then
                        PD <= '1';
                        OE <= '1';
                else
                        PD <= '0';
                        OE <= '0';
                end if;
                en <= not ZZ;
        end process;

end Behavioral;

