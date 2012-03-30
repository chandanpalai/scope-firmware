---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : think.vhd
--
-- Abstract    : Central command system for the scope
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------------------------
entity think is
---------------------------------------------------------------------------
port
(
  sys_rst : in std_logic;
  clk     : in std_logic;

  --FX3 interface
  cfgout    : in std_logic_vector(31 downto 0);
  cfgoutclk : in std_logic;
  cfgin     : out std_logic_vector(31 downto 0);
  cfginclk  : out std_logic;

  --Configuration Bus
  cfgbusout    : out std_logic;
  cfgbusoutclk : out std_logic;
  cfgbusin     : in std_logic_vector(15 downto 0);
  cfgbusinclk  : in std_logic;
  cfgbusinbusy : in std_logic
);
end think;

---------------------------------------------------------------------------
architecture Behavioral of think is
---------------------------------------------------------------------------

  type state_type is (st0_default, st1_fifoout);
  signal cfgout_state : state_type;

  signal cfgoutbuf       : std_logic_vector(31 downto 0);
  signal cfgoutbufclk    : std_logic;
  signal cfgoutbuf_empty : std_logic;
  signal cfgoutbuf_full  : std_logic;
  signal cfgoutshift_en  : std_logic;
  signal cfgoutreg       : std_logic_vector(15 downto 0);

  signal fsmclk : std_logic := '1';
begin

  --Divide clk by 16 to get the speed for the fsm
  clkdiv : process(clk, sys_rst)
    variable count : unsigned(3 downto 0);
  begin
    if clk'event and clk = '1' then
      if sys_rst = '1' then
        count := TO_UNSIGNED(0, 4);
      else
        count := count + 1;
        if count = 0 then
          fsmclk <= not fsmclk;
        end if;
      end if;
    end if;
  end process;

  --CFG out section
  Inst_cfgoutbuf32 : cfgbuf32
  port map (
             rst    => sys_rst,
             wr_clk => clk,
             rd_clk => clk,
             din    => cfgout,
             wr_en  => cfgoutclk,
             rd_en  => cfgoutbufclk,
             dout   => cfgoutbuf,
             empty  => cfgoutbuf_empty,
             full   => cfgoutbuf_full
             );

  outproc : process(fsmclk, sys_rst)
  begin
    if fsmclk'event and fsmclk = '1' then
      if sys_rst = '1' then
        cfgout_state   <= st0_default;
        cfgoutshift_en <= '0';
      end if;
    else
      case cfgout_state is
        when st0_default =>
          cfgoutshift_en <= '0';
          cfgoutbufclk   <= '0';
          if cfgoutbuf_empty = '0' then
            cfgout_state <= st1_fifoout;
            cfgoutbufclk <= '1';
          end if;
        when st1_fifoout =>
          cfgoutshift_en <= '1';
          cfgout_state   <= st0_default;
          cfgoutbufclk   <= '0';
      end case;
    end if;
  end process;

  cfgbusout <= cfgoutreg(15);
  cfgoutshift : process(clk, sys_rst, cfgoutshift_en)
  begin
    if clk'event and clk = '1' then
      if cfgoutshift_en = '1' then
        cfgoutreg <= cfgoutreg(14 downto 0) & '0';
      end if;
    end if;
  end process;

end architecture Behavioral;

