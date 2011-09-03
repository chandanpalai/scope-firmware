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
         DATAINCLK : in  STD_LOGIC;

         RESET : in STD_LOGIC;
         CLKIF : in STD_LOGIC;

         ZZ : out  STD_LOGIC;
         CFGCLK : out  STD_LOGIC_VECTOR (7 downto 0);
         CFGCHNL : out  STD_LOGIC_VECTOR (1 downto 0);

         IADATAOUT : out STD_LOGIC_VECTOR(15 downto 0);
         IBDATAOUT : out STD_LOGIC_VECTOR(15 downto 0);
         IADATAOUTCLK : out STD_LOGIC;
         IBDATAOUTCLK : out STD_LOGIC;

         IADATAIN : out STD_LOGIC_VECTOR(15 downto 0);
         IBDATAIN : out STD_LOGIC_VECTOR(15 downto 0);
         IADATAINCLK : out STD_LOGIC;
         IBDATAINCLK : out STD_LOGIC
       );
end think;

architecture Behavioral of think is
  type state_type is (st0_magicdest, st1_regvalue);
  signal state : state_type;

  constant doutpacketmagic : std_logic_vector(7 downto 0) := x"A0";
  constant desthost   : std_logic_vector(7 downto 0) := x"01";
  constant destiba    : std_logic_vector(7 downto 0) := x"02";
  constant destibb    : std_logic_vector(7 downto 0) := x"04";

  constant reggcfg    : std_logic_vector(7 downto 0) := x"01";
  constant regcfgclk  : std_logic_vector(7 downto 0) := x"02";
  constant regcfgchnl : std_logic_vector(7 downto 0) := x"03";

  signal dest, reg, value : std_logic_vector(7 downto 0);
begin
  HOSTOUT: process(RESET, DATAIN, DATAINCLK)
  begin
    if RESET = '1' then
      state <= st0_magicdest;
      ZZ <= '1';
      CFGCLK <= "00000000";
      CFGCHNL <= "00";
      IADATAOUT <= x"0000";
      IADATAOUTCLK <= '0';
      IBDATAOUT <= x"0000";
      IBDATAOUTCLK <= '0';

      dest <= x"00";
      reg <= x"00";
      value <= x"00";
    else
      --Use falling edge to let data settle
      if DATAINCLK'event and DATAINCLK = '0' then
        case state is
          when st0_magicdest =>
            IADATAOUTCLK <= '0';
            IBDATAOUTCLK <= '0';

            if DATAIN(7 downto 0) = doutpacketmagic then
              dest <= DATAIN(15 downto 8);
              state <= st1_regvalue;
            end if;
          when st1_regvalue =>
            reg <= DATAIN(7 downto 0);
            value <= DATAIN(15 downto 8);

            case dest is
              when desthost =>
                --parse packet
                case reg is
                  when reggcfg =>
                    ZZ <= value(0);
                  when regcfgclk =>
                    CFGCLK <= value;
                  when regcfgchnl =>
                    CFGCHNL <= value(1 downto 0);
                  when others =>
                end case;
              when destiba =>
              --send on packet
                IADATAOUT(7 downto 0) <= reg;
                IADATAOUT(15 downto 8) <= value;
                IADATAOUTCLK <= '1';
              when destibb =>
              --send on packet
                IBDATAOUT(7 downto 0) <= reg;
                IBDATAOUT(15 downto 8) <= value;
                IADATAOUTCLK <= '0';
              when others =>
          --ignore packet
            end case;
            state <= st0_magicdest;
        end case;
      end if;
    end if;
  end process;
end Behavioral;
