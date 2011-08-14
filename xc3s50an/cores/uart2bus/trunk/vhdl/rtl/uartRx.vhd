-----------------------------------------------------------------------------------------
-- uart receive module  
--
-----------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity uartRx is
  port ( clr       : in  std_logic;                    -- global reset input
         clk       : in  std_logic;                    -- global clock input
         ce16      : in  std_logic;                    -- baud rate multiplyed by 16 - generated by baud module
         serIn     : in  std_logic;                    -- serial data input
         rxData    : out std_logic_vector(7 downto 0); -- data byte received
         newRxData : out std_logic);                   -- signs that a new byte was received
end uartRx;

architecture Behavioral of uartRx is

  signal ce1      : std_logic;                    -- clock enable at bit rate
  signal ce1Mid   : std_logic;                    -- clock enable at the middle of each bit - used to sample data
  signal inSync   : std_logic_vector(1 downto 0);
  signal count16  : std_logic_vector(3 downto 0);
  signal rxBusy   : std_logic;
  signal bitCount : std_logic_vector(3 downto 0);
  signal dataBuf  : std_logic_vector(7 downto 0);

  begin
    -- input async input is sampled twice
    process (clr, clk)
    begin
      if (clr = '1') then
        inSync <= (others => '1');
      elsif (rising_edge(clk)) then
        inSync <= inSync(0) & serIn;
      end if;
    end process;
    -- a counter to count 16 pulses of ce_16 to generate the ce_1 and ce_1_mid pulses.
    -- this counter is used to detect the start bit while the receiver is not receiving and
    -- signs the sampling cycle during reception.
    process (clr, clk)
    begin
      if (clr = '1') then
        count16 <= (others => '0');
      elsif (rising_edge(clk)) then
        if (ce16 = '1') then
          if ((rxBusy = '1') or (inSync(1) = '0')) then
            count16 <= count16 + 1;
          else
            count16 <= (others => '0');
          end if;
        end if;
      end if;
    end process;
    -- receiving busy flag
    process (clr, clk)
    begin
      if (clr = '1') then
        rxBusy <= '0';
      elsif (rising_edge(clk)) then
        if ((rxBusy = '0') and (ce1Mid = '1')) then
          rxBusy <= '1';
        elsif ((rxBusy = '1') and (bitCount = "1001") and (ce1 = '1')) then
          rxBusy <= '0';
        end if;
      end if;
    end process;
    -- bit counter
    process (clr, clk)
    begin
      if (clr = '1') then
        bitCount <= (others => '0');
      elsif (rising_edge(clk)) then
        if (rxBusy = '0') then
          bitCount <= (others => '0');
        elsif ((rxBusy = '1') and (ce1Mid = '1')) then
          bitCount <= bitCount + 1;
        end if;
      end if;
    end process;
    -- data buffer shift register
    process (clr, clk)
    begin
      if (clr = '1') then
        dataBuf <= (others => '0');
      elsif (rising_edge(clk)) then
        if ((rxBusy = '1') and (ce1Mid = '1')) then
          dataBuf <= inSync(1) & dataBuf(7 downto 1);
        end if;
      end if;
    end process;
    -- data output and flag
    process (clr, clk)
    begin
      if (clr = '1') then
        rxData <= (others => '0');
        newRxData <= '0';
      elsif (rising_edge(clk)) then
        if ((rxBusy = '1') and (bitCount = "1000") and (ce1 = '1')) then
          rxData <= dataBuf;
          newRxData <= '1';
        else
          newRxData <= '0';
        end if;
      end if;
    end process;
    -- ce_1 pulse indicating expected end of current bit
    ce1 <= '1' when ((count16 = "1111") and (ce16 = '1')) else '0';
    -- ce_1_mid pulse indication the sampling clock cycle of the current data bit
    ce1Mid <= '1' when ((count16 = "0111") and (ce16 = '1')) else '0';
  end Behavioral;
