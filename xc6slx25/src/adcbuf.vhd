--------------------------------------------------------------------------------
-- Engineer:       Ali Lown
--
-- Module Name:    adcbuf - Behavioral
-- Project Name:   USB Digital Oscilloscope
-- Target Devices: xc6slx25
-- Description:    Instantiates differential buffers for the ADC lines
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

entity adcbuf is
  port (
         bclk_p : in std_logic;
         bclk_n : in std_logic;
         fclk_p : in std_logic;
         fclk_n : in std_logic;

         d1a_p : in std_logic;
         d1a_n : in std_logic;
         d1b_p : in std_logic;
         d1b_n : in std_logic;
         d2a_p : in std_logic;
         d2a_n : in std_logic;
         d2b_p : in std_logic;
         d2b_n : in std_logic;
         d3a_p : in std_logic;
         d3a_n : in std_logic;
         d3b_p : in std_logic;
         d3b_n : in std_logic;
         d4a_p : in std_logic;
         d4a_n : in std_logic;
         d4b_p : in std_logic;
         d4b_n : in std_logic;

         bitclk_p : out std_logic;
         bitclk_n : out std_logic;
         frameclk_p : out std_logic;
         frameclk_n : out std_logic;
         data_a_p : out std_logic_vector(3 downto 0);
         data_a_n : out std_logic_vector(3 downto 0);
         data_b_p : out std_logic_vector(3 downto 0);
         data_b_n : out std_logic_vector(3 downto 0)
       );
end adcbuf;

architecture Behavioral of adcbuf is
begin
  bclk_bufds : IBUFDS_DIFF_OUT
  generic map (DIFF_TERM => TRUE, IOSTANDARD => "LVDS_33")
  port map (I => bclk_p, IB => bclk_n, O => bitclk_p, OB => bitclk_n);

  fclk_bufds : IBUFDS_DIFF_OUT
  generic map (DIFF_TERM => TRUE, IOSTANDARD => "LVDS_33")
  port map (I => fclk_p, IB => fclk_n, O => frameclk_p, OB => frameclk_n);

  d1a_bufds : IBUFDS_DIFF_OUT
  generic map (DIFF_TERM => TRUE, IOSTANDARD => "LVDS_33")
  port map (I => d1a_p, IB => d1a_n, O => data_a_p(0), OB => data_a_n(0));
  d2a_bufds : IBUFDS_DIFF_OUT
  generic map (DIFF_TERM => TRUE, IOSTANDARD => "LVDS_33")
  port map (I => d2a_p, IB => d2a_n, O => data_a_p(1), OB => data_a_n(1));
  d3a_bufds : IBUFDS_DIFF_OUT
  generic map (DIFF_TERM => TRUE, IOSTANDARD => "LVDS_33")
  port map (I => d3a_p, IB => d3a_n, O => data_a_p(2), OB => data_a_n(2));
  d4a_bufds : IBUFDS_DIFF_OUT
  generic map (DIFF_TERM => TRUE, IOSTANDARD => "LVDS_33")
  port map (I => d4a_p, IB => d4a_n, O => data_a_p(3), OB => data_a_n(3));
  d1b_bufds : IBUFDS_DIFF_OUT
  generic map (DIFF_TERM => TRUE, IOSTANDARD => "LVDS_33")
  port map (I => d1b_p, IB => d1b_n, O => data_b_p(0), OB => data_b_n(0));
  d2b_bufds : IBUFDS_DIFF_OUT
  generic map (DIFF_TERM => TRUE, IOSTANDARD => "LVDS_33")
  port map (I => d2b_p, IB => d2b_n, O => data_b_p(1), OB => data_b_n(1));
  d3b_bufds : IBUFDS_DIFF_OUT
  generic map (DIFF_TERM => TRUE, IOSTANDARD => "LVDS_33")
  port map (I => d3b_p, IB => d3b_n, O => data_b_p(2), OB => data_b_n(2));
  d4b_bufds : IBUFDS_DIFF_OUT
  generic map (DIFF_TERM => TRUE, IOSTANDARD => "LVDS_33")
  port map (I => d4b_p, IB => d4b_n, O => data_b_p(3), OB => data_b_n(3));
end Behavioral;
