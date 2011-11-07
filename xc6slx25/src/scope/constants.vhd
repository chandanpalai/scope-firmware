library IEEE;
use IEEE.STD_LOGIC_1164.all;

package constants is

  constant CONST_MAGIC      : std_logic_vector(7 downto 0) := x"AF";

  constant CONST_DEST_HOST  : std_logic_vector(7 downto 0) := "00000000";
  constant CONST_DEST_SCOPE : std_logic_vector(7 downto 0) := "00000001";
  constant CONST_DEST_ADC   : std_logic_vector(7 downto 0) := "00000010";
  constant CONST_DEST_LA    : std_logic_vector(7 downto 0) := "00000011";
  constant CONST_DEST_DAC   : std_logic_vector(7 downto 0) := "00000100";
  constant CONST_DEST_IBx   : std_logic_vector(7 downto 0) := "00100000"; --base for +x

  constant CONST_REG_IB     : std_logic_vector(6 downto 0) := "0000001";
  constant CONST_REG_IBx    : std_logic_vector(6 downto 0) := "0100000"; --base for +x
end constants;

package body constants is

end constants;
