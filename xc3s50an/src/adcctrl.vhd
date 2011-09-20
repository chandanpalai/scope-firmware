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
  signal iclk : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
  signal smplclk_out : STD_LOGIC := '0';
  signal en : STD_LOGIC := '1';
begin
  process(CLK, CFGCLK, en, smplclk_out)
  begin
    if CLK = '1' and CLK'event and en = '1' then
      iclk <= std_logic_vector(unsigned(iclk) + 1);
      if iclk = CFGCLK then
        iclk <= "00000000";
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
