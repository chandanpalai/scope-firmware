--------------------------------------------------------------------------------
-- Engineer:       Ali Lown
--
-- Create Date:    21:17:29 06/23/2011
-- Module Name:    think - Behavioral
-- Project Name:   USB Digital Oscilloscope
-- Target Devices: xc3s50a(n)
-- Description:    Handles controlling the other modules, and parsing the
--                 computer's instructions.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity think is
  Port ( DATAIN : in  STD_LOGIC_VECTOR (15 downto 0);
         DATACLK : in  STD_LOGIC;

         RESET : in STD_LOGIC;
         CLKIF : in STD_LOGIC;

         ZZ : out  STD_LOGIC;
         CFGCLK : out  STD_LOGIC_VECTOR (7 downto 0);
         CFGCHNL : out  STD_LOGIC_VECTOR (1 downto 0);

         CFGIBA : out STD_LOGIC_VECTOR(15 downto 0);
         CFGIBB : out STD_LOGIC_VECTOR(15 downto 0);
         SAVEA : out STD_LOGIC;
         SAVEB : out STD_LOGIC);
end think;

architecture Behavioral of think is
  type state_type is (st0_magic, st1_data, st2_chk);
  signal state : state_type;


  signal dataout : std_logic_vector(15 downto 0);
begin
  FSM: process(RESET,DATAIN,DATACLK)
  begin
    if RESET = '1' then
      state <= st0_magic;
      ZZ <= '1';
      CFGCLK <= "00000000";
      CFGCHNL <= "00";
      CFGIBA <= x"0000";
      CFGIBB <= x"0000";
      dataout <= x"0000";
    else
      --Use falling edge to let data settle
      if DATACLK'event and DATACLK = '0' then
        case state is
          when st0_magic =>
            if DATAIN = x"3c2c" then --hw fault
              state <= st1_data;
            end if;
          when st1_data =>
            dataout <= DATAIN;
            state <= st2_chk;
          when st2_chk =>
            if DATAIN = x"aae0" then
              ZZ <= dataout(15);
              CFGCHNL <= dataout(9 downto 8);
              CFGCLK <= dataout(7 downto 0);
            elsif DATAIN = x"aae1" then
              CFGIBA <= dataout;
            elsif DATAIN = x"aae2" then
              CFGIBB <= dataout;
            end if;
            state <= st0_magic;
        end case;
      end if;
    end if;
  end process;
end Behavioral;
