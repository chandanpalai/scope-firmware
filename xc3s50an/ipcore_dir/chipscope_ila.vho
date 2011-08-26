-------------------------------------------------------------------------------
-- Copyright (c) 2011 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 13.2
--  \   \         Application: Xilinx CORE Generator
--  /   /         Filename   : chipscope_ila.vho
-- /___/   /\     Timestamp  : Fri Aug 26 21:14:29 BST 2011
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: ISE Instantiation template
-- Component Identifier: xilinx.com:ip:chipscope_ila:1.04.a
-------------------------------------------------------------------------------
-- The following code must appear in the VHDL architecture header:

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
component chipscope_ila
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CLK : IN STD_LOGIC;
    DATA : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    TRIG0 : IN STD_LOGIC_VECTOR(2 DOWNTO 0));

end component;

-- COMP_TAG_END ------ End COMPONENT Declaration ------------
-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.
------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG

your_instance_name : chipscope_ila
  port map (
    CONTROL => CONTROL,
    CLK => CLK,
    DATA => DATA,
    TRIG0 => TRIG0);

-- INST_TAG_END ------ End INSTANTIATION Template ------------
