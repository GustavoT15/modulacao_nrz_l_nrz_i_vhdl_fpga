------------------------------------------------------------------------
-- Bibliotecas IEEE
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- ENTITY: Modulador Unipolar NRZ-I com display em LEDs
-- Placa: Basys 3 (Artix-7) - Clock: 100 MHz
--
-- Sem botao i_start: reinicia automaticamente a cada mudanca de switch.
--
-- Regra NRZ-I:
--   bit '1' -> INVERTE o nivel no inicio do intervalo
--   bit '0' -> MANTEM o nivel
--
-- Saida PMOD JA pino 1 (J1) -> o_nrzi:
--   '1' durante todo o periodo estavel do bit quando nivel NRZ-I = 1
--   '0' durante todo o periodo estavel do bit quando nivel NRZ-I = 0
--   '0' no ciclo de transicao (inicio de cada bit, clk_count = 0)
--   '0' em DONE e durante restart
--
-- Forma de onda no Analog Discovery 3 para entrada "1 0 1":
--
--   nivel NRZ-I:  0->1    1->1    1->0
--
--   o_nrzi:  ░▓▓▓▓▓▓▓░░░░░░░░░▓▓▓▓▓▓▓░
--            |<- b2 ->|<- b1 ->|<- b0 ->|
--            ^        ^        ^
--          trans.   trans.   trans.  (clk_count=0, sempre '0')
--
-- LD0 permanece sempre aceso.
------------------------------------------------------------------------
entity nrzi_unipolar is
    generic (
        -- 100 MHz / 100.000 = 1 kHz -> cada bit dura 1 ms
        CYCLES_PER_BIT : positive := 100_000;
        DATA_WIDTH     : positive := 16
    );
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        i_data : in  std_logic_vector(DATA_WIDTH - 1 downto 0);

        -- Pino J1 do PMOD JA: nivel alto apenas durante periodo
        -- estavel do bit quando resultado NRZ-I for '1'
        o_nrzi : out std_logic;

        -- Indica fim de transmissao (disponivel internamente para LEDs)
        o_done : out std_logic;

        -- 16 LEDs: bit atual reflete nivel NRZ-I; LD0 sempre aceso
        o_leds : out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end entity nrzi_unipolar;


------------------------------------------------------------------------
-- ARCHITECTURE
------------------------------------------------------------------------
architecture rtl of nrzi_unipolar is

    type t_state is (TRANSMITTING, DONE);
    signal s_state     : t_state := TRANSMITTING;

    signal s_clk_count : integer range 0 to CYCLES_PER_BIT - 1 := 0;
    signal s_bit_index : integer range 0 to DATA_WIDTH - 1      := DATA_WIDTH - 1;
    signal s_data_reg  : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
    signal s_data_prev : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');

    -- Nivel logico NRZ-I atual (resultado acumulado das inversoes)
    signal s_nrzi_level : std_logic := '0';

    -- Saida para o pino J1: so vai a '1' no periodo estavel quando nivel = '1'
    signal s_nrzi_out   : std_logic := '0';

    signal s_leds       : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
    signal s_restart    : std_logic := '0';

begin

    process(clk, rst)
    begin
        if rst = '1' then
            s_state      <= TRANSMITTING;
            s_clk_count  <= 0;
            s_bit_index  <= DATA_WIDTH - 1;
            s_data_reg   <= (others => '0');
            s_data_prev  <= (others => '0');
            s_nrzi_level <= '0';
            s_nrzi_out   <= '0';
            s_restart    <= '0';
            s_leds       <= (others => '0');
            s_leds(0)    <= '1';

        elsif rising_edge(clk) then

            s_data_prev <= i_data;

            if i_data /= s_data_prev then
                s_restart <= '1';
            end if;

            case s_state is

                --------------------------------------------------------
                -- TRANSMITTING
                --------------------------------------------------------
                when TRANSMITTING =>

                    if s_restart = '1' then
                        -- Mudanca de switch: zera tudo e reinicia
                        s_data_reg   <= i_data;
                        s_bit_index  <= DATA_WIDTH - 1;
                        s_clk_count  <= 0;
                        s_nrzi_level <= '0';
                        s_nrzi_out   <= '0';
                        s_restart    <= '0';

                    else
                        if s_clk_count = 0 then
                            -- Ciclo de transicao: aplica inversao NRZ-I
                            -- e mantem saida em '0' durante este ciclo
                            if s_data_reg(s_bit_index) = '1' then
                                s_nrzi_level <= not s_nrzi_level;
                            end if;
                            s_nrzi_out <= '0';

                        else
                            -- Periodo estavel: saida reflete nivel NRZ-I atual
                            -- '1' se nivel alto, '0' se nivel baixo
                            s_nrzi_out <= s_nrzi_level;
                        end if;

                        -- LEDs: apenas o bit atual visivel
                        for i in 0 to DATA_WIDTH - 1 loop
                            if i = s_bit_index then
                                s_leds(i) <= s_nrzi_level;
                            else
                                s_leds(i) <= '0';
                            end if;
                        end loop;
                        s_leds(0) <= '1';

                        -- Contador de duracao do bit
                        if s_clk_count = CYCLES_PER_BIT - 1 then
                            s_clk_count <= 0;

                            if s_bit_index = 0 then
                                s_state <= DONE;
                            else
                                s_bit_index <= s_bit_index - 1;
                            end if;
                        else
                            s_clk_count <= s_clk_count + 1;
                        end if;
                    end if;

                --------------------------------------------------------
                -- DONE: exibe dado completo, zera saida e reinicia
                --------------------------------------------------------
                when DONE =>
                    s_nrzi_out   <= '0';
                    s_nrzi_level <= '0';
                    s_leds       <= s_data_reg;
                    s_leds(0)    <= '1';

                    s_data_reg  <= i_data;
                    s_bit_index <= DATA_WIDTH - 1;
                    s_clk_count <= 0;
                    s_restart   <= '0';
                    s_state     <= TRANSMITTING;

                when others =>
                    s_state <= TRANSMITTING;

            end case;
        end if;
    end process;

    --------------------------------------------------------------------
    -- Atribuicoes de saida
    --------------------------------------------------------------------
    o_nrzi <= s_nrzi_out;
    o_done <= '1' when s_state = DONE else '0';
    o_leds <= s_leds;

end architecture rtl;