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
  type stin_type is (st0_idle, st1_wr_iba, st1_wr_ibb, st1_wr_cfg);
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

  signal i : integer;

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
                    --when CONST_REG_IBA =>
                    --  pktincfg(15 downto 8) <= reg_iba;
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

              --when CONST_DEST_IBA =>
              --  PKTOUTA <= PKTBUS;
              --  PKTOUTACLK <= '1';

              when others =>
            end case;
            if PKTBUSCLK = '0' then
              st_out <= st3_high;
            end if;
          when st3_high =>
            PKTOUTADCCLK <= '0';
            --PKTOUTACLK <= '0';
            --PKTOUTBCLK <= '0';
            pktincfgclk <= '0';
            if PKTBUSCLK = '1' then
              st_out <= st0_magicdest;
            end if;
        end case;
      end if;
    end if;
  end process;

  HOSTIN: process(RESET, CLK, cfg_empty)
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
            --if iba_empty = '0' then
            -- iba_rdclk <= '1';
            -- st_in <= st1_wr_iba;
            --elsif ibb_empty = '0' then
            -- ibb_rdclk <= '1';
            -- st_in <= st1_wr_ibb;
            --els
            if cfg_empty = '0' then
              cfg_rdclk <= '1';
              st_in <= st1_wr_cfg;
            else
            --  iba_rdclk <= '0';
            --  ibb_rdclk <= '0';
              cfg_rdclk <= '0';
              PKTINCLK <= '0';
            end if;
          --when st1_wr_iba =>
            -- Check for special commands
           -- case iba_dout(7 downto 0) is
            --  when x"00" =>
             --   reg_ib(0) <= '1';
              --  reg_iba <= iba_dout(15 downto 8);
             -- when others =>
              --  PKTIN <= iba_dout;
               -- PKTINCLK <= '1';
            --end case;
            --iba_rdclk <= '0';
            --st_in <= st0_idle;
          --when st1_wr_ibb =>
            -- Check for special commands
           -- case ibb_dout(7 downto 0) is
            --  when x"00" =>
             --   reg_ib(1) <= '1';
              --  reg_ibb <= ibb_dout(15 downto 8);
             -- when others =>
              --  PKTIN <= ibb_dout;
               -- PKTINCLK <= '1';
           -- end case;
           -- ibb_rdclk <= '0';
           -- st_in <= st0_idle;
          when st1_wr_cfg =>
            PKTIN <= cfg_dout;
            PKTINCLK <= '1';
            cfg_rdclk <= '0';
            st_in <= st0_idle;
          when others =>
        end case;
      end if;
    end if;
  end process;
end Behavioral;
