--*************************************************************************
--*  Minimal UART ip core                                                 *
--* Author: Arao Hayashida Filho        arao@medinovacao.com.br           *
--*                                                                       *
--*************************************************************************
--*                                                                       *
--* Copyright (C) 2009 Arao Hayashida Filho                               *
--*                                                                       *
--* This source file may be used and distributed without                  *
--* restriction provided that this copyright statement is not             *
--* removed from the file and that any derivative work contains           *
--* the original copyright notice and the associated disclaimer.          *
--*                                                                       *
--* This source file is free software; you can redistribute it            *
--* and/or modify it under the terms of the GNU Lesser General            *
--* Public License as published by the Free Software Foundation;          *
--* either version 2.1 of the License, or (at your option) any            *
--* later version.                                                        *
--*                                                                       *
--* This source is distributed in the hope that it will be                *
--* useful, but WITHOUT ANY WARRANTY; without even the implied            *
--* warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR               *
--* PURPOSE.  See the GNU Lesser General Public License for more          *
--* details.                                                              *
--*                                                                       *
--* You should have received a copy of the GNU Lesser General             *
--* Public License along with this source; if not, download it            *
--* from http://www.opencores.org/lgpl.shtml                              *
--*                                                                       *
--*************************************************************************
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decod is
    Port ( DATA : in  STD_LOGIC_VECTOR (7 downto 0);
       	  CLOCK : in STD_LOGIC;
           SEGMENT : out  STD_LOGIC_VECTOR (7 downto 0);
			  OUTP : out  STD_LOGIC_VECTOR (7 downto 0);		
			  EOT : IN STD_LOGIC;
			  WR : OUT STD_LOGIC			  
			 );
end decod;

architecture Behavioral of decod is
SIGNAL COUNTER : STD_LOGIC_VECTOR(19 DOWNTO 0):=X"00000";
SIGNAL CLK_0_5 : STD_LOGIC :='0';
SIGNAL COUNT_TST : STD_LOGIC_VECTOR(7 DOWNTO 0):=X"21";
SIGNAL COUNTDV : STD_LOGIC_VECTOR(23 DOWNTO 0):=X"000000";
SIGNAL HEX : STD_LOGIC_VECTOR(3 DOWNTO 0) :="0000";
SIGNAL CLOCK_1 : STD_LOGIC :='0';

begin
SEGMENT(3)<= CLK_0_5;	
WR<=CLOCK_1;
--wr<='0';
CLK_GEN : PROCESS(CLOCK)
BEGIN

IF (RISING_EDGE(CLOCK))	THEN
	IF (COUNTDV =X"0C3500")  THEN 
	--IF (COUNTDV =X"000100")  THEN  --  uncomment to make simulations faster
		COUNTDV<=X"000000";
		CLOCK_1<=NOT(CLOCK_1);		
	ELSE			
		COUNTDV<=COUNTDV+1;
	END IF;
END IF;
END PROCESS;
	outp<=count_tst;	
PROCESS (CLOCK_1)
BEGIN		
	IF (RISING_EDGE(CLOCK_1)) THEN 							
			COUNT_TST<=COUNT_TST+1;				
	END IF;
	IF (COUNT_TST>X"7F")THEN 
		COUNT_TST<=X"21";	
	END IF;
END PROCESS;

PROCESS(CLOCK_1)
BEGIN
IF (RISING_EDGE(CLOCK_1)) THEN
	IF (COUNTER =X"0003C") THEN
		COUNTER<=X"00000";	  
		CLK_0_5<=NOT(CLK_0_5);		
	ELSE  
		COUNTER <= COUNTER + 1; 
	
	END IF;
END IF;

END PROCESS ;

  WITH CLK_0_5 SELECT
		HEX<=DATA(7 DOWNTO 4) WHEN '0',
		     DATA(3 DOWNTO 0) WHEN OTHERS;
		
  WITH HEX SELECT  --123456789A=>
   SEGMENT<="0001Z100" when "0001",   --1
				"1110Z110" when "0010",   --2
				"1011Z110" when "0011",   --3
				"1001Z101" when "0100",   --4
				"1011Z011" when "0101",   --5
				"1111Z011" when "0110",   --6
				"0001Z110" when "0111",   --7
				"1111Z111" when "1000",   --8
				"1001Z111" when "1001",   --9
				"1101Z111" when "1010",   --A
				"1111Z001" when "1011",   --b
				"1110Z000" when "1100",   --C
				"1111Z100" when "1101",   --d
				"1110Z011" when "1110",   --E
				"1100Z011" when "1111",   --F
				"0111Z111" when others;   --0
				


end Behavioral;


