-- Vhdl test bench created from schematic /home/ali/Projects/Active/Electronics/scope/sw/fw/fpga/main.sch - Thu Mar 17 10:19:09 2011
--
-- Notes: 
-- 1) This testbench template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the unit under test.
-- Xilinx recommends that these types always be used for the top-level
-- I/O of a design in order to guarantee that the testbench will bind
-- correctly to the timing (post-route) simulation model.
-- 2) To use this template as your testbench, change the filename to any
-- name of your choice with the extension .vhd, and use the "Source->Add"
-- menu in Project Navigator to import the testbench. Then
-- edit the user defined section below, adding code to generate the 
-- stimulus for your design.
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
LIBRARY UNISIM;
USE UNISIM.Vcomponents.ALL;
ENTITY main_main_sch_tb IS
END main_main_sch_tb;
ARCHITECTURE behavioral OF main_main_sch_tb IS 

   COMPONENT main
   PORT(  ADCD1	:	IN	STD_LOGIC_VECTOR (7 DOWNTO 0); 
          ADCD0	:	IN	STD_LOGIC_VECTOR (7 DOWNTO 0); 
          ADCPD	:	OUT	STD_LOGIC; 
          CYCLK	:	IN	STD_LOGIC; 
          ADCOE	:	OUT	STD_LOGIC; 
          SINA	:	IN	STD_LOGIC; 
          SOUTA	:	OUT	STD_LOGIC; 
          SINB	:	IN	STD_LOGIC; 
          SOUTB	:	OUT	STD_LOGIC; 
          MCLK	:	IN	STD_LOGIC; 
          CYFLAGC	:	IN	STD_LOGIC; 
          CYFLAGB	:	IN	STD_LOGIC; 
          CYFLAGA	:	IN	STD_LOGIC; 
          CYSLRD	:	OUT	STD_LOGIC; 
          CYPKTEND	:	OUT	STD_LOGIC; 
          CYSLOE	:	OUT	STD_LOGIC; 
          CYSLWR	:	OUT	STD_LOGIC; 
          CYFD	:	INOUT	STD_LOGIC_VECTOR (15 DOWNTO 0); 
          CYFIFOADDR	:	OUT	STD_LOGIC_VECTOR (1 DOWNTO 0); 
          ADCCLK	:	OUT	STD_LOGIC);
   END COMPONENT;

   SIGNAL ADCD1	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
   SIGNAL ADCD0	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
   SIGNAL ADCPD	:	STD_LOGIC;
   SIGNAL CYCLK	:	STD_LOGIC;
   SIGNAL ADCOE	:	STD_LOGIC;
   SIGNAL SINA	:	STD_LOGIC;
   SIGNAL SOUTA	:	STD_LOGIC;
   SIGNAL SINB	:	STD_LOGIC;
   SIGNAL SOUTB	:	STD_LOGIC;
   SIGNAL MCLK	:	STD_LOGIC;
   SIGNAL CYFLAGC	:	STD_LOGIC;
   SIGNAL CYFLAGB	:	STD_LOGIC;
   SIGNAL CYFLAGA	:	STD_LOGIC;
   SIGNAL CYSLRD	:	STD_LOGIC;
   SIGNAL CYPKTEND	:	STD_LOGIC;
   SIGNAL CYSLOE	:	STD_LOGIC;
   SIGNAL CYSLWR	:	STD_LOGIC;
   SIGNAL CYFD	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
   SIGNAL CYFIFOADDR	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
   SIGNAL ADCCLK	:	STD_LOGIC;

   signal adcdata : std_logic_vector(7 downto 0) := "00000000";

BEGIN

   UUT: main PORT MAP(
		ADCD1 => ADCD1, 
		ADCD0 => ADCD0, 
		ADCPD => ADCPD, 
		CYCLK => CYCLK, 
		ADCOE => ADCOE, 
		SINA => SINA, 
		SOUTA => SOUTA, 
		SINB => SINB, 
		SOUTB => SOUTB, 
		MCLK => MCLK, 
		CYFLAGC => CYFLAGC, 
		CYFLAGB => CYFLAGB, 
		CYFLAGA => CYFLAGA, 
		CYSLRD => CYSLRD, 
		CYPKTEND => CYPKTEND, 
		CYSLOE => CYSLOE, 
		CYSLWR => CYSLWR, 
		CYFD => CYFD, 
		CYFIFOADDR => CYFIFOADDR, 
		ADCCLK => ADCCLK
   );

-- *** Test Bench - User Defined Section ***
   tb : PROCESS
   BEGIN
			--Allow the reset
			wait for 1 us;
			
			--enable the adc via some cypress data
			CYFLAGA <= '0';
			CYFLAGB <= '0';
			CYFLAGC <= '1';

			wait for 1 us;
			
			CYFLAGA <= '1';
			wait until CYSLRD = '0';
			CYFD <= "0000000011000000";
			wait until CYSLRD = '0';
			CYFD <= "0000000000011111";
			wait until CYSLRD = '0';
			CYFD <= "0000000000000000";
			wait until CYSLRD = '0';
			CYFD <= "0000000000000000";
			wait until CYSLRD = '0';
			CYFLAGA <= '0';
			CYFD <= "ZZZZZZZZZZZZZZZZ";

			wait for 200 ns;

			CYFLAGA <= '1';
			wait until CYSLRD = '0';
			CYFD <= "0000000011000001";
			wait until CYSLRD = '0';
			CYFD <= "0000000000000000";
			wait until CYSLRD = '0';
			CYFD <= "0000000000000000";
			wait until CYSLRD = '0';
			CYFD <= "0000000000000000";
			wait until CYSLRD = '0';
			CYFLAGA <= '0';
			CYFD <= "ZZZZZZZZZZZZZZZZ";

			for i in 0 to 200 loop
					wait until ADCCLK = '1';
					ADCD0 <= adcdata;			
					ADCD1 <= not adcdata;
					adcdata <= adcdata + 1;
			end loop;
			
			--wait for other modules to work
			wait;
   END PROCESS;
   
   --33.3333MHz clock input
 	clk : PROCESS
	BEGIN
			MCLK <= '1';
			wait for 15 ns;
			MCLK <= '0';
			wait for 15 ns;
	END PROCESS;
	
	--IFCLK from cypress
	ifclk: PROCESS
	BEGIN
			CYCLK <= '1';
			wait for 10.5 ns;
			CYCLK <= '0';
			wait for 10.5 ns;
	END PROCESS;

-- *** End Test Bench - User Defined Section ***

END;
