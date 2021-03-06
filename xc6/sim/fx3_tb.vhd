---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : fx3_tb.vhd
--
-- Abstract    : Test bench for the fx3 module
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------------------------
entity fx3_tb is
---------------------------------------------------------------------------
end fx3_tb;


---------------------------------------------------------------------------
architecture Behavioral of fx3_tb is
---------------------------------------------------------------------------
  component fx3
    port (
          sys_rst : in std_logic;
          clk     : in std_logic;

        --FX3 interface
          slcs_n   : out std_logic;
          slwr_n   : out std_logic;
          sloe_n   : out std_logic;
          slrd_n   : out std_logic;
          flaga    : in std_logic;
          flagb    : in std_logic;
          pktend_n : out std_logic;
          fifoadr  : out std_logic_vector(1 downto 0);
          dq       : inout std_logic_vector(31 downto 0);

        --internal interface
          adcdata      : in std_logic_vector(63 downto 0);
          adcdataclk   : in std_logic;
          adcdataen    : in std_logic;
          adcdatafull  : out std_logic;
          adcdataempty : out std_logic;

          cfgin     : in std_logic_vector(15 downto 0);
          cfginen   : in std_logic;
          cfginclk  : in std_logic;
          cfgout    : out std_logic_vector(15 downto 0);
          cfgoutclk : out std_logic
        );
  end component fx3;

  signal fx3clk : std_logic := '0';
  signal adcclk : std_logic := '0';
  signal reset  : std_logic := '0';

  signal slcs, slwr, sloe, slrd : std_logic;
  signal flaga, flagb, pktend   : std_logic;

  signal fifoadr : std_logic_vector(1 downto 0);
  signal dq      : std_logic_vector(31 downto 0);

  signal adcdata   : std_logic_vector(63 downto 0) := (others => '0');
  signal adcdataen : std_logic := '0';

  signal cfgin, cfgout       : std_logic_vector(15 downto 0);
  signal cfgin_en, cfgin_clk : std_logic := '0';
  signal cfgoutclk           : std_logic := '0';
begin
  Inst_fx3 : fx3
  port map (
             sys_rst    => reset,
             clk        => fx3clk,
             slcs_n     => slcs,
             slwr_n     => slwr,
             sloe_n     => sloe,
             slrd_n     => slrd,
             flaga      => flaga,
             flagb      => flagb,
             pktend_n   => pktend,
             fifoadr    => fifoadr,
             dq         => dq,
             adcdata    => adcdata,
             adcdataclk => adcclk,
             adcdataen  => adcdataen,
             cfgin      => cfgin,
             cfginen    => cfgin_en,
             cfginclk   => cfgin_clk,
             cfgout     => cfgout,
             cfgoutclk  => cfgoutclk
             );

  clk_fx3 : process
  begin
    fx3clk <= not fx3clk;
    wait for 2.5 ns;
  end process;

  clk_adcclk : process
  begin
    adcclk <= not adcclk;
    wait for 2.5 ns;
  end process;

  clk_cfginclk : process
  begin
    cfgin_clk <= '0';
    wait for 2.1 ns;
    cfgin_clk <= '1';
    wait for 2.5 ns;
    cfgin_clk <= '0';
    wait for 0.4 ns;
  end process;

  fx3emu : process
  begin
    flaga <= '1'; --starts non-full
    flagb <= '0'; --starts empty
    reset <= '1';
    dq    <= (others => 'Z');
    wait for 100 ns;
    reset <= '0';

    wait for 20 us;

    --Send a config packet
    flagb <= '1';
    wait until fifoadr = "00";
    wait until slcs    = '0';
    wait until sloe    = '0';
    dq    <= (others => '0');
    wait until slrd    = '0';
    wait until fx3clk  = '1';
    dq    <= x"ABCDEF01";
    wait until fx3clk  = '1';
    wait until fx3clk  = '1';
    dq    <= x"01020304";
    wait until fx3clk  = '1';
    wait until fx3clk  = '1';
    dq    <= x"FFFEEE01";
    flagb <= '0';
    wait until slrd    = '1';
    dq    <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

    wait;
  end process;

  adc : process
    variable j : natural;
  begin
    wait for 500 ns;

    for i in 0 to 300 loop
      j := i * 45;
      adcdata(63 downto 32) <= not std_logic_vector(to_unsigned(j, 32));
      adcdata(31 downto 0) <= std_logic_vector(to_unsigned(j+1, 32));
      adcdataen <= '1';
      wait for 5 ns;
      adcdataen <= '0';
      wait for 5 ns;
    end loop;

    wait for 10 us;

    for i in 0 to 3000 loop
      j := i * 45;
      adcdata(63 downto 32) <= not std_logic_vector(to_unsigned(j, 32));
      adcdata(31 downto 0) <= std_logic_vector(to_unsigned(j+1, 32));
      adcdataen <= '1';
      wait for 5 ns;
      adcdataen <= '0';
      wait for 5 ns;
    end loop;

    wait;
  end process;

  cfg : process
  begin
    wait for 50 us;

    wait until cfgin_clk = '0';
    --Send a few config packets back
    cfgin    <= x"ABCD";
    cfgin_en <= '1';
    wait until cfgin_clk = '1';
    wait until cfgin_clk = '0';
    cfgin_en <= '0';

    cfgin    <= x"0123";
    cfgin_en <= '1';
    wait until cfgin_clk = '1';
    wait until cfgin_clk = '0';
    cfgin_en <= '0';

    cfgin    <= x"F00F";
    cfgin_en <= '1';
    wait until cfgin_clk = '1';
    wait until cfgin_clk = '0';
    cfgin_en <= '0';

    wait;
  end process;

end architecture Behavioral;

