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
         reset : in std_logic;

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
    port (
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

           bitclk_p : out std_logic;
           bitclk_n : out std_logic;
           frameclk_p : out std_logic;
           frameclk_n : out std_logic;
           data_p : out std_logic_vector(3 downto 0);
           data_n : out std_logic_vector(3 downto 0)
         );
  end component;

  component adcbclk
    generic ( S : integer := 8 );
    port (
           bclk_p : in std_logic;
           bclk_n : in std_logic;

           reset : in std_logic;
           cal_en : in std_logic;
           cal_busy : out std_logic;

           rx_bitclk_p : out std_logic;
           rx_bitclk_n : out std_logic;
           rx_pktclk : out std_logic;
           rx_serdesstrobe : out std_logic
  );
  end component;

  signal bufg_bitclk_p, bufg_bitclk_n : std_logic;
  signal bufg_frameclk_p, bufg_frameclk_n : std_logic;
  signal bufg_data_p, bufg_data_n : std_logic_vector(3 downto 0);

  signal cal : std_logic := '0';
  signal cal_bclk_busy : std_logic;

  signal bclk_bitclk_p, bclk_bitclk_n : std_logic;
  signal bclk_pktclk, bclk_serdesstrobe : std_logic;
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

            bitclk_p => bufg_bitclk_p,
            bitclk_n => bufg_bitclk_n,
            frameclk_p => bufg_frameclk_p,
            frameclk_n => bufg_frameclk_n,
            data_p => bufg_data_p,
            data_n => bufg_data_n
          );

  Inst_adcbclk: adcbclk
  generic map ( S => 8 )
  port map (
            bclk_p => bufg_bitclk_p,
            bclk_n => bufg_bitclk_n,

            reset => reset,
            cal_en => cal,
            cal_busy => cal_bclk_busy,

            rx_bitclk_p => bclk_bitclk_p,
            rx_bitclk_n => bclk_bitclk_n,
            rx_pktclk => bclk_pktclk,
            rx_serdesstrobe => bclk_serdesstrobe
           );

end Behavioral;
