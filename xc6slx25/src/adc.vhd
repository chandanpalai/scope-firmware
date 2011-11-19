--------------------------------------------------------------------------------
-- Engineer:       Ali Lown
--
-- Module Name:    adc - Behavioral
-- Project Name:   USB Digital Oscilloscope
-- Target Devices: xc6slx25
-- Description:    Top-level module for the ADC section
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adc is
  Port (
         --ADC interface
         sdata : out std_logic;
         sclk : out std_logic;

         bclk_p : in std_logic;
         bclk_n : in std_logic;
         fclk_p : in std_logic;
         fclk_n : in std_logic;

         d1a_p : in std_logic;
         d1a_n : in std_logic;
         d2a_p : in std_logic;
         d2a_n : in std_logic;
         d3a_p : in std_logic;
         d3a_n : in std_logic;
         d4a_p : in std_logic;
         d4a_n : in std_logic;

         --PLL interface
         pll_data : out std_logic;
         pll_clk : out std_logic;
         pll_le : out std_logic;

         --Internal (think) interface
         pktoutadc : in std_logic_vector(15 downto 0);
         pktoutadcclk : in std_logic;
         pktinadc : out std_logic_vector(15 downto 0);
         pktinadcclk : out std_logic
       );
end adc;

architecture Behavioral of adc is
  component adcbuf
    Port (
           bclk_p : in std_logic;
           bclk_n : in std_logic;
           fclk_p : in std_logic;
           fclk_n : in std_logic;

           d1a_p : in std_logic;
           d1a_n : in std_logic;
           d2a_p : in std_logic;
           d2a_n : in std_logic;
           d3a_p : in std_logic;
           d3a_n : in std_logic;
           d4a_p : in std_logic;
           d4a_n : in std_logic;

           bitclk : out std_logic;
           frameclk_p : out std_logic;
           frameclk_n : out std_logic;
           data_p : out std_logic_vector(3 downto 0);
           data_n : out std_logic_vector(3 downto 0)
         );
  end component;

  signal bitclk : std_logic;
  signal frameclk_p, frameclk_n : std_logic;
  signal data_p, data_n : std_logic_vector(3 downto 0);
begin
  Inst_adcbuf: adcbuf
  port map(
            bclk_p => bclk_p,
            bclk_n => bclk_n,
            fclk_p => fclk_p,
            fclk_n => fclk_n,

            d1a_p => d1a_p,
            d1a_n => d1a_n,
            d2a_p => d2a_p,
            d2a_n => d2a_n,
            d3a_p => d3a_p,
            d3a_n => d3a_n,
            d4a_p => d4a_p,
            d4a_n => d4a_n,

            bitclk => bitclk,
            frameclk_p => frameclk_p,
            frameclk_n => frameclk_n,
            data_p => data_p,
            data_n => data_n
          );

end Behavioral;

