--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:28:27 03/10/2011
-- Design Name:   
-- Module Name:   /home/ali/Projects/Active/Electronics/scope/sw/fw/fpga/cyfifo_tb.vhd
-- Project Name:  fpga
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cyfifo
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
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY cyfifo_tb IS
END cyfifo_tb;
 
ARCHITECTURE behavior OF cyfifo_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cyfifo
    PORT(
         RESET : IN  std_logic;
         USER_IN_DATA : IN  std_logic_vector(15 downto 0);
         WRITE_STROBE : IN  std_logic;
         CLKIN : IN  std_logic;
         STATE_CLK : IN  std_logic;
         USER_OUT_DATA : OUT  std_logic_vector(15 downto 0);
         DATAINT : OUT  std_logic;
         FULL : OUT  std_logic;
         CY_SLRD : OUT  std_logic;
         CY_SLWR : OUT  std_logic;
         CY_SLOE : OUT  std_logic;
         CY_FIFOADDR : OUT  std_logic_vector(1 downto 0);
         CY_FLAGA : IN  std_logic;
         CY_FLAGB : IN  std_logic;
         CY_FLAGC : IN  std_logic;
         CY_PKTEND : OUT  std_logic;
         CY_FD : INOUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal RESET : std_logic := '0';
   signal USER_IN_DATA : std_logic_vector(15 downto 0) := (others => '0');
   signal WRITE_STROBE : std_logic := '0';
   signal CLKIN : std_logic := '0';
   signal STATE_CLK : std_logic := '0';
   signal CY_FLAGA : std_logic := '0';
   signal CY_FLAGB : std_logic := '0';
   signal CY_FLAGC : std_logic := '0';

	--BiDirs
   signal CY_FD : std_logic_vector(15 downto 0);

 	--Outputs
   signal USER_OUT_DATA : std_logic_vector(15 downto 0);
   signal DATAINT : std_logic;
   signal FULL : std_logic;
   signal CY_SLRD : std_logic;
   signal CY_SLWR : std_logic;
   signal CY_SLOE : std_logic;
   signal CY_FIFOADDR : std_logic_vector(1 downto 0);
   signal CY_PKTEND : std_logic;

   -- Clock period definitions
   constant CLKIN_period : time := 10 ns;
   constant STATE_CLK_period : time := 10 ns;

   signal counter : std_logic_vector(15 downto 0) := "0000000000000000";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cyfifo PORT MAP (
          RESET => RESET,
          USER_IN_DATA => USER_IN_DATA,
          WRITE_STROBE => WRITE_STROBE,
          CLKIN => CLKIN,
          STATE_CLK => STATE_CLK,
          USER_OUT_DATA => USER_OUT_DATA,
          DATAINT => DATAINT,
          FULL => FULL,
          CY_SLRD => CY_SLRD,
          CY_SLWR => CY_SLWR,
          CY_SLOE => CY_SLOE,
          CY_FIFOADDR => CY_FIFOADDR,
          CY_FLAGA => CY_FLAGA,
          CY_FLAGB => CY_FLAGB,
          CY_FLAGC => CY_FLAGC,
          CY_PKTEND => CY_PKTEND,
          CY_FD => CY_FD
        );

   -- Clock process definitions
   CLKIN_process :process
   begin
		CLKIN <= '0';
		wait for CLKIN_period/2;
		CLKIN <= '1';
		wait for CLKIN_period/2;
   end process;
 
   STATE_CLK_process :process
   begin
		STATE_CLK <= '0';
		wait for STATE_CLK_period/2;
		STATE_CLK <= '1';
		wait for STATE_CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		   CY_FLAGA <= '0';
		   for I in 0 to 100 loop
				   counter <= conv_std_logic_vector(I,counter'length);
				   USER_IN_DATA <= counter;
				   wait for CLKIN_period;
		   end loop;

		   CY_FLAGC <= '1';
		   for I in 0 to 100 loop
				   counter <= conv_std_logic_vector(I,counter'length);
				   USER_IN_DATA <= counter;
				   wait for CLKIN_period;
		   end loop;

      wait;


   end process;

END;
