----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:49:11 06/24/2011 
-- Design Name: 
-- Module Name:    main - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity main is
    Port ( ADCDA : in  STD_LOGIC_VECTOR (7 downto 0);
           ADCDB : in  STD_LOGIC_VECTOR (7 downto 0);
           ADCCLK : out  STD_LOGIC;
           ADCPD : out  STD_LOGIC;
           ADCOE : out  STD_LOGIC;
           CYFD : inout  STD_LOGIC_VECTOR (15 downto 0);
           CYIFCLK : in  STD_LOGIC;
           CYFIFOADR : out  STD_LOGIC_VECTOR (1 downto 0);
           CYSLOE : out  STD_LOGIC;
           CYSLWR : out  STD_LOGIC;
           CYSLRD : out  STD_LOGIC;
           CYFLAGA : in  STD_LOGIC;
           CYFLAGB : in  STD_LOGIC;
           CYFLAGC : in  STD_LOGIC;
   		   CYPKTEND : out STD_LOGIC;
		   MCLK : in STD_LOGIC;
           DBG0 : out STD_LOGIC;
           DBG1 : out STD_LOGIC;
           DBG2 : out STD_LOGIC;
           DBG3 : out STD_LOGIC);
end main;

architecture Behavioral of main is
	COMPONENT adc
	PORT(
		DA : IN std_logic_vector(7 downto 0);
		DB : IN std_logic_vector(7 downto 0);
		ZZ : IN std_logic;
		CLKM : IN std_logic;
		CFGCLK : IN std_logic_vector(7 downto 0);
		CFGCHNL : IN std_logic_vector(1 downto 0);          
		DATA : OUT std_logic_vector(15 downto 0);
		DATAEN : OUT std_logic;
		PD : OUT std_logic;
		OE : OUT std_logic;
		CLKSMPL : OUT std_logic
		);
	END COMPONENT;

	COMPONENT fx2
	PORT(
		INDATA : IN std_logic_vector(15 downto 0);
		INDATACLK : IN std_logic;
		INDATAEN : IN std_logic;
		CLKIF : IN std_logic;
		RESET : IN std_logic;
		FLAGA : IN std_logic;
		FLAGB : IN std_logic;
		FLAGC : IN std_logic;    
		FD : INOUT std_logic_vector(15 downto 0);      
		OUTDATA : OUT std_logic_vector(15 downto 0);
		OUTDATACLK : OUT std_logic;
		SLOE : OUT std_logic;
		SLRD : OUT std_logic;
		SLWR : OUT std_logic;
		FIFOADR : OUT std_logic_vector(1 downto 0);
		PKTEND : OUT std_logic;
        DBGOUT : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT think
	PORT(
		DATAIN : IN std_logic_vector(15 downto 0);
		DATACLK : IN std_logic;
		RESET : IN std_logic;
		CLKIF : IN std_logic;          
		ZZ : OUT std_logic;
		CFGCLK : OUT std_logic_vector(7 downto 0);
		CFGCHNL : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;

	COMPONENT maindcm
	PORT(
		CLKIN_IN : IN std_logic;          
		CLKFX_OUT : OUT std_logic;
		CLKIN_IBUFG_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic
		);
	END COMPONENT;

    COMPONENT ifdcm
	PORT(
		CLKIN_IN : IN std_logic;
		CLKIN_IBUFG_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic
		);
	END COMPONENT;

    component chipscope_icon
      PORT (
        CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));
    end component;

    component chipscope_ila
      PORT (
        CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
        CLK : IN STD_LOGIC;
        TRIG0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        TRIG1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0));
    end component;

	signal zz : std_logic;
	signal cfgclk : std_logic_vector(7 downto 0);
	signal cfgchnl : std_logic_vector(1 downto 0);
	signal dcmlocked : std_logic;
	signal reset : std_logic;
	signal adcbus : std_logic_vector(15 downto 0);
	signal adcbusen : std_logic;
	signal cybus : std_logic_vector(15 downto 0);
	signal cybusclk : std_logic;
	signal adcintclk : std_logic;	
	signal adcsmplclk : std_logic;

	signal dcmclk0 : std_logic;
	signal dcmbufg : std_logic;

    signal out_dbg0 : std_logic;
    signal out_dbg1 : std_logic;
    signal out_dbg2 : std_logic;
    signal out_dbg3 : std_logic;

    signal ifclk : std_logic;
    signal ifdcmbufg : std_logic;
    signal ifdcmlocked : std_logic;

    signal cs_control : std_logic_vector(35 downto 0);
    signal cs_triga : std_logic_vector(15 downto 0);
    signal cs_trigb : std_logic_vector(7 downto 0);

    signal cysloe_out : std_logic;
    signal cyslrd_out : std_logic;
    signal cyslwr_out : std_logic;

begin
	Inst_adc: adc PORT MAP(
		DA => ADCDA,
		DB => ADCDB,
		DATA => adcbus,
		DATAEN => adcbusen,
		ZZ => zz,
		PD => ADCPD,
		OE => ADCOE,
		CLKSMPL => adcsmplclk,
		CLKM => adcintclk,
		CFGCLK => cfgclk,
		CFGCHNL => cfgchnl
	);

	Inst_fx2: fx2 PORT MAP(
		INDATA => adcbus,
		INDATACLK => adcsmplclk,
		INDATAEN => adcbusen,
		OUTDATA => cybus,
		OUTDATACLK => cybusclk,
        CLKIF => ifclk,
		RESET => reset,
		FD => CYFD,
		FLAGA => CYFLAGA,
		FLAGB => CYFLAGB,
		FLAGC => CYFLAGC,
		SLOE => cysloe_out,
		SLRD => cyslrd_out,
		SLWR => cyslwr_out,
		FIFOADR => CYFIFOADR,
		PKTEND => CYPKTEND,
        DBGOUT => out_dbg3
	);

	Inst_think: think PORT MAP(
		DATAIN => cybus,
		DATACLK => cybusclk,
		RESET => reset,
        CLKIF => ifclk,
		ZZ => out_dbg1,
		CFGCLK => cfgclk,
		CFGCHNL => cfgchnl
	);

	Inst_maindcm: maindcm PORT MAP(
		CLKIN_IN => MCLK,
		CLKFX_OUT => adcintclk,
		CLKIN_IBUFG_OUT => dcmbufg,
		CLK0_OUT => out_dbg2,
		LOCKED_OUT => out_dbg0 
	);

    Inst_ifdcm: ifdcm PORT MAP(
		CLKIN_IN => CYIFCLK,
        CLKIN_IBUFG_OUT => ifdcmbufg,
        CLK0_OUT => ifclk,
        LOCKED_OUT => ifdcmlocked 
	);

    Inst_chipscope_icon : chipscope_icon
      port map (
        CONTROL0 => cs_control
    );

    Inst_chipscope_ila : chipscope_ila
      port map (
        CONTROL => cs_control,
        CLK => adcintclk,
        TRIG0 => cs_triga,
        TRIG1 => cs_trigb
    );

    reset <= not dcmlocked;

	ADCCLK <= adcsmplclk;

    dcmlocked <= out_dbg0;
    zz <= out_dbg1;
    dcmclk0 <= out_dbg2;

    DBG0 <= out_dbg0;
    DBG1 <= out_dbg1;
    DBG2 <= out_dbg2;
    --DBG3 <= out_dbg3;
    DBG3 <= ifdcmlocked;

    CYSLOE <= cysloe_out;
    CYSLRD <= cyslrd_out;
    CYSLWR <= cyslwr_out;

    cs_triga <= CYFD;
    cs_trigb(0) <= cysloe_out;
    cs_trigb(1) <= cyslrd_out;
    cs_trigb(2) <= cyslwr_out;
    cs_trigb(3) <= CYFLAGA;
    cs_trigb(4) <= CYFLAGB;
    cs_trigb(5) <= CYFLAGC;

end Behavioral;

