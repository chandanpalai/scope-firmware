--------------------------------------------------------------------------------
-- Engineer:       Ali Lown
--
-- Create Date:    19:38:54 08/14/2011
-- Module Name:    inputBoard - Behavioral
-- Project Name:   USB Digital Oscilloscope
-- Target Devices: xc3s50a(n)
-- Description:    Handles communications to/from the input boards uC's.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pkt32fifo is
  Port ( DATAIN : in STD_LOGIC_VECTOR(31 downto 0);
         WRCLK : in STD_LOGIC;
         DATAOUT : out STD_LOGIC_VECTOR(31 downto 0);
         RDCLK : in STD_LOGIC;
         FULL : out STD_LOGIC;
         EMPTY : out STD_LOGIC;
         RESET : in STD_LOGIC
       );
end pkt32fifo;

architecture Behavioral of pkt32fifo is

  constant maxpos : integer := 4;
  signal wrpos, rdpos : integer range 0 to maxpos := 0;
  type data_type is array(maxpos downto 0) of std_logic_vector(31 downto 0);
  signal data : data_type;
  signal full_out, empty_out : std_logic;
  signal wrreset : std_logic;
begin
  FLAGS: process (RESET, wrpos, rdpos)
  begin
    if RESET = '1' then
      empty_out <= '1';
      full_out <= '0';
    end if;

    if wrpos = 0 then
      empty_out <= '1';
    else
      empty_out <= '0';
    end if;

    if wrpos = maxpos then
      full_out <= '1';
    else
      full_out <= '0';
    end if;
  end process;

  EMPTY <= empty_out;
  FULL <= full_out;

  WRITE: process (RESET, DATAIN, WRCLK, wrpos, full_out, wrreset)
  begin
    if RESET = '1' then
      wrpos <= 0;
    else
      if WRCLK'event and WRCLK = '1' then
        if full_out = '0' then
          data(wrpos) <= DATAIN;
          wrpos <= wrpos + 1;
        end if;
      end if;

      if wrreset = '1' then
        wrpos <= 0;
      end if;
    end if;
  end process;

  READ: process (RESET, RDCLK, rdpos, empty_out, wrpos)
  begin
    if RESET = '1' then
      rdpos <= 0;
      wrreset <= '0';
    else
      if RDCLK'event and RDCLK = '1' then
        if empty_out = '0' then
          DATAOUT <= data(rdpos);
          rdpos <= rdpos + 1;
        end if;
      end if;

      if rdpos = maxpos then
        rdpos <= 0;
        wrreset <= '1';
      else
        wrreset <= '0';
      end if;
    end if;
  end process;
end Behavioral;
