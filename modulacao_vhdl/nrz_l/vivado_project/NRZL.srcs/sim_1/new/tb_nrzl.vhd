------------------------------------------------------------------------
-- Testbench: nrzl_unipolar_tb
-- Simula a transmissao de um vetor de 16 bits
-- Para usar no Vivado: adicione como fonte de simulacao
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nrzl_unipolar_tb is
end entity nrzl_unipolar_tb;

architecture sim of nrzl_unipolar_tb is

    --------------------------------------------------------------------
    -- Constantes de simulacao
    -- Usando CYCLES_PER_BIT pequeno para a simulacao ser rapida
    --------------------------------------------------------------------
    constant C_CLK_PERIOD   : time     := 10 ns;   -- 100 MHz
    constant C_CPB          : positive := 10;       -- 10 ciclos por bit na sim
    constant C_DATA_WIDTH   : positive := 16;

    --------------------------------------------------------------------
    -- Sinais do DUT
    --------------------------------------------------------------------
    signal clk     : std_logic := '0';
    signal rst     : std_logic := '0';
    signal i_start : std_logic := '0';
    signal i_data  : std_logic_vector(C_DATA_WIDTH - 1 downto 0) := (others => '0');
    signal o_nrzl  : std_logic;
    signal o_done  : std_logic;
    signal o_leds  : std_logic_vector(C_DATA_WIDTH - 1 downto 0);

begin

    --------------------------------------------------------------------
    -- Instancia do DUT com parametros de simulacao
    --------------------------------------------------------------------
    DUT : entity work.nrzl_unipolar
        generic map (
            CYCLES_PER_BIT => C_CPB,
            DATA_WIDTH     => C_DATA_WIDTH
        )
        port map (
            clk     => clk,
            rst     => rst,
            i_start => i_start,
            i_data  => i_data,
            o_nrzl  => o_nrzl,
            o_done  => o_done,
            o_leds  => o_leds
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
        rst    <= '1';
        wait for 5 * C_CLK_PERIOD;
        rst    <= '0';
        wait for 2 * C_CLK_PERIOD;

        -- Define o dado: 1010_1010_1111_0000
        i_data <= "1010101011110000";

        -- Pulsa i_start
        i_start <= '1';
        wait for C_CLK_PERIOD;

        -- Aguarda transmissao completa (16 bits x 10 ciclos + margem)
        wait until o_done = '1';
        wait for 5 * C_CLK_PERIOD;

        -- Libera start para retornar ao IDLE
        i_start <= '0';
        wait for 5 * C_CLK_PERIOD;

        -- Segunda transmissao com dado diferente: 1111_1111_0000_0000
        i_data  <= "1111111100000000";
        i_start <= '1';
        wait until o_done = '1';
        wait for 3 * C_CLK_PERIOD;
        i_start <= '0';

        wait for 20 * C_CLK_PERIOD;

        -- Fim da simulacao
        report "Simulacao concluida com sucesso." severity note;
        wait;
    end process stim;

end architecture sim;