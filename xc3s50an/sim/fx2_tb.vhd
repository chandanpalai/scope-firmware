--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:20:15 06/22/2011
-- Design Name:   
-- Module Name:   /home/ali/Projects/Active/cur/usbscope/fw/xc3s50an/sim/fx2_tb.vhd
-- Project Name:  scope
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fx2
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
 
ENTITY fx2_tb IS
END fx2_tb;
 
ARCHITECTURE behavior OF fx2_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fx2
    PORT(
         INDATA : IN  std_logic_vector(15 downto 0);
         INDATACLK : IN  std_logic;
         INDATAEN : IN std_logic;
         OUTDATA : OUT  std_logic_vector(15 downto 0);
         OUTDATACLK : OUT  std_logic;
         CLKIF : IN  std_logic;
         RESET : IN  std_logic;
         FD : INOUT  std_logic_vector(15 downto 0);
         FLAGA : IN  std_logic;
         FLAGB : IN  std_logic;
         FLAGC : IN  std_logic;
         SLOE : OUT  std_logic;
         SLRD : OUT  std_logic;
         SLWR : OUT  std_logic;
         FIFOADR : OUT  std_logic_vector(1 downto 0);
         PKTEND : OUT  std_logic;
         DBGOUT : OUT std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal INDATA : std_logic_vector(15 downto 0) := (others => '0');
   signal INDATACLK : std_logic := '0';
   signal INDATAEN : std_Logic := '0';
   signal CLKIF : std_logic := '0';
   signal RESET : std_logic := '0';
   signal FLAGA : std_logic := '0';
   signal FLAGB : std_logic := '0';
   signal FLAGC : std_logic := '0';

	--BiDirs
   signal FD : std_logic_vector(15 downto 0);

 	--Outputs
   signal OUTDATA : std_logic_vector(15 downto 0);
   signal OUTDATACLK : std_logic;
   signal SLOE : std_logic;
   signal SLRD : std_logic;
   signal SLWR : std_logic;
   signal FIFOADR : std_logic_vector(1 downto 0);
   signal PKTEND : std_logic;

   signal DBGOUT : std_logic;

   -- Clock period definitions
   constant CLKIF_period : time := 20 ns;
   constant INDATACLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fx2 PORT MAP (
          INDATA => INDATA,
          INDATACLK => INDATACLK,
          INDATAEN => INDATAEN,
          OUTDATA => OUTDATA,
          OUTDATACLK => OUTDATACLK,
          CLKIF => CLKIF,
          RESET => RESET,
          FD => FD,
          FLAGA => FLAGA,
          FLAGB => FLAGB,
          FLAGC => FLAGC,
          SLOE => SLOE,
          SLRD => SLRD,
          SLWR => SLWR,
          FIFOADR => FIFOADR,
          PKTEND => PKTEND,
          DBGOUT => DBGOUT
        );

   -- Clock process definitions
   CLKIF_process :process
   begin
		CLKIF <= '0';
		wait for CLKIF_period/2;
		CLKIF <= '1';
		wait for CLKIF_period/2;
   end process;

   INDATACLK_process :process
   begin
		INDATACLK <= '0';
		wait for INDATACLK_period/2;
		INDATACLK <= '1';
		wait for INDATACLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
           
           INDATAEN <= '0';

           FD <= "ZZZZZZZZZZZZZZZZ";
           FLAGA <= '0';
           FLAGB <= '0';
           FLAGC <= '1';

           RESET <= '1';
           wait for 100 ns;
           RESET <= '0';


           --READ TEST
           --single shot
           FLAGA <= '1';
           wait until SLOE = '0';
           FD <= "0000000000000000";
           wait until SLRD = '0';
           FD <= "0101010101010101";
           wait until SLRD = '1';
           FLAGA <= '0';

           wait for 100 ns;

           --multi shot
           FLAGA <= '1';
           wait until SLOE = '0';
           FD <= "0000000000000000";
           wait until SLRD = '0';
           FD <= "0100000000000000";
           wait until SLRD = '1';
           wait until SLOE = '0';
           FD <= "0000000000000000";
           wait until SLRD = '0';
           FD <= "1000000000000000";
           wait until SLRD = '1';
           wait until SLOE = '0';
           FD <= "0000000000000000";
           wait until SLRD = '0';
           FD <= "1100000000000000";
           wait until SLRD = '1';
           FLAGA <= '0';

           FD <= "ZZZZZZZZZZZZZZZZ";

           wait for 200 ns;

           --WRITE TEST
           --single shot
           INDATA <= "0101010101010101";
           INDATAEN <= '1';
           wait until INDATACLK = '1';
           wait until INDATACLK = '0';
           INDATAEN <= '0';

           wait for 100 ns;

           --multi shot
           INDATA <= "0000000000000001";
           INDATAEN <= '1';
           wait until INDATACLK = '1';
           wait until INDATACLK = '0';
           INDATA <= "1000000000000001";
           wait until INDATACLK = '1';
           wait until INDATACLK = '0';
           INDATA <= "1000000000000011";
           wait until INDATACLK = '1';
           wait until INDATACLK = '0';
           INDATA <= "1100000000000011";
           wait until INDATACLK = '1';
           wait until INDATACLK = '0';
           INDATA <= "1100000000000111";
           wait until INDATACLK = '1';
           wait until INDATACLK = '0';
           INDATA <= "1110000000000111";
           wait until INDATACLK = '1';
           wait until INDATACLK = '0';
           INDATA <= "1110000000001111";
           wait until INDATACLK = '1';
           wait until INDATACLK = '0';
           INDATA <= "1111000000001111";
           wait until INDATACLK = '1';
           wait until INDATACLK = '0';
           INDATAEN <= '0';

           wait;
   end process;

END;
