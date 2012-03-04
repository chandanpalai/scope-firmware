---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : adccal_tb.vhdl
--
-- Abstract    : Test bench for the ADC calibration module
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity adccal_tb is
---------------------------------------------------------------------------
end adccal_tb;


---------------------------------------------------------------------------
architecture Behavioral of adccal_tb is
---------------------------------------------------------------------------
  component adccal
    port (
          sys_rst : in std_logic;
          fsmclk  : in std_logic;

          reset        : out std_logic;
          cal_en       : out std_logic;
          cal_busy     : in std_logic;
          cal_slave_en : out std_logic
        );
  end component adccal;

  signal sys_rst, fsmclk : std_logic;
  signal reset, cal_en   : std_logic;
  signal cal_busy        : std_logic;
  signal cal_slave_en    : std_logic;
  signal busy_m, busy_s  : std_logic;

begin
  cal_busy <= busy_m or busy_s;

  Inst_adccal : adccal
  port map (
             sys_rst      => sys_rst,
             fsmclk       => fsmclk,
             reset        => reset,
             cal_en       => cal_en,
             cal_busy     => cal_busy,
             cal_slave_en => cal_slave_en
             );

  clk : process
  begin
    fsmclk <= '1';
    wait for 5 ns;
    fsmclk <= '0';
    wait for 5 ns;
  end process;

  cal_master : process
  begin
    busy_m <= '0';
    wait until cal_en <= '1';
    busy_m <= '1';
    wait for 100 ns;
    busy_m <= '0';
  end process;

  cal_slave : process
  begin
    busy_s <= '0';
    wait until cal_slave_en <= '1';
    busy_s <= '1';
    wait for 100 ns;
    busy_s <= '0';
  end process;

  tb : process
  begin
    sys_rst <= '1';
    wait for 10 ns;
    sys_rst <= '0';

    wait;
  end process;

end architecture Behavioral;

