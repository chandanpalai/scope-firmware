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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library scope;
use scope.constants.ALL;

entity think is
  generic (
  NUM_IB : integer
);
Port ( RESET : IN std_logic;
       CLK : IN std_logic;

       PKTBUS : IN std_logic_vector(15 downto 0);
       PKTBUSCLK : IN std_logic;

       PKTIN : OUT std_logic_vector(15 downto 0);
       PKTINCLK : OUT std_logic;

       PKTOUTADC : OUT std_logic_vector(15 downto 0);
       PKTOUTADCCLK : OUT std_logic;

       PKTOUTIB : OUT std_logic_vector(NUM_IB*16-1 downto 0);
       PKTOUTIBCLK : OUT std_logic_vector(NUM_IB-1 downto 0);

       PKTINIB : IN std_logic_vector(NUM_IB*16-1 downto 0);
       PKTINIBCLK : IN std_logic_vector(NUM_IB-1 downto 0)
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
  type stin_type is (st0_idle, st1_wr_ibx, st1_wr_cfg);
  signal st_in : stin_type;

  signal dest : std_logic_vector(7 downto 0);
  signal rnw : std_logic;
  constant CONST_READ : std_logic := '1';
  constant CONST_WRITE : std_logic := '0';
  signal reg : std_logic_vector(6 downto 0);
  signal rst : std_logic;

  signal pktincfg : std_logic_vector(15 downto 0);
  signal pktincfgclk : std_logic;

  signal cfg_full, cfg_empty : std_logic;
  signal cfg_rdclk : std_logic;
  signal cfg_dout : std_logic_vector(15 downto 0);

  signal ib_dout : std_logic_vector(NUM_IB*16-1 downto 0);
  signal ib_rdclk, ib_full, ib_empty : std_logic_vector(NUM_IB-1 downto 0);

  signal reg_ib : std_logic_vector(7 downto 0) := "00000000";
  signal reg_ibx : std_logic_vector(NUM_IB*8-1 downto 0) := (others => '0');

  subtype ibnat is natural range 0 to NUM_IB-1;
  signal i, board_loop, active_board : ibnat := 0;

begin
  FIFO: for i in 0 to NUM_IB-1 generate
    Inst_ibfifo: pkt16buffer
    PORT MAP(
              din => PKTINIB(i*16+15 downto i*16),
              wr_clk => PKTINIBCLK(i),
              dout => ib_dout(i*16+15 downto i*16),
              rd_clk => ib_rdclk(i),
              full => ib_full(i),
              empty => ib_empty(i),
              rst => rst,
              wr_en => '1',
              rd_en => '1'
            );
  end generate FIFO;

  Inst_cfgfifo: pkt16buffer
  PORT MAP(
            din => pktincfg,
            wr_clk => pktincfgclk,
            dout => cfg_dout,
            rd_clk => cfg_rdclk,
            full => cfg_full,
            empty => cfg_empty,
            rst => rst,
            wr_en => '1',
            rd_en => '1'
          );


  rnw <= PKTBUS(0);
  reg <= PKTBUS(7 downto 1);

  HOSTOUT: process(RESET, CLK, PKTBUS, PKTBUSCLK)
  begin
    rst <= RESET;
    if RESET = '1' then
      PKTOUTADC <= x"0000";
      PKTOUTADCCLK <= '0';
      PKTOUTIB <= (others => '0');
      PKTOUTIBCLK <= "0000";

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
                    when others =>
                      if (reg and CONST_REG_IBx) /= 0 then
                        pktincfg(15 downto 8) <= reg_ibx(CONV_INTEGER(reg - CONST_REG_IBx)*8+7 downto CONV_INTEGER(reg - CONST_REG_IBx)*8);
                      end if;
                  end case;
                  pktincfg(0) <= CONST_READ;
                  pktincfg(7 downto 1) <= reg;
                  pktincfgclk <= '1';
                else --rnw = CONST_WRITE
                  case reg is
                    when others =>
                  end case;
                end if;

              when CONST_DEST_ADC =>
                PKTOUTADC <= PKTBUS;
                PKTOUTADCCLK <= '1';
              when others =>
                if (reg and CONST_REG_IBx) /= 0 then
                  PKTOUTIB(CONV_INTEGER(reg - CONST_REG_IBx)*16+15 downto CONV_INTEGER(reg - CONST_REG_IBx)*16) <= PKTBUS;
                  PKTOUTIBCLK(CONV_INTEGER(reg - CONST_REG_IBx)) <= '1';
                end if;
            end case;
            if PKTBUSCLK = '0' then
              st_out <= st3_high;
            end if;
          when st3_high =>
            PKTOUTADCCLK <= '0';
            PKTOUTIBCLK <= (others => '0');
            pktincfgclk <= '0';
            if PKTBUSCLK = '1' then
              st_out <= st0_magicdest;
            end if;
        end case;
      end if;
    end if;
  end process;

  HOSTIN: process(RESET, CLK, ib_empty, cfg_empty)
  begin
    if RESET = '1' then
      reg_ib <= "00000000";
      reg_ibx <= (others => '0');

      ib_rdclk <= (others => '0');
      cfg_rdclk <= '0';
      PKTINCLK <= '0';
      st_in <= st0_idle;
    else
      if CLK'event and CLK = '1' then
        case st_in is
          when st0_idle =>
            for board_loop in 0 to NUM_IB-1 loop
              if ib_empty(board_loop) = '0' then
                ib_rdclk <= (board_loop=>'1', others=>'0');
                active_board <= board_loop;
                st_in <= st1_wr_ibx;
              end if;
            end loop;

            if cfg_empty = '0' then
              cfg_rdclk <= '1';
              st_in <= st1_wr_cfg;
            else
              cfg_rdclk <= '0';
              PKTINCLK <= '0';
            end if;
          when st1_wr_ibx =>
            if ib_dout(active_board*8+7 downto active_board*8) = x"00" then
                reg_ib(active_board) <= '1';
                reg_ibx(active_board*8+7 downto active_board*8) <=
                ib_dout(active_board*16+15 downto active_board*16+8);
              else
                PKTIN <= ib_dout(active_board*16+15 downto active_board*16);
                PKTINCLK <= '1';
              end if;
            ib_rdclk <= (others => '0');
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
