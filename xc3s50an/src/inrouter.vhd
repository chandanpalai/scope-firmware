----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:28:11 03/01/2011 
-- Design Name: 
-- Module Name:    inrouter - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity inrouter is
    Port ( 
		--CY
		   CYDATA_IN : in  STD_LOGIC_VECTOR (15 downto 0);
		   CYINT : in STD_LOGIC;
		   CYDATA_OUT : out STD_LOGIC_VECTOR (15 downto 0);
		   CYDATA_OUT_SEL : out STD_LOGIC;
		   CYCLK : in STD_LOGIC;
		--MEM
           MEMDATA : in  STD_LOGIC_VECTOR (15 downto 0);
		   MEMCLK : in STD_LOGIC;
		   MEMCTRL : out STD_LOGIC_VECTOR (2 downto 0);
		   MEMCTRL_SEL : out STD_LOGIC;
		--CTRL
		   RESET : in STD_LOGIC;
		   STOP : in STD_LOGIC;
		   STOPPED : out STD_LOGIC;
		   STATE_CLK : in STD_LOGIC;
   		--PROCESSING OUTPUT
		   PROCESSINT : out STD_LOGIC;
		   PROCESSDATA : out STD_LOGIC_VECTOR (63 downto 0)
   );
end inrouter;

architecture Behavioral of inrouter is
		type cydata_type is array (2 downto 0) of std_logic_vector(15 downto 0);
		signal cydata : cydata_type;

   		type state_type is (st1_cyheader,st2_cyd1,st3_cyd2,st4_cyd3); 
   		signal state, next_state : state_type; 
begin
		SYNC_PROC: process (STATE_CLK,CYCLK,CYINT,RESET)
		begin
				if(CYCLK'event and CYCLK = '1') then
						if(CYINT = '1') then
								state <= next_state;
						else
								state <= st1_cyheader;
						end if;
				end if;
		end process;

		OUTPUT_DECODE: process (state)
		begin
		end process;

		STATE_DEC: process (state,CYINT,CYDATA_IN)
		begin
				next_state <= state;
				case (state) is
						when st1_cyheader =>
								PROCESSINT <= '0';
								cydata(0) <= CYDATA_IN;
								next_state <= st2_cyd1;
						when st2_cyd1 =>
								cydata(1) <= CYDATA_IN;
								next_state <= st3_cyd2;
						when st3_cyd2 =>
								cydata(2) <= CYDATA_IN;
								next_state <= st4_cyd3;
						when st4_cyd3 =>
								PROCESSDATA(63 downto 48) <= CYDATA_IN;
								PROCESSDATA(47 downto 32) <= cydata(2);
								PROCESSDATA(31 downto 16) <= cydata(1);
								PROCESSDATA(15 downto 0) <= cydata(0);
								PROCESSINT <= '1';
								next_state <= st1_cyheader;
						when others =>
								next_state <= st1_cyheader;
				end case;      
		end process;

end Behavioral;

