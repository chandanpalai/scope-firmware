--------------------------------------------------------------------------------
-- Engineer:       Ali Lown
--
-- Create Date:    21:17:29 06/23/2011
-- Module Name:    think - Behavioral
-- Project Name:   USB Digital Oscilloscope
-- Target Devices: xc3s50a(n)
-- Description:    Handles controlling the other modules, and parsing the
--                 computer's instructions.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity think is
  Port ( RESET : IN std_logic;
         CLK : IN std_logic;

         PKTBUS : IN std_logic_vector(15 downto 0);
         PKTBUSCLK : IN std_logic;

         PKTIN : OUT std_logic_vector(15 downto 0);
         PKTINCLK : OUT std_logic;

         PKTOUTADC : OUT std_logic_vector(15 downto 0);
         PKTOUTADCCLK : OUT std_logic;

         PKTOUTA : OUT std_logic_vector(15 downto 0);
         PKTOUTACLK : OUT std_logic;

         PKTINA : IN std_logic_vector(15 downto 0);
         PKTINACLK : IN std_logic;

         PKTOUTB : OUT std_logic_vector(15 downto 0);
         PKTOUTBCLK : OUT std_logic;

         PKTINB : IN std_logic_vector(15 downto 0);
         PKTINBCLK : IN std_logic
       );
end think;

architecture Behavioral of think is
  COMPONENT pkt16buffer
    PORT (
           rst : IN STD_LOGIC;
           wr_clk : IN STD_LOGIC;
           rd_clk : IN STD_LOGIC;
           din : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
           wr_en : IN STD_LOGIC;
           rd_en : IN STD_LOGIC;
           dout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
           full : OUT STD_LOGIC;
           empty : OUT STD_LOGIC
         );
  END COMPONENT;

  type stout_type is (st0_magicdest, st1_high, st2_regvalue, st3_high);
  signal st_out : stout_type;
  type stin_type is (st0_idle, st1_wr_iba, st1_wr_ibb, st1_wr_cfg);
  signal st_in : stin_type;

  constant CONST_MAGIC : std_logic_vector(7 downto 0) := x"AF";
  constant CONST_DEST_SCOPE : std_logic_vector(7 downto 0) := "00000001";
  constant CONST_DEST_ADC   : std_logic_vector(7 downto 0) := "00000010";
  constant CONST_DEST_IBA   : std_logic_vector(7 downto 0) := "00010000";
  constant CONST_DEST_IBB   : std_logic_vector(7 downto 0) := "00010001";

  constant CONST_REG_IB     : std_logic_vector(6 downto 0) := "0000001";
  constant CONST_REG_IBA    : std_logic_vector(6 downto 0) := "0010000";
  constant CONST_REG_IBB    : std_logic_vector(6 downto 0) := "0010001";

  signal dest : std_logic_vector(7 downto 0);
  signal rnw : std_logic;
  constant CONST_READ : std_logic := '1';
  constant CONST_WRITE : std_logic := '0';
  signal reg : std_logic_vector(6 downto 0);

  signal pktincfg : std_logic_vector(15 downto 0);
  signal pktincfgclk : std_logic;

  signal iba_full, iba_empty, ibb_full, ibb_empty, cfg_full, cfg_empty : std_logic;
  signal iba_rdclk, ibb_rdclk, cfg_rdclk : std_logic;
  signal iba_dout, ibb_dout, cfg_dout : std_logic_vector(15 downto 0);

  signal reg_ib : std_logic_vector(7 downto 0) := "00000000";
  signal reg_iba : std_logic_vector(7 downto 0) := "00000000";
  signal reg_ibb : std_logic_vector(7 downto 0) := "00000000";

begin
  Inst_ibafifo: pkt16buffer
  PORT MAP(
            din => PKTINA,
            wr_clk => PKTINACLK,
            dout => iba_dout,
            rd_clk => iba_rdclk,
            full => iba_full,
            empty => iba_empty,
            rst => RESET,
            wr_en => '1',
            rd_en => '1'
          );

  Inst_ibbfifo: pkt16buffer
  PORT MAP(
            din => PKTINB,
            wr_clk => PKTINBCLK,
            dout => ibb_dout,
            rd_clk => ibb_rdclk,
            fully => ibb_full,
            empty => ibb_empty,
            rst => RESET,
            wr_en => '1',
            rd_en => '1'
          );

  Inst_cfgfifo: pkt16buffer
  PORT MAP(
            din => pktincfg,
            wr_clk => pktincfgclk,
            dout => cfg_dout,
            rd_clk => cfg_rdclk,
            full => cfg_full,
            empty => cfg_empty,
            rst => RESET,
            wr_en => '1',
            rd_en => '1'
          );


  rnw <= PKTBUS(0);
  reg <= PKTBUS(7 downto 1);

  HOSTOUT: process(RESET, CLK, PKTBUS, PKTBUSCLK)
  begin
    if RESET = '1' then
      PKTOUTADC <= x"0000";
      PKTOUTADCCLK <= '0';
      PKTOUTA <= x"0000";
      PKTOUTACLK <= '0';
      PKTOUTB <= x"0000";
      PKTOUTBCLK <= '0';

      st_out <= st0_magicdest;

      dest <= x"00";
    else
      if CLK'event and CLK = '1' then
        case st_out is
          when st0_magicdest =>
            if PKTBUS(7 downto 0) = CONST_MAGIC and PKTBUSCLK = '0' then
              dest <= PKTBUS(15 downto 8);
              st_out <= st1_high;
            end if;
          when st1_high =>
            if PKTBUSCLK = '1' then
              st_out <= st2_regvalue;
            end if;
          when st2_regvalue =>
            case dest is
              when CONST_DEST_SCOPE =>
                if rnw = CONST_READ then
                  case reg is
                    when CONST_REG_IB =>
                      pktincfg(15 downto 8) <= reg_ib;
                    when CONST_REG_IBA =>
                      pktincfg(15 downto 8) <= reg_iba;
                    when CONST_REG_IBB =>
                      pktincfg(15 downto 8) <= reg_ibb;
                    when others =>
                  end case;
                  pktincfg(0) <= CONST_READ;
                  pktincfg(7 downto 1) <= reg;
                  pktincfgclk <= '1';
                else
                  case reg is
                    when others =>
                  end case;
                end if;

              when CONST_DEST_ADC =>
                PKTOUTADC <= PKTBUS;
                PKTOUTADCCLK <= '1';

              when CONST_DEST_IBA =>
                PKTOUTA <= PKTBUS;
                PKTOUTACLK <= '1';
              when CONST_DEST_IBB =>
                PKTOUTB <= PKTBUS;
                PKTOUTBCLK <= '1';

              when others =>
            end case;
            if PKTBUSCLK = '0' then
              st_out <= st3_high;
            end if;
          when st3_high =>
            PKTOUTADCCLK <= '0';
            PKTOUTACLK <= '0';
            PKTOUTBCLK <= '0';
            pktincfgclk <= '0';
            if PKTBUSCLK = '1' then
              st_out <= st0_magicdest;
            end if;
        end case;
      end if;
    end if;
  end process;

  HOSTIN: process(RESET, CLK, iba_empty, ibb_empty, cfg_empty)
  begin
    if RESET = '1' then
      reg_ib <= "00000000";
      reg_iba <= "00000000";
      reg_ibb <= "00000000";

      iba_rdclk <= '0';
      ibb_rdclk <= '0';
      cfg_rdclk <= '0';
      PKTINCLK <= '0';
      st_in <= st0_idle;
    else
      if CLK'event and CLK = '1' then
        case st_in is
          when st0_idle =>
            if iba_empty = '0' then
              iba_rdclk <= '1';
              st_in <= st1_wr_iba;
            elsif ibb_empty = '0' then
              ibb_rdclk <= '1';
              st_in <= st1_wr_ibb;
            elsif cfg_empty = '0' then
              cfg_rdclk <= '1';
              st_in <= st1_wr_cfg;
            else
              iba_rdclk <= '0';
              ibb_rdclk <= '0';
              cfg_rdclk <= '0';
              PKTINCLK <= '0';
            end if;
          when st1_wr_iba =>
            -- Check for special commands
            case iba_dout(7 downto 0) is
              when x"00" =>
                reg_ib(0) <= '1';
                reg_iba <= iba_dout(15 downto 8);
              when others =>
                PKTIN <= iba_dout;
                PKTINCLK <= '1';
            end case;
            iba_rdclk <= '0';
            st_in <= st0_idle;
          when st1_wr_ibb =>
            -- Check for special commands
            case ibb_dout(7 downto 0) is
              when x"00" =>
                reg_ib(1) <= '1';
                reg_ibb <= ibb_dout(15 downto 8);
              when others =>
                PKTIN <= ibb_dout;
                PKTINCLK <= '1';
            end case;
            ibb_rdclk <= '0';
            st_in <= st0_idle;
          when st1_wr_cfg =>
            PKTIN <= cfg_dout;
            PKTINCLK <= '1';
            cfg_rdclk <= '0';
            st_in <= st0_idle;
        end case;
      end if;
    end if;
  end process;
end Behavioral;
