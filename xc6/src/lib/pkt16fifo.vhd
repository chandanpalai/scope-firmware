---------------------------------------------------------------------------
-- Company     : eeZySys Technologies
-- Author(s)   : Ali Lown <ali@eezysys.co.uk>
--
-- File        : pkt16fifo.vhd
--
-- Abstract    : 16 wide small distributed fifo based around periodic clks
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all

entity pkt16fifo is
  port ( datain : in std_logic_vector(15 downto 0);
         wrclk : in std_logic;
         dataout : out std_logic_vector(15 downto 0);
         rdclk : in std_logic;
         full : out std_logic;
         empty : out std_logic;
         reset : in std_logic
       );
end pkt16fifo;

architecture Behavioral of pkt16fifo is

  constant maxpos : integer := 4;
  signal wrpos, rdpos : integer range 0 to maxpos := 0;
  type data_type is array(maxpos downto 0) of std_logic_vector(15 downto 0);
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

    if (wrpos = 0)or ((wrpos = rdpos) and not full_out = '1') then
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
