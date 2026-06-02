------------------------------------------------------------------------
-- Testbench: nrzl_unipolar_tb
-- DUT: nrzl_unipolar
--
-- O que entra no DUT:
--   clk    : clock de 100 MHz simulado (periodo 10 ns)
--   rst    : reset assincrono, ativo em '1'
--   i_data : "1010101011110000" (16 switches simulados)
--
-- O que e verificado:
--   o_leds : apenas o LED do bit em transmissao deve estar ativo
--            e seu valor deve corresponder ao bit NRZ-L (0 ou 1)
--   o_nrzl : deve ser identico ao bit atual (sinal para PMOD)
--   o_done : deve ir a '1' apos o ultimo bit ser transmitido
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nrzl_unipolar_tb is
end entity nrzl_unipolar_tb;

architecture sim of nrzl_unipolar_tb is

    --------------------------------------------------------------------
    -- Constantes
    --------------------------------------------------------------------
    constant C_CLK_PERIOD : time     := 10 ns;  -- 100 MHz
    constant C_CPB        : positive := 4;       -- ciclos por bit na sim
    constant C_DATA_WIDTH : positive := 16;

    -- Entrada de teste: 1010_1010_1111_0000
    constant C_DATA_IN : std_logic_vector(C_DATA_WIDTH - 1 downto 0)
                       := "1010101011110000";

    --------------------------------------------------------------------
    -- Sinais do DUT
    --------------------------------------------------------------------
    signal clk    : std_logic := '0';
    signal rst    : std_logic := '0';
    signal i_data : std_logic_vector(C_DATA_WIDTH - 1 downto 0) := (others => '0');

    signal o_nrzl : std_logic;
    signal o_done : std_logic;
    signal o_leds : std_logic_vector(C_DATA_WIDTH - 1 downto 0);

begin

    --------------------------------------------------------------------
    -- Instancia do DUT
    --------------------------------------------------------------------
    DUT : entity work.nrzl_unipolar
        generic map (
            CYCLES_PER_BIT => C_CPB,
            DATA_WIDTH     => C_DATA_WIDTH
        )
        port map (
            clk    => clk,
            rst    => rst,
            i_data => i_data,
            o_nrzl => o_nrzl,
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

        -- Aplica a entrada de 16 bits
        -- i_data = 1010_1010_1111_0000
        --
        -- Sequencia esperada nos LEDs e no PMOD (MSB -> LSB):
        --   Bit 15 = '1' -> LED15 aceso,   o_nrzl = '1'
        --   Bit 14 = '0' -> LED14 apagado, o_nrzl = '0'
        --   Bit 13 = '1' -> LED13 aceso,   o_nrzl = '1'
        --   Bit 12 = '0' -> LED12 apagado, o_nrzl = '0'
        --   Bit 11 = '1' -> LED11 aceso,   o_nrzl = '1'
        --   Bit 10 = '0' -> LED10 apagado, o_nrzl = '0'
        --   Bit  9 = '1' -> LED9  aceso,   o_nrzl = '1'
        --   Bit  8 = '0' -> LED8  apagado, o_nrzl = '0'
        --   Bit  7 = '1' -> LED7  aceso,   o_nrzl = '1'
        --   Bit  6 = '1' -> LED6  aceso,   o_nrzl = '1'
        --   Bit  5 = '1' -> LED5  aceso,   o_nrzl = '1'
        --   Bit  4 = '1' -> LED4  aceso,   o_nrzl = '1'
        --   Bit  3 = '0' -> LED3  apagado, o_nrzl = '0'
        --   Bit  2 = '0' -> LED2  apagado, o_nrzl = '0'
        --   Bit  1 = '0' -> LED1  apagado, o_nrzl = '0'
        --   Bit  0 = '0' -> LED0  apagado, o_nrzl = '0'
        --   Apos bit 0   -> o_done = '1'
        i_data <= C_DATA_IN;

        -- Aguarda 1 ciclo de deteccao de mudanca de i_data
        wait for C_CLK_PERIOD;

        -- Verifica cada bit no meio do seu intervalo
        for bit_num in 15 downto 0 loop

            -- Avanca ate o meio do intervalo do bit atual
            wait for (C_CPB / 2) * C_CLK_PERIOD;

            -- Verifica o_leds
            if o_leds(bit_num) /= C_DATA_IN(bit_num) then
                report "ERRO: o_leds(" & integer'image(bit_num) & ")" &
                       " esperado=" & std_logic'image(C_DATA_IN(bit_num)) &
                       " obtido="   & std_logic'image(o_leds(bit_num))
                severity error;
            end if;

            -- Verifica o_nrzl
            if o_nrzl /= C_DATA_IN(bit_num) then
                report "ERRO: o_nrzl no bit " & integer'image(bit_num) &
                       " esperado=" & std_logic'image(C_DATA_IN(bit_num)) &
                       " obtido="   & std_logic'image(o_nrzl)
                severity error;
            end if;

            -- Avanca ate o fim do intervalo do bit
            wait for (C_CPB / 2) * C_CLK_PERIOD;

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