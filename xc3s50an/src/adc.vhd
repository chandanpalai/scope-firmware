--------------------------------------------------------------------------------
-- Engineer:       Ali Lown
--
-- Create Date:    19:44:57 06/22/2011
-- Module Name:    adc - Behavioral
-- Project Name:   USB Digital Oscilloscope
-- Target Devices: xc3s50a(n)
-- Description:    Controls the ADC, and limits the datapath to the internals.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adc is
  Port ( DA : in  STD_LOGIC_VECTOR (7 downto 0);
         DB : in  STD_LOGIC_VECTOR (7 downto 0);
         DATA : out  STD_LOGIC_VECTOR (15 downto 0);
         DATACLK : out STD_LOGIC;

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
  process(CLKM, CFGCLK, en, smplclk)
  begin
    if CLKM = '1' and CLKM'event and en = '1' then
      iclk <= std_logic_vector(unsigned(iclk) + 1);
      if iclk = CFGCLK then
        iclk <= "00000000";
        smplclk <= not smplclk;
      end if;
    end if;
    CLKSMPL <= smplclk;
    DATACLK <= en and smplclk;
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

  DATA(7 downto 0) <= DA;
  DATA(15 downto 8) <= DB;
end Behavioral;
