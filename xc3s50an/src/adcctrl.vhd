--------------------------------------------------------------------------------
-- EngINeer:       Ali Lown
--
-- Create Date:    19:44:57 06/22/2011
-- Module Name:    adcctrl - Behavioral
-- Project Name:   USB Digital Oscilloscope
-- Target Devices: xc3s50a(n)
-- Description:    Controls the ADC, and limits the datapath to the INternals.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity adcctrl is
  Port (
         RESET : IN std_logic;
         CLK : IN std_logic;

         DA : IN std_logic_vector (7 downto 0);
         DB : IN std_logic_vector (7 downto 0);
         PD : OUT std_logic;
         OE : OUT std_logic;
         SMPLCLK : OUT std_logic;

         PKTOUT : IN std_logic_vector(15 downto 0);
         PKTOUTCLK : IN std_logic;

         DATA : OUT std_logic_vector (15 downto 0);
         DATACLK : OUT std_logic
       );
end adcctrl;

architecture Behavioral of adcctrl is
  signal iclk : std_logic_vector(15 downto 0) := x"0000";
  signal smplclk_OUT : std_logic := '0';
  signal en : std_logic := '0';

  constant CONST_REG_PD   : std_logic_vector(6 downto 0) := "0000001";
  constant CONST_REG_CLKL : std_logic_vector(6 downto 0) := "0000010";
  constant CONST_REG_CLKH : std_logic_vector(6 downto 0) := "0000011";
  constant CONST_REG_CHNL : std_logic_vector(6 downto 0) := "0000100";

  signal reg_zz : std_logic;
  signal reg_clk : std_logic_vector(15 downto 0);
  signal reg_chnl : std_logic_vector(1 downto 0);
begin

  process(CLK, iclk, en, smplclk_OUT)
  begin
    if CLK = '1' and CLK'event and en = '1' then
      iclk <= iclk + '1';
      if iclk = reg_clk then
        iclk <= x"0000";
        smplclk_OUT <= not smplclk_OUT;
      end if;
    end if;
    SMPLCLK <= smplclk_OUT;
    DATACLK <= en and smplclk_OUT;
  end process;

  process(reg_zz)
  begin
    if reg_zz = '1' then
      PD <= '1';
      OE <= '1';
    else
      PD <= '0';
      OE <= '0';
    end if;
    en <= not reg_zz;
  end process;

  process(reg_chnl, DA, DB)
  begin
    if reg_chnl(0) = '1' then
      DATA(7 downto 0) <= DA;
    else
      DATA(7 downto 0) <= "00000000";
    end if;
    if reg_chnl(1) = '1' then
      DATA(15 downto 8) <= DB;
    else
      DATA(15 downto 8) <= "00000000";
    end if;
  end process;

  HOSTOUT: process(RESET, PKTOUTCLK, PKTOUT)
  begin
    if RESET = '1' then
      reg_zz <= '1';
      reg_clk <= x"0000";
      reg_chnl <= "00";
    else
      if PKTOUTCLK'event and PKTOUTCLK = '1' then
        case PKTOUT(7 downto 1) is
          when CONST_REG_PD =>
            reg_zz <= PKTOUT(8);
          when CONST_REG_CLKL =>
            reg_clk(7 downto 0) <= PKTOUT(15 downto 8);
          when CONST_REG_CLKH =>
            reg_clk(15 downto 8) <= PKTOUT(15 downto 8);
          when CONST_REG_CHNL =>
            reg_chnl <= PKTOUT(9 downto 8);
          when others =>
        end case;
      end if;
    end if;
  end process;
end Behavioral;
