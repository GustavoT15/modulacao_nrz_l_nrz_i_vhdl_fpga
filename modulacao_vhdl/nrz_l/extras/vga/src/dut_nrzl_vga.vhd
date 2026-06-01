------------------------------------------------------------------------
-- Bibliotecas IEEE
------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

------------------------------------------------------------------------
-- ENTITY: NRZ-L Unipolar com VGA e PMOD
-- Placa  : Basys 3 (Artix-7) - Clock: 100 MHz
--
-- Regra NRZ-L:
--   bit '1' -> nivel alto  -> tela VERDE
--   bit '0' -> nivel baixo -> tela VERMELHA
--
-- Taxa de bit controlada por TICKS_PER_BIT:
--   100_000_000 = 1 segundo por bit  (muito lento, ideal para demo)
--    50_000_000 = 500 ms por bit
--    25_000_000 = 250 ms por bit
--     5_000_000 = 50 ms  por bit
--
-- Saidas:
--   nrz_out -> LEDs: bit atual espelhado no LED correspondente
--   tx_pmod -> PMOD pino A14: forma de onda para Analog Discovery 3
--   vga_*   -> VGA 640x480 @ 60 Hz
--
-- LD0 permanece sempre aceso.
------------------------------------------------------------------------
entity nrz_l is
    Generic (
        DATA_WIDTH    : integer := 16;
        TICKS_PER_BIT : integer := 50_000_000  -- 500 ms por bit
    );
    Port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;

        -- 16 switches: entrada de dados
        data_in : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);

        -- LEDs: espelham o bit atual sendo transmitido
        -- LD0 sempre aceso; LED do bit atual reflete nivel NRZ-L
        nrz_out : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);

        -- PMOD: saida analogica para Analog Discovery 3
        tx_pmod : out STD_LOGIC;

        -- VGA 640x480 @ 60 Hz
        vga_r   : out STD_LOGIC_VECTOR(3 downto 0);
        vga_g   : out STD_LOGIC_VECTOR(3 downto 0);
        vga_b   : out STD_LOGIC_VECTOR(3 downto 0);
        vga_hs  : out STD_LOGIC;
        vga_vs  : out STD_LOGIC
    );
end nrz_l;


architecture Behavioral of nrz_l is

    --------------------------------------------------------------------
    -- Sinais NRZ-L
    --------------------------------------------------------------------
    signal bit_ptr      : integer range 0 to DATA_WIDTH - 1 := DATA_WIDTH - 1;
    signal tick_counter : integer range 0 to TICKS_PER_BIT - 1 := 0;
    signal current_bit  : STD_LOGIC := '0';

    -- Amostra anterior para deteccao de mudanca de switch
    signal data_prev    : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0) := (others => '0');

    --------------------------------------------------------------------
    -- Sinais VGA (640x480 @ 60 Hz, pixel clock 25 MHz)
    --------------------------------------------------------------------
    signal clk_div25  : integer range 0 to 3 := 0;
    signal vga_clk_en : boolean := false;
    signal h_cnt      : integer range 0 to 799 := 0;
    signal v_cnt      : integer range 0 to 524 := 0;

    -- Parametros VGA 640x480
    constant H_ACTIVE : integer := 640;
    constant H_FP     : integer := 16;
    constant H_SYNC   : integer := 96;
    constant H_BP     : integer := 48;

    constant V_ACTIVE : integer := 480;
    constant V_FP     : integer := 10;
    constant V_SYNC   : integer := 2;
    constant V_BP     : integer := 33;

begin

    -- =================================================================
    -- NRZ-L: transmissor com reinicio automatico por mudanca de switch
    -- =================================================================
    process(clk, reset)
    begin
        if reset = '1' then
            bit_ptr      <= DATA_WIDTH - 1;
            tick_counter <= 0;
            data_prev    <= (others => '0');

        elsif rising_edge(clk) then

            data_prev <= data_in;

            -- Reinicia do MSB sempre que qualquer switch mudar
            if data_in /= data_prev then
                bit_ptr      <= DATA_WIDTH - 1;
                tick_counter <= 0;

            elsif tick_counter < TICKS_PER_BIT - 1 then
                tick_counter <= tick_counter + 1;

            else
                tick_counter <= 0;
                if bit_ptr = 0 then
                    bit_ptr <= DATA_WIDTH - 1;  -- reinicia apos ultimo bit
                else
                    bit_ptr <= bit_ptr - 1;
                end if;
            end if;
        end if;
    end process;

    -- Bit atual da sequencia
    current_bit <= data_in(bit_ptr);

    -- PMOD: forma de onda NRZ-L direta
    tx_pmod <= current_bit;

    -- LEDs: apenas o LED do bit atual reflete o nivel NRZ-L
    -- Todos os LEDs se comportam igual: acende se bit='1', apaga se bit='0'
    process(bit_ptr, current_bit)
    begin
        nrz_out <= (others => '0');
        nrz_out(bit_ptr) <= current_bit;
    end process;

    -- =================================================================
    -- VGA: divisor de clock 100 MHz -> 25 MHz
    -- =================================================================
    process(clk)
    begin
        if rising_edge(clk) then
            if clk_div25 = 3 then
                clk_div25 <= 0;
                vga_clk_en <= true;
            else
                clk_div25 <= clk_div25 + 1;
                vga_clk_en <= false;
            end if;
        end if;
    end process;

    -- =================================================================
    -- VGA: contadores horizontal e vertical
    -- =================================================================
    process(clk, reset)
    begin
        if reset = '1' then
            h_cnt <= 0;
            v_cnt <= 0;
        elsif rising_edge(clk) then
            if vga_clk_en then
                if h_cnt = 799 then
                    h_cnt <= 0;
                    if v_cnt = 524 then
                        v_cnt <= 0;
                    else
                        v_cnt <= v_cnt + 1;
                    end if;
                else
                    h_cnt <= h_cnt + 1;
                end if;
            end if;
        end if;
    end process;

    -- =================================================================
    -- VGA: sincronismo e cor
    -- =================================================================
    process(clk)
    begin
        if rising_edge(clk) then

            -- Sync horizontal (ativo baixo)
            if (h_cnt >= H_ACTIVE + H_FP) and
               (h_cnt <  H_ACTIVE + H_FP + H_SYNC) then
                vga_hs <= '0';
            else
                vga_hs <= '1';
            end if;

            -- Sync vertical (ativo baixo)
            if (v_cnt >= V_ACTIVE + V_FP) and
               (v_cnt <  V_ACTIVE + V_FP + V_SYNC) then
                vga_vs <= '0';
            else
                vga_vs <= '1';
            end if;

            -- Cor da tela baseada no nivel NRZ-L atual
            if (h_cnt < H_ACTIVE) and (v_cnt < V_ACTIVE) then
                if current_bit = '1' then
                    -- Nivel alto -> VERDE
                    vga_r <= "0000";
                    vga_g <= "1111";
                    vga_b <= "0000";
                else
                    -- Nivel baixo -> VERMELHO
                    vga_r <= "1111";
                    vga_g <= "0000";
                    vga_b <= "0000";
                end if;
            else
                -- Blanking: zera cores (obrigatorio pelo padrao VGA)
                vga_r <= "0000";
                vga_g <= "0000";
                vga_b <= "0000";
            end if;

        end if;
    end process;

end Behavioral;
