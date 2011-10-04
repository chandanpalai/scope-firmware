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
  COMPONENT pkt16fifo
    PORT(
          DATAIN : IN std_logic_vector(15 downto 0);
          WRCLK : IN std_logic;
          RDCLK : IN std_logic;
          RESET : IN std_logic;
          DATAOUT : OUT std_logic_vector(15 downto 0);
          FULL : OUT std_logic;
          EMPTY : OUT std_logic
        );
  END COMPONENT;

  type stout_type is (st0_magicdest, st1_regvalue);
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
  signal value : std_logic_vector(7 downto 0);

  signal pktincfg : std_logic_vector(15 downto 0);
  signal pktincfgclk : std_logic;

  signal iba_full, iba_empty, ibb_full, ibb_empty, cfg_full, cfg_empty : std_logic;
  signal iba_rdclk, ibb_rdclk, cfg_rdclk : std_logic;
  signal iba_dout, ibb_dout, cfg_dout : std_logic_vector(15 downto 0);

  signal reg_ib : std_logic_vector(7 downto 0) := "00000000";
  signal reg_iba : std_logic_vector(7 downto 0) := "00000000";
  signal reg_ibb : std_logic_vector(7 downto 0) := "00000000";

begin
  Inst_ibafifo: pkt16fifo
  PORT MAP(
            DATAIN => PKTINA,
            WRCLK => PKTINACLK,
            DATAOUT => iba_dout,
            RDCLK => iba_rdclk,
            FULL => iba_full,
            EMPTY => iba_empty,
            RESET => RESET
          );

  Inst_ibbfifo: pkt16fifo
  PORT MAP(
            DATAIN => PKTINB,
            WRCLK => PKTINBCLK,
            DATAOUT => ibb_dout,
            RDCLK => ibb_rdclk,
            FULL => ibb_full,
            EMPTY => ibb_empty,
            RESET => RESET
          );

  Inst_cfgfifo: pkt16fifo
  PORT MAP(
          DATAIN => pktincfg,
          WRCLK => pktincfgclk,
          DATAOUT => cfg_dout,
          RDCLK => cfg_rdclk,
          FULL => cfg_full,
          EMPTY => cfg_empty,
          RESET => RESET
          );


    rnw <= PKTBUS(0);
    reg <= PKTBUS(7 downto 1);
    value <= PKTBUS(15 downto 8);

  HOSTOUT: process(RESET, PKTBUS, PKTBUSCLK)
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
      -- Let data lines settle first
      if PKTBUSCLK'event and PKTBUSCLK = '0' then
        case st_out is
          when st0_magicdest =>
            PKTOUTADCCLK <= '0';
            PKTOUTACLK <= '0';
            PKTOUTBCLK <= '0';
            pktincfgclk <= '0';

            if PKTBUS(7 downto 0) = CONST_MAGIC then
              dest <= PKTBUS(15 downto 8);
              st_out <= st1_regvalue;
            end if;
          when st1_regvalue =>
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
            st_out <= st0_magicdest;
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
