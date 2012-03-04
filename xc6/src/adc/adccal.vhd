---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : adccal.vhdl
--
-- Abstract    : FSM to perform calibration tasks at regular intervals
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

---------------------------------------------------------------------------
entity adccal is
---------------------------------------------------------------------------
  port
  (
    sys_rst      : in std_logic;
    fsmclk       : in std_logic;

    reset        : out std_logic;
    cal_en       : out std_logic;
    cal_busy     : in std_logic;
    cal_slave_en : out std_logic
  );
end adccal;


---------------------------------------------------------------------------
architecture Behavioral of adccal is
---------------------------------------------------------------------------
  type state_type is (st0_initcal, st1_reset, st2_wait, st3_slave_loop,
                      st4_slave_cal, st5_slave_wait);
  signal state : state_type;
  signal count : natural := 0;
begin
  cal : process (sys_rst, fsmclk, cal_busy)
  begin
    if sys_rst = '1' then
      reset        <= '0';
      cal_en       <= '0';
      cal_slave_en <= '0';
      count        <= 0;
    else
      if fsmclk'event and fsmclk = '1' then
        case state is
          when st0_initcal =>
            cal_en       <= '1';
            cal_slave_en <= '1';
            state        <= st1_reset;
          when st1_reset =>
            cal_en       <= '0';
            cal_slave_en <= '0';
            reset        <= '1';
            state        <= st2_wait;
          when st2_wait =>
            reset <= '0';
            if cal_busy = '0' then
              state <= st3_slave_loop;
            end if;
          when st3_slave_loop =>
            count <= count + 1;
            if count = 1000 then
              count <= 0;
              state <= st4_slave_cal;
            end if;
          when st4_slave_cal =>
            cal_slave_en <= '1';
            state <= st5_slave_wait;
          when st5_slave_wait =>
            cal_slave_en <= '0';
            if cal_busy = '0' then
              state <= st3_slave_loop;
            end if;
          when others =>
            state <= st0_initcal;
        end case;
      end if;
    end if;
  end process;

end architecture Behavioral;
