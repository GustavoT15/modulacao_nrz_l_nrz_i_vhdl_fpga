## ============================================================
## Constraints XDC - Basys 3 (Artix-7 XC7A35T-1CPG236C)
## Projeto: Modulador Unipolar NRZ-L
## ============================================================

## ------------------------------------------------------------
## Clock de 100 MHz (pino W5)
## ------------------------------------------------------------
set_property PACKAGE_PIN W5      [get_ports clk]
set_property IOSTANDARD  LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## ------------------------------------------------------------
## Reset assincrono -> BTNC (botao central)
## ------------------------------------------------------------
set_property PACKAGE_PIN U18     [get_ports rst]
set_property IOSTANDARD  LVCMOS33 [get_ports rst]

## ------------------------------------------------------------
## Switches SW[15:0] -> entrada de dados
## ------------------------------------------------------------
set_property PACKAGE_PIN V17     [get_ports {i_data[0]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {i_data[0]}]

set_property PACKAGE_PIN V16     [get_ports {i_data[1]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {i_data[1]}]

set_property PACKAGE_PIN W16     [get_ports {i_data[2]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {i_data[2]}]

set_property PACKAGE_PIN W17     [get_ports {i_data[3]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {i_data[3]}]

set_property PACKAGE_PIN W15     [get_ports {i_data[4]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {i_data[4]}]

set_property PACKAGE_PIN V15     [get_ports {i_data[5]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {i_data[5]}]

set_property PACKAGE_PIN W14     [get_ports {i_data[6]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {i_data[6]}]

set_property PACKAGE_PIN W13     [get_ports {i_data[7]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {i_data[7]}]

set_property PACKAGE_PIN V2      [get_ports {i_data[8]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {i_data[8]}]

set_property PACKAGE_PIN T3      [get_ports {i_data[9]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {i_data[9]}]

set_property PACKAGE_PIN T2      [get_ports {i_data[10]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {i_data[10]}]

set_property PACKAGE_PIN R3      [get_ports {i_data[11]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {i_data[11]}]

set_property PACKAGE_PIN W2      [get_ports {i_data[12]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {i_data[12]}]

set_property PACKAGE_PIN U1      [get_ports {i_data[13]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {i_data[13]}]

set_property PACKAGE_PIN T1      [get_ports {i_data[14]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {i_data[14]}]

set_property PACKAGE_PIN R2      [get_ports {i_data[15]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {i_data[15]}]

## ------------------------------------------------------------
## LEDs LD[15:0] -> exibicao NRZ-L bit a bit
## LED aceso  = bit '1' (nivel alto)
## LED apagado = bit '0' (nivel baixo)
## ------------------------------------------------------------
set_property PACKAGE_PIN U16     [get_ports {o_leds[0]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {o_leds[0]}]

set_property PACKAGE_PIN E19     [get_ports {o_leds[1]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {o_leds[1]}]

set_property PACKAGE_PIN U19     [get_ports {o_leds[2]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {o_leds[2]}]

set_property PACKAGE_PIN V19     [get_ports {o_leds[3]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {o_leds[3]}]

set_property PACKAGE_PIN W18     [get_ports {o_leds[4]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {o_leds[4]}]

set_property PACKAGE_PIN U15     [get_ports {o_leds[5]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {o_leds[5]}]

set_property PACKAGE_PIN U14     [get_ports {o_leds[6]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {o_leds[6]}]

set_property PACKAGE_PIN V14     [get_ports {o_leds[7]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {o_leds[7]}]

set_property PACKAGE_PIN V13     [get_ports {o_leds[8]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {o_leds[8]}]

set_property PACKAGE_PIN V3      [get_ports {o_leds[9]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {o_leds[9]}]

set_property PACKAGE_PIN W3      [get_ports {o_leds[10]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {o_leds[10]}]

set_property PACKAGE_PIN U3      [get_ports {o_leds[11]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {o_leds[11]}]

set_property PACKAGE_PIN P3      [get_ports {o_leds[12]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {o_leds[12]}]

set_property PACKAGE_PIN N3      [get_ports {o_leds[13]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {o_leds[13]}]

set_property PACKAGE_PIN P1      [get_ports {o_leds[14]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {o_leds[14]}]

set_property PACKAGE_PIN L1      [get_ports {o_leds[15]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {o_leds[15]}]

## ------------------------------------------------------------
## Done flag -> BTNR LED ou pino externo (aqui mapeado em LD16
## A Basys 3 so tem 16 LEDs (0-15), entao o done pode ser
## observado no simulador ou em um pino PMOD.
## Opcao alternativa: remapear o_done para o_leds[0] no design
## e usar o_leds[1..15] para os bits.
##
## Abaixo, o_done eh mapeado para o pino JA[0] (PMOD JA, pino 1)
## para nao conflitar com os 16 LEDs.
## ------------------------------------------------------------
set_property PACKAGE_PIN J1      [get_ports o_done]
set_property IOSTANDARD  LVCMOS33 [get_ports o_done]

## ------------------------------------------------------------
## Sinal NRZ-L modulado -> JA[1] (PMOD JA, pino 2)
## Conecte um osciloscópio ou analisador logico aqui para
## visualizar a forma de onda NRZ-L real.
## ------------------------------------------------------------
set_property PACKAGE_PIN A14      [get_ports o_nrzl]
set_property IOSTANDARD  LVCMOS33 [get_ports o_nrzl]

## ------------------------------------------------------------
## Configuracao de bitstream
## ------------------------------------------------------------
set_property CONFIG_VOLTAGE    3.3  [current_design]
set_property CFGBVS            VCCO [current_design]
