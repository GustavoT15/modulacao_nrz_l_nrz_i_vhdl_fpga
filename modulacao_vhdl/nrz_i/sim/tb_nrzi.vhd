------------------------------------------------------------------------
-- Testbench: nrzi_unipolar_tb
-- Simula a transmissao de vetores de 16 bits em NRZ-I
-- Para usar no Vivado: adicione como fonte de simulacao
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nrzi_unipolar_tb is
end entity nrzi_unipolar_tb;

architecture sim of nrzi_unipolar_tb is

    constant C_CLK_PERIOD : time     := 10 ns;   -- 100 MHz
    constant C_CPB        : positive := 10;       -- 10 ciclos por bit na sim
    constant C_DATA_WIDTH : positive := 16;

    signal clk     : std_logic := '0';
    signal rst     : std_logic := '0';
    signal i_start : std_logic := '0';
    signal i_data  : std_logic_vector(C_DATA_WIDTH - 1 downto 0) := (others => '0');
    signal o_nrzi  : std_logic;
    signal o_done  : std_logic;
    signal o_leds  : std_logic_vector(C_DATA_WIDTH - 1 downto 0);

begin

    DUT : entity work.nrzi_unipolar
        generic map (
            CYCLES_PER_BIT => C_CPB,
            DATA_WIDTH     => C_DATA_WIDTH
        )
        port map (
            clk     => clk,
            rst     => rst,
            i_start => i_start,
            i_data  => i_data,
            o_nrzi  => o_nrzi,
            o_done  => o_done,
            o_leds  => o_leds
        );

    -- Geracao de clock
    clk <= not clk after C_CLK_PERIOD / 2;

    stim : process
    begin
        -- Reset inicial
        rst <= '1';
        wait for 5 * C_CLK_PERIOD;
        rst <= '0';
        wait for 2 * C_CLK_PERIOD;

        -- Teste 1: 1010_1010_1111_0000
        -- NRZ-I: cada '1' inverte, cada '0' mantem
        -- Nivel inicial: 0
        -- Bit15='1' -> 1, Bit14='0' -> 1, Bit13='1' -> 0, Bit12='0' -> 0 ...
        i_data  <= "1010101011110000";
        i_start <= '1';
        wait until o_done = '1';
        wait for 5 * C_CLK_PERIOD;
        i_start <= '0';
        wait for 5 * C_CLK_PERIOD;

        -- Teste 2: todos '1' -> inverte a cada bit (alterna 0,1,0,1,...)
        i_data  <= "1111111111111111";
        i_start <= '1';
        wait until o_done = '1';
        wait for 5 * C_CLK_PERIOD;
        i_start <= '0';
        wait for 5 * C_CLK_PERIOD;

        -- Teste 3: todos '0' -> nivel nunca muda (permanece 0)
        i_data  <= "0000000000000000";
        i_start <= '1';
        wait until o_done = '1';
        wait for 5 * C_CLK_PERIOD;
        i_start <= '0';

        wait for 20 * C_CLK_PERIOD;
        report "Simulacao NRZ-I concluida com sucesso." severity note;
        wait;
    end process stim;

end architecture sim;