----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:11:49 12/01/2010 
-- Design Name: 
-- Module Name:    cyfifo - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:  NB: Reads are treated as more important than writes
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

entity cyfifo is
    Port ( RESET : in STD_LOGIC;
		   USER_IN_DATA : in  STD_LOGIC_VECTOR (15 downto 0);
		   WRITE_STROBE : in STD_LOGIC;
           CLKIN : in  STD_LOGIC;
	 	   STATE_CLK : in STD_LOGIC;
           USER_OUT_DATA : out  STD_LOGIC_VECTOR (15 downto 0);
		   DATAINT : out STD_LOGIC;
		   CY_SLRD : out STD_LOGIC;
		   CY_SLWR : out STD_LOGIC;
		   CY_SLOE : out STD_LOGIC;
		   CY_FIFOADDR : out STD_LOGIC_VECTOR (1 downto 0);
		   CY_FLAGA : in STD_LOGIC; --EP2EF
		   CY_FLAGB : in STD_LOGIC; --EP4EF
		   CY_FLAGC : in STD_LOGIC; --EP6FF
		   CY_PKTEND : out STD_LOGIC;
		   CY_FD : inout STD_LOGIC_VECTOR (15 downto 0));
end cyfifo;

--implement the state machine shown in the TRM
architecture Behavioral of cyfifo is
type state_type is (st1_type,
					st2_w_assert,st3_w_isfull,st4_w_write,st5_w_ismore,
					st2_r_assert,st3_r_read,st4_r_ismore);
signal state,next_state : state_type;

begin
		process (STATE_CLK,RESET)
		begin
				if(rising_edge(STATE_CLK)) then
						state <= next_state;
				end if;
		end process;

		IO : process(state,WRITE_STROBE,CY_FD,CY_FLAGC,USER_IN_DATA)
		begin
				case state is
						when st1_type =>
								CY_PKTEND <= '1';
								CY_SLOE <= '1';
								CY_SLWR <= '1';
								CY_SLRD <= '1';
								CY_FD <= "ZZZZZZZZZZZZZZZZ";
								DATAINT <= '0';

				--Write States
						when st2_w_assert =>
								CY_FIFOADDR <= "10"; --EP6
						when st4_w_write =>
								CY_FD <= USER_IN_DATA;
								CY_SLWR <= '0';
						when st5_w_ismore =>
								if(WRITE_STROBE = '0') then
										CY_PKTEND <= '0';
										CY_SLWR <= '1';
								end if;

				--Read states
						when st2_r_assert =>
								CY_FIFOADDR <= "00"; --EP2
								CY_SLOE <= '0';
								CY_SLRD <= '0';
						when st3_r_read =>
								USER_OUT_DATA <= CY_FD;
								DATAINT <= '1';
						when st4_r_ismore =>
								if(CY_FLAGC = '1') then
										CY_SLOE <= '1';
										CY_SLRD <= '1';
								end if;
						
						when others =>
				end case;
		end process;

		THINK : process(state,CLKIN,CY_FLAGC,CY_FLAGA,WRITE_STROBE)
		begin
				next_state <= state;
				case (state) is 
						when st1_type =>
								--Read or Write?
								if(CY_FLAGA = '1') then --if !EP2EF
										next_state <= st2_r_assert;
								elsif(WRITE_STROBE = '1') then
										next_state <= st2_w_assert;
								end if;

						--Write States
						when st2_w_assert =>
								next_state <= st3_w_isfull;
						when st3_w_isfull =>
								if(CY_FLAGC = '1') then --if !EP6FF
										next_state <= st4_w_write;
								end if;
						when st4_w_write =>
								if(CLKIN'event and CLKIN=  '1') then
										next_state <= st5_w_ismore;
								end if;
						when st5_w_ismore =>
								--if !EP2EF -- to avoid getting stuck in a write loop 
								--and never checking it again!
								if(WRITE_STROBE = '1') then
										if(CY_FLAGA = '1') then
												next_state <= st2_r_assert;
										else
												next_state <= st3_w_isfull;
										end if;
								else
										next_state <= st1_type;
								end if;
						
						--Read States
						when st2_r_assert =>
								next_state <= st3_r_read;
						when st3_r_read =>
								if(CLKIN'event and CLKIN = '1') then
										next_state <= st4_r_ismore;
								end if;
						when st4_r_ismore =>
								if(CY_FLAGA = '1') then --if !EP2EF
										next_state <= st2_r_assert;
								else
										next_state <= st1_type;
								end if;
						when others =>
								next_state <= st1_type;

				end case;
		end process;
end Behavioral;

