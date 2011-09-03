--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   22:12:51 09/03/2011
-- Design Name:
-- Module Name:   /home/ali/Projects/Active/cur/usbscope/fw/xc3s50an/sim/simplefifo_tb.vhd
-- Project Name:  scope
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: simplefifo
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes:
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY simplefifo_tb IS
  END simplefifo_tb;

ARCHITECTURE behavior OF simplefifo_tb IS

    -- Component Declaration for the Unit Under Test (UUT)

  COMPONENT simplefifo
    PORT(
          DATAIN : IN  std_logic_vector(15 downto 0);
          WRCLK : IN  std_logic;
          DATAOUT : OUT  std_logic_vector(15 downto 0);
          RDCLK : IN  std_logic;
          FULL : OUT  std_logic;
          EMPTY : OUT  std_logic;
          RESET : IN  std_logic
        );
  END COMPONENT;


   --Inputs
  signal DATAIN : std_logic_vector(15 downto 0) := (others => '0');
  signal WRCLK : std_logic := '0';
  signal RDCLK : std_logic := '0';
  signal RESET : std_logic := '0';

   --Outputs
  signal DATAOUT : std_logic_vector(15 downto 0);
  signal FULL : std_logic;
  signal EMPTY : std_logic;

BEGIN

   -- Instantiate the Unit Under Test (UUT)
  uut: simplefifo PORT MAP (
                             DATAIN => DATAIN,
                             WRCLK => WRCLK,
                             DATAOUT => DATAOUT,
                             RDCLK => RDCLK,
                             FULL => FULL,
                             EMPTY => EMPTY,
                             RESET => RESET
                           );

   -- Stimulus process
  stim_proc: process
  begin
      -- hold reset state for 100 ns.
    RESET <= '1';
    wait for 100 ns;
    RESET <= '0';


    DATAIN <= x"0001";
    WRCLK <= '1';
    wait for 20 ns;
    WRCLK <= '0';
    wait for 20 ns;
    DATAIN <= x"0002";
    WRCLK <= '1';
    wait for 20 ns;
    WRCLK <= '0';
    wait for 20 ns;
    DATAIN <= x"0004";
    WRCLK <= '1';
    wait for 20 ns;
    WRCLK <= '0';
    wait for 20 ns;
    DATAIN <= x"0008";
    WRCLK <= '1';
    wait for 20 ns;
    WRCLK <= '0';
    wait for 20 ns;
    DATAIN <= x"0010";
    WRCLK <= '1';
    wait for 20 ns;
    WRCLK <= '0';
    wait for 20 ns;
    DATAIN <= x"0011";
    WRCLK <= '1';
    wait for 20 ns;
    WRCLK <= '0';
    wait for 20 ns;

    wait for 100 ns;

    RDCLK <= '1';
    wait for 20 ns;
    RDCLK <= '0';
    wait for 20 ns;
    RDCLK <= '1';
    wait for 20 ns;
    RDCLK <= '0';
    wait for 20 ns;
    RDCLK <= '1';
    wait for 20 ns;
    RDCLK <= '0';
    wait for 20 ns;
    RDCLK <= '1';
    wait for 20 ns;
    RDCLK <= '0';
    wait for 20 ns;


    DATAIN <= x"0012";
    WRCLK <= '1';
    wait for 20 ns;
    WRCLK <= '0';
    wait for 20 ns;
    DATAIN <= x"0014";
    WRCLK <= '1';
    wait for 20 ns;
    WRCLK <= '0';
    wait for 20 ns;
    DATAIN <= x"0018";
    WRCLK <= '1';
    wait for 20 ns;
    WRCLK <= '0';
    wait for 20 ns;

    RDCLK <= '1';
    wait for 20 ns;
    RDCLK <= '0';
    wait for 20 ns;
    RDCLK <= '1';
    wait for 20 ns;
    RDCLK <= '0';
    wait for 20 ns;
    RDCLK <= '1';
    wait for 20 ns;
    RDCLK <= '0';
    wait for 20 ns;
    RDCLK <= '1';
    wait for 20 ns;
    RDCLK <= '0';
    wait for 20 ns;
    wait;
  end process;

END;
