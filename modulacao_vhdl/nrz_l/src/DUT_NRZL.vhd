------------------------------------------------------------------------
-- Bibliotecas IEEE
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- ENTITY: Modulador Unipolar NRZ-L com display em LEDs
-- Placa: Basys 3 (Artix-7)
-- Clock: 100 MHz
-- 16 switches -> 16 bits de entrada
-- 16 LEDs    -> saida NRZ-L bit a bit (LED aceso = nivel alto)
--
-- Sem botao i_start: a transmissao inicia e reinicia automaticamente
-- sempre que qualquer switch for alterado. Se uma chave mudar durante
-- a transmissao, o circuito abandona a sequencia atual e recomeça
-- do MSB com o novo valor capturado.
--
-- Regra NRZ-L:
--   bit '1' -> nivel alto  (LED aceso)
--   bit '0' -> nivel baixo (LED apagado)
-- LD0 permanece sempre aceso em qualquer estado.
------------------------------------------------------------------------
entity nrzl_unipolar is
    generic (
        -- Numero de ciclos de clock por intervalo de bit
        -- 100 MHz / 100.000 = 1 kHz => cada bit dura 1 ms
        CYCLES_PER_BIT : positive := 100_000;

        -- Largura do vetor (16 switches da Basys 3)
        DATA_WIDTH     : positive := 16
    );
    port (
        ------------------------------------------------------------
        -- Entradas de controle
        ------------------------------------------------------------
        clk    : in  std_logic;  -- Clock 100 MHz (W5 na Basys 3)
        rst    : in  std_logic;  -- Reset assincrono, ativo em '1' (BTNC)

        ------------------------------------------------------------
        -- Entrada de dados: 16 switches da Basys 3
        -- SW(15) = MSB, SW(0) = LSB
        ------------------------------------------------------------
        i_data : in  std_logic_vector(DATA_WIDTH - 1 downto 0);

        ------------------------------------------------------------
        -- Saidas
        ------------------------------------------------------------
        -- Sinal NRZ-L modulado (pino externo, PMOD)
        o_nrzl : out std_logic;

        -- Indica que uma transmissao completa foi concluida (PMOD)
        o_done : out std_logic;

        -- 16 LEDs: o LED do bit atual reflete o nivel NRZ-L corrente
        -- LD0 permanece sempre aceso
        o_leds : out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end entity nrzl_unipolar;


------------------------------------------------------------------------
-- ARCHITECTURE
------------------------------------------------------------------------
architecture rtl of nrzl_unipolar is

    -- Estados da FSM (sem IDLE: inicia direto em TRANSMITTING)
    type t_state is (TRANSMITTING, DONE);
    signal s_state : t_state := TRANSMITTING;

    -- Contador de ciclos dentro do intervalo de bit atual
    signal s_clk_count : integer range 0 to CYCLES_PER_BIT - 1 := 0;

    -- Indice do bit sendo transmitido (MSB = DATA_WIDTH-1 primeiro)
    signal s_bit_index : integer range 0 to DATA_WIDTH - 1 := DATA_WIDTH - 1;

    -- Registrador interno: captura i_data no inicio de cada transmissao
    signal s_data_reg  : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');

    -- Amostra anterior de i_data para deteccao de mudanca
    signal s_data_prev : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');

    -- Nivel NRZ-L atual
    signal s_nrzl      : std_logic := '0';

    -- Vetor de LEDs interno
    signal s_leds      : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');

    -- Flag interna: sinaliza que i_data mudou e e preciso reiniciar
    signal s_restart   : std_logic := '0';

begin

    --------------------------------------------------------------------
    -- Processo sincrono: FSM + deteccao de mudanca + contadores
    --------------------------------------------------------------------
    process(clk, rst)
    begin
        if rst = '1' then
            s_state     <= TRANSMITTING;
            s_clk_count <= 0;
            s_bit_index <= DATA_WIDTH - 1;
            s_data_reg  <= (others => '0');
            s_data_prev <= (others => '0');
            s_nrzl      <= '0';
            s_restart   <= '0';
            s_leds      <= (others => '0');

        elsif rising_edge(clk) then

            -- Registra i_data do ciclo anterior para comparacao
            s_data_prev <= i_data;

            -- Se qualquer switch mudou desde o ultimo ciclo, sinaliza reinicio
            if i_data /= s_data_prev then
                s_restart <= '1';
            end if;

            case s_state is

                --------------------------------------------------------
                -- TRANSMITTING: emite cada bit pelo numero de ciclos
                -- Se s_restart='1', abandona e recomeça do MSB
                --------------------------------------------------------
                when TRANSMITTING =>

                    if s_restart = '1' then
                        -- Mudanca detectada: captura novo dado e reinicia
                        s_data_reg  <= i_data;
                        s_bit_index <= DATA_WIDTH - 1;
                        s_clk_count <= 0;
                        s_nrzl      <= '0';
                        s_restart   <= '0';

                    else
                        -- Modulacao NRZ-L: nivel direto do bit atual
                        if s_data_reg(s_bit_index) = '1' then
                            s_nrzl <= '1';
                        else
                            s_nrzl <= '0';
                        end if;

                        -- Atualiza LEDs: apenas o LED do bit atual aceso/apagado
                        -- conforme valor do bit; demais ficam apagados
                        for i in 0 to DATA_WIDTH - 1 loop
                            if i = s_bit_index then
                                s_leds(i) <= s_data_reg(i);
                            else
                                s_leds(i) <= '0';
                            end if;
                        end loop;

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
                -- DONE: transmissao concluida por um ciclo
                -- Mostra o dado completo nos LEDs e ja prepara
                -- o proximo ciclo de transmissao com o valor atual
                -- dos switches
                --------------------------------------------------------
                when DONE =>
                    s_nrzl <= '0';
                    s_leds <= s_data_reg;

                    -- Prepara nova transmissao imediatamente
                    s_data_reg  <= i_data;
                    s_bit_index <= DATA_WIDTH - 1;
                    s_clk_count <= 0;
                    s_nrzl      <= '0';
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
    o_nrzl <= s_nrzl;
    o_done <= '1' when s_state = DONE else '0';
    o_leds <= s_leds;

end architecture rtl;