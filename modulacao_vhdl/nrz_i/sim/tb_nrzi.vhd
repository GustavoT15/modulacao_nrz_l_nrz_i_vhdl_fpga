------------------------------------------------------------------------
-- Testbench: nrzi_unipolar_tb
-- DUT: nrzi_unipolar
--
-- O que entra no DUT:
--   clk    : clock de 100 MHz simulado (periodo 10 ns)
--   rst    : reset assincrono, ativo em '1'
--   i_data : "0110100101011100"
--
-- Calculo dos niveis NRZ-I esperados (nivel inicial = '0'):
--
--   Bit 15='0' -> mantem  -> nivel='0'  | LED15 apagado
--   Bit 14='1' -> inverte -> nivel='1'  | LED14 aceso
--   Bit 13='1' -> inverte -> nivel='0'  | LED13 apagado
--   Bit 12='0' -> mantem  -> nivel='0'  | LED12 apagado
--   Bit 11='1' -> inverte -> nivel='1'  | LED11 aceso
--   Bit 10='0' -> mantem  -> nivel='1'  | LED10 aceso
--   Bit  9='0' -> mantem  -> nivel='1'  | LED9  aceso
--   Bit  8='1' -> inverte -> nivel='0'  | LED8  apagado
--   Bit  7='0' -> mantem  -> nivel='0'  | LED7  apagado
--   Bit  6='1' -> inverte -> nivel='1'  | LED6  aceso
--   Bit  5='0' -> mantem  -> nivel='1'  | LED5  aceso
--   Bit  4='1' -> inverte -> nivel='0'  | LED4  apagado
--   Bit  3='1' -> inverte -> nivel='1'  | LED3  aceso
--   Bit  2='1' -> inverte -> nivel='0'  | LED2  apagado
--   Bit  1='0' -> mantem  -> nivel='0'  | LED1  apagado
--   Bit  0='0' -> mantem  -> nivel='0'  | LED0  apagado
--
-- O que e verificado:
--   o_nrzi : '0' no ciclo de transicao; nivel acumulado no periodo estavel
--   o_leds : LED do bit atual reflete o nivel NRZ-I
--   o_done : '1' apos o ultimo bit
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nrzi_unipolar_tb is
end entity nrzi_unipolar_tb;

architecture sim of nrzi_unipolar_tb is

    --------------------------------------------------------------------
    -- Constantes
    --------------------------------------------------------------------
    constant C_CLK_PERIOD : time     := 10 ns;
    constant C_CPB        : positive := 4;       -- ciclos por bit na sim
    constant C_DATA_WIDTH : positive := 16;

    constant C_DATA_IN : std_logic_vector(C_DATA_WIDTH - 1 downto 0)
                       := "0110100101011100";

    -- Niveis NRZ-I esperados para cada bit
    type t_level_array is array(15 downto 0) of std_logic;
    constant C_EXPECTED_LEVEL : t_level_array := (
        15 => '0',  -- bit='0' mantem  0
        14 => '1',  -- bit='1' inverte 0->1
        13 => '0',  -- bit='1' inverte 1->0
        12 => '0',  -- bit='0' mantem  0
        11 => '1',  -- bit='1' inverte 0->1
        10 => '1',  -- bit='0' mantem  1
         9 => '1',  -- bit='0' mantem  1
         8 => '0',  -- bit='1' inverte 1->0
         7 => '0',  -- bit='0' mantem  0
         6 => '1',  -- bit='1' inverte 0->1
         5 => '1',  -- bit='0' mantem  1
         4 => '0',  -- bit='1' inverte 1->0
         3 => '1',  -- bit='1' inverte 0->1
         2 => '0',  -- bit='1' inverte 1->0
         1 => '0',  -- bit='0' mantem  0
         0 => '0'   -- bit='0' mantem  0
    );

    --------------------------------------------------------------------
    -- Sinais do DUT
    --------------------------------------------------------------------
    signal clk    : std_logic := '0';
    signal rst    : std_logic := '0';
    signal i_data : std_logic_vector(C_DATA_WIDTH - 1 downto 0) := (others => '0');

    signal o_nrzi : std_logic;
    signal o_done : std_logic;
    signal o_leds : std_logic_vector(C_DATA_WIDTH - 1 downto 0);

begin

    --------------------------------------------------------------------
    -- Instancia do DUT
    --------------------------------------------------------------------
    DUT : entity work.nrzi_unipolar
        generic map (
            CYCLES_PER_BIT => C_CPB,
            DATA_WIDTH     => C_DATA_WIDTH
        )
        port map (
            clk    => clk,
            rst    => rst,
            i_data => i_data,
            o_nrzi => o_nrzi,
            o_done => o_done,
            o_leds => o_leds
        );

    --------------------------------------------------------------------
    -- Geracao de clock
    --------------------------------------------------------------------
    clk <= not clk after C_CLK_PERIOD / 2;

    --------------------------------------------------------------------
    -- Estimulos
    --------------------------------------------------------------------
    stim : process
    begin

        -- Reset inicial
        rst <= '1';
        wait for 4 * C_CLK_PERIOD;
        rst <= '0';
        wait for 2 * C_CLK_PERIOD;

        -- Aplica entrada: 0110_1001_0101_1100
        i_data <= C_DATA_IN;

        -- Aguarda ciclo de deteccao de mudanca
        wait for C_CLK_PERIOD;

        -- Verifica cada bit
        for bit_num in 15 downto 0 loop

            -- Ciclo de transicao: o_nrzi deve ser '0'
            wait for C_CLK_PERIOD;
            if o_nrzi /= '0' then
                report "ERRO: o_nrzi no ciclo de transicao do bit " &
                       integer'image(bit_num) &
                       " esperado='0' obtido=" & std_logic'image(o_nrzi)
                severity error;
            end if;

            -- Meio do periodo estavel
            wait for ((C_CPB - 1) / 2) * C_CLK_PERIOD;

            -- Verifica o_nrzi no periodo estavel
            if o_nrzi /= C_EXPECTED_LEVEL(bit_num) then
                report "ERRO: o_nrzi bit " & integer'image(bit_num) &
                       " esperado=" & std_logic'image(C_EXPECTED_LEVEL(bit_num)) &
                       " obtido="   & std_logic'image(o_nrzi)
                severity error;
            end if;

            -- Verifica o_leds
            if o_leds(bit_num) /= C_EXPECTED_LEVEL(bit_num) then
                report "ERRO: o_leds(" & integer'image(bit_num) & ")" &
                       " esperado=" & std_logic'image(C_EXPECTED_LEVEL(bit_num)) &
                       " obtido="   & std_logic'image(o_leds(bit_num))
                severity error;
            end if;

            -- Fim do intervalo do bit
            wait for ((C_CPB - 1) - (C_CPB - 1) / 2) * C_CLK_PERIOD;

        end loop;

        -- Verifica o_done apos o ultimo bit
        wait for C_CLK_PERIOD;
        if o_done /= '1' then
            report "ERRO: o_done nao foi para '1' apos transmissao completa"
            severity error;
        end if;

        report "Simulacao concluida com sucesso." severity note;
        wait;

    end process stim;

end architecture sim;