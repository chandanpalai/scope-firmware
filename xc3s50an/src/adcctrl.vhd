--------------------------------------------------------------------------------
-- Engineer:       Ali Lown
--
-- Create Date:    19:44:57 06/22/2011
-- Module Name:    adcctrl - Behavioral
-- Project Name:   USB Digital Oscilloscope
-- Target Devices: xc3s50a(n)
-- Description:    Controls the ADC, and limits the datapath to the internals.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adcctrl is
  Port (
         CLK : in STD_LOGIC;

         DA : in STD_LOGIC_VECTOR (7 downto 0);
         DB : in STD_LOGIC_VECTOR (7 downto 0);
         PD : out STD_LOGIC;
         OE : out STD_LOGIC;
         SMPLCLK : out STD_LOGIC;

         ZZ : in STD_LOGIC;
         CFGCLK : in STD_LOGIC_VECTOR (7 downto 0);
         CFGCHNL : in STD_LOGIC_VECTOR (1 downto 0);

         DATA : out STD_LOGIC_VECTOR (15 downto 0);
         DATACLK : out STD_LOGIC
);
end adcctrl;

architecture Behavioral of adcctrl is
  signal iclk, maxclk : unsigned(31 downto 0) := TO_UNSIGNED(0,32);
  signal smplclk_out : STD_LOGIC := '0';
  signal en : STD_LOGIC := '1';

  signal e : STD_LOGIC_VECTOR(4 downto 0);
  signal f : STD_LOGIC_VECTOR(2 downto 0);
begin

  e <= CFGCLK(4 downto 0);
  f <= CFGCLK(7 downto 5);
  maxclk <= (TO_UNSIGNED(1,32) sll TO_INTEGER(unsigned(e))) + unsigned(f);

  process(CLK, iclk, maxclk, en, smplclk_out)
  begin
    if CLK = '1' and CLK'event and en = '1' then
      iclk <= iclk + 1;
      if iclk = maxclk then
        iclk <= TO_UNSIGNED(0, 32);
        smplclk_out <= not smplclk_out;
      end if;
    end if;
    SMPLCLK <= smplclk_out;
    DATACLK <= en and smplclk_out;
  end process;

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

  process(CFGCHNL, DA, DB)
  begin
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
  end process;
end Behavioral;
