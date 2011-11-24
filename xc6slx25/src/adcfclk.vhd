--------------------------------------------------------------------------------
-- Engineer:       Ali Lown
--
-- Module Name:    adfbclk - Behavioral
-- Project Name:   USB Digital Oscilloscope
-- Target Devices: xc6slx25
-- Description:    Recovers the ADC frame clock.
--                 Based 'losely' on XAPP1071
--                 and XAPP1064 serdes_1_to_n_data_ddr_s8_diff
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

entity adcfclk is
  generic (S : integer := 8 ); --SERDES factor
  port (
         fclk_p : in std_logic;
         fclk_n : in std_logic;

         bitclk_p : in std_logic;
         bitclk_n : in std_logic;
         serdesstrobe : in std_logic;
         pktclk : in std_logic;

         reset : in std_logic;
         cal_en : in std_logic;
         cal_busy : out std_logic;

         delay_inc : out std_logic;
         serdes_incdec : out std_logic;

         rx_fclk : out std_logic
       );
end adcfclk;

architecture Behavioral of adcfclk is
  signal delay_m, delay_s : std_logic;
  signal dlym_busy, dlys_busy : std_logic;
  signal pd_edge, cascade : std_logic;
  signal bitslip : std_logic;
  signal frame_data : std_logic_vector(S-1 downto 0);
  signal is_valid : std_logic;
  signal delay_inc_int, serdes_incdec_int : std_logic;
  signal pktclk_en : std_logic;

  type state_type is (st0_idle);
  signal state : state_type;

begin

  cal_busy <= dlym_busy or dlys_busy;
  delay_inc <= delay_inc_int;
  serdes_incdec <= serdes_incdec_int;

  Inst_iodelay_m : IODELAY2
  generic map (
                DATA_RATE => "DDR",
                IDELAY_VALUE => 0,
                IDELAY2_VALUE => 0,
                IDELAY_MODE => "NORMAL",
                ODELAY_VALUE => 0,
                IDELAY_TYPE => "DIFF_PHASE_DETECTOR",
                COUNTER_WRAPAROUND => "WRAPAROUND",
                DELAY_SRC => "IDATAIN",
                SERDES_MODE => "MASTER",
                SIM_TAPDELAY_VALUE => 49
              )
  port map (
             IDATAIN => fclk_p,
             TOUT => open,
             DOUT => open,
             T => '1',
             ODATAIN => '0',
             DATAOUT  => delay_m,
             DATAOUT2 => open,
             IOCLK0 => bitclk_p,
             IOCLK1 => bitclk_n,
             CLK => pktclk,
             CAL => cal_en,
             INC => delay_inc_int,
             CE => pktclk_en,
             RST => reset,
             BUSY => dlym_busy
           );

  Inst_iodelay_s : IODELAY2
  generic map (
                DATA_RATE => "DDR",
                IDELAY_VALUE => 0,
                IDELAY2_VALUE => 0,
                IDELAY_MODE => "NORMAL",
                ODELAY_VALUE => 0,
                IDELAY_TYPE => "DIFF_PHASE_DETECTOR",
                COUNTER_WRAPAROUND => "WRAPAROUND",
                DELAY_SRC => "IDATAIN",
                SERDES_MODE => "SLAVE",
                SIM_TAPDELAY_VALUE => 49
              )
  port map (
             IDATAIN => fclk_n,
             TOUT => open,
             DOUT => open,
             T => '1',
             ODATAIN => '0',
             DATAOUT => delay_s,
             DATAOUT2 => open,
             IOCLK0 => bitclk_p,
             IOCLK1 => bitclk_n,
             CLK => pktclk,
             CAL => cal_en,
             INC => delay_inc_int,
             CE => pktclk_en,
             RST => reset,
             BUSY => dlys_busy
           );

  Inst_iserdes_m : ISERDES2
  generic map (
                DATA_WIDTH => S,
                DATA_RATE => "DDR",
                BITSLIP_ENABLE => TRUE,
                SERDES_MODE => "MASTER",
                INTERFACE_TYPE => "RETIMED"
              )
  port map (
             D => delay_m,
             CE0 => '1',
             CLK0 => bitclk_p,
             CLK1 => bitclk_n,
             IOCE => serdesstrobe,
             RST => reset,
             CLKDIV => pktclk,
             SHIFTIN => pd_edge,
             BITSLIP => bitslip,
             FABRICOUT => open,
             Q4 => frame_data(7),
             Q3 => frame_data(6),
             Q2 => frame_data(5),
             Q1 => frame_Data(4),
             DFB => open,
             CFB0 => open,
             CFB1 => open,
             VALID => is_valid,
             INCDEC => serdes_incdec_int,
             SHIFTOUT => cascade
           );

  Inst_iserdes_s : ISERDES2
  generic map (
                DATA_WIDTH => S,
                DATA_RATE => "DDR",
                BITSLIP_ENABLE => TRUE,
                SERDES_MODE => "SLAVE",
                INTERFACE_TYPE => "RETIMED"
              )
  port map (
             D => delay_s,
             CE0 => '1',
             CLK0 => bitclk_p,
             CLK1 => bitclk_n,
             IOCE => serdesstrobe,
             RST => reset,
             CLKDIV => pktclk,
             SHIFTIN => cascade,
             BITSLIP => bitslip,
             FABRICOUT => open,
             Q4 => frame_data(3),
             Q3 => frame_data(2),
             Q2 => frame_data(1),
             Q1 => frame_data(0),
             DFB => open,
             CFB0 => open,
             CFB1 => open,
             VALID => open,
             INCDEC => open,
             SHIFTOUT => pd_edge
           );

  ALIGN : process (reset, pktclk, frame_data)
  begin
    if reset = '1' then
      state <= st0_idle;
    else
      if pktclk'event and pktclk = '1' then
        case state is
          when st0_idle =>
            --TODO: fill in the rest of the calibration logic
        end case;
      end if;
    end if;
  end process;

end Behavioral;
