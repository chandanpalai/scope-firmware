--------------------------------------------------------------------------------
-- Engineer:       Ali Lown
--
-- Module Name:    adcbclk - Behavioral
-- Project Name:   USB Digital Oscilloscope
-- Target Devices: xc6slx25
-- Description:    Recovers the ADC bit clock.
--                 Based on XAPP1064: serdes_1_to_n_clk_ddr_s8_diff
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

entity adcbclk is
  generic ( S : integer := 8 ); --SERDES factor
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
end adcbclk;

architecture Behavioral of adcbclk is
  signal delay_m, delay_s : std_logic;
  signal dlym_busy, dlys_busy : std_logic;

begin

  cal_busy <= dlym_busy or dlys_busy;

  Inst_iodelay_m : IODELAY2
  generic map (
                DATA_RATE => "SDR",
                SIM_TAPDELAY_VALUE => 49,
                IDELAY_VALUE => 0,
                IDELAY2_VALUE => 0,
                ODELAY_VALUE => 0,
                IDELAY_MODE => "NORMAL",
                SERDES_MODE => "MASTER",
                IDELAY_TYPE => "FIXED",
                COUNTER_WRAPAROUND => "STAY_AT_LIMIT",
                DELAY_SRC => "IDATAIN"
              )
  port map (
             IDATAIN => bclk_p,
             TOUT => open,
             DOUT => open,
             T => '1',
             ODATAIN => '0',
             DATAOUT => delay_m,
             DATAOUT2 => open,
             IOCLK0 => '0',
             IOCLK1 => '0',
             CLK => '0',
             CAL => cal_en,
             INC => '0',
             CE => '0',
             RST => reset,
             BUSY => dlym_busy
           );

  Inst_iodelay_s : IODELAY2
  generic map (
                DATA_RATE => "SDR",
                SIM_TAPDELAY_VALUE => 49,
                IDELAY_VALUE => 0,
                IDELAY2_VALUE => 0,
                ODELAY_VALUE => 0,
                IDELAY_MODE => "NORMAL",
                SERDES_MODE => "SLAVE",
                IDELAY_TYPE => "FIXED",
                COUNTER_WRAPAROUND => "STAY_AT_LIMIT",
                DELAY_SRC => "IDATAIN"
              )
  port map (
             IDATAIN => bclk_n,
             TOUT => open,
             DOUT => open,
             T => '1',
             ODATAIN => '0',
             DATAOUT => delay_s,
             DATAOUT2 => open,
             IOCLK0 => '0',
             IOCLK1 => '0',
             CLK => '0',
             CAL => cal_en,
             INC => '0',
             CE => '0',
             RST => reset,
             BUSY => dlys_busy
           );

  bufio2_2clk_inst : BUFIO2_2CLK
  generic map (
                DIVIDE => S
              )
  port map (
             I => delay_m,
             IB => delay_s,
             IOCLK => rx_bitclk_p,
             DIVCLK => rx_pktclk,
             SERDESSTROBE => rx_serdesstrobe
           );

  bufio2_inst : BUFIO2
  generic map (
                I_INVERT => FALSE,
                DIVIDE_BYPASS => FALSE,
                USE_DOUBLER => FALSE
              )
  port map (
             I => delay_s,
             IOCLK => rx_bitclk_n,
             DIVCLK => open,
             SERDESSTROBE => open
           );

end Behavioral;
