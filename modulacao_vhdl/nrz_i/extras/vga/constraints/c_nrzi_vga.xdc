## ============================================================
## Constraints XDC - Basys 3 (Artix-7 XC7A35T-1CPG236C)
## Projeto: NRZ-I + VGA
## Top module: nrz_i
## ============================================================

## ------------------------------------------------------------
## Clock 100 MHz
## ------------------------------------------------------------
set_property PACKAGE_PIN W5       [get_ports clk]
set_property IOSTANDARD  LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## ------------------------------------------------------------
## Reset -> BTNC
## ------------------------------------------------------------
set_property PACKAGE_PIN U18      [get_ports reset]
set_property IOSTANDARD  LVCMOS33 [get_ports reset]

## ------------------------------------------------------------
## Switches SW[15:0] -> data_in
## ------------------------------------------------------------
set_property PACKAGE_PIN V17      [get_ports {data_in[0]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {data_in[0]}]

set_property PACKAGE_PIN V16      [get_ports {data_in[1]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {data_in[1]}]

set_property PACKAGE_PIN W16      [get_ports {data_in[2]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {data_in[2]}]

set_property PACKAGE_PIN W17      [get_ports {data_in[3]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {data_in[3]}]

set_property PACKAGE_PIN W15      [get_ports {data_in[4]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {data_in[4]}]

set_property PACKAGE_PIN V15      [get_ports {data_in[5]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {data_in[5]}]

set_property PACKAGE_PIN W14      [get_ports {data_in[6]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {data_in[6]}]

set_property PACKAGE_PIN W13      [get_ports {data_in[7]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {data_in[7]}]

set_property PACKAGE_PIN V2       [get_ports {data_in[8]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {data_in[8]}]

set_property PACKAGE_PIN T3       [get_ports {data_in[9]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {data_in[9]}]

set_property PACKAGE_PIN T2       [get_ports {data_in[10]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {data_in[10]}]

set_property PACKAGE_PIN R3       [get_ports {data_in[11]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {data_in[11]}]

set_property PACKAGE_PIN W2       [get_ports {data_in[12]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {data_in[12]}]

set_property PACKAGE_PIN U1       [get_ports {data_in[13]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {data_in[13]}]

set_property PACKAGE_PIN T1       [get_ports {data_in[14]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {data_in[14]}]

set_property PACKAGE_PIN R2       [get_ports {data_in[15]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {data_in[15]}]

## ------------------------------------------------------------
## LEDs LD[15:0] -> nrz_out
## LED do bit atual reflete nivel NRZ-I corrente
## ------------------------------------------------------------
set_property PACKAGE_PIN U16      [get_ports {nrz_out[0]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {nrz_out[0]}]

set_property PACKAGE_PIN E19      [get_ports {nrz_out[1]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {nrz_out[1]}]

set_property PACKAGE_PIN U19      [get_ports {nrz_out[2]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {nrz_out[2]}]

set_property PACKAGE_PIN V19      [get_ports {nrz_out[3]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {nrz_out[3]}]

set_property PACKAGE_PIN W18      [get_ports {nrz_out[4]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {nrz_out[4]}]

set_property PACKAGE_PIN U15      [get_ports {nrz_out[5]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {nrz_out[5]}]

set_property PACKAGE_PIN U14      [get_ports {nrz_out[6]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {nrz_out[6]}]

set_property PACKAGE_PIN V14      [get_ports {nrz_out[7]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {nrz_out[7]}]

set_property PACKAGE_PIN V13      [get_ports {nrz_out[8]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {nrz_out[8]}]

set_property PACKAGE_PIN V3       [get_ports {nrz_out[9]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {nrz_out[9]}]

set_property PACKAGE_PIN W3       [get_ports {nrz_out[10]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {nrz_out[10]}]

set_property PACKAGE_PIN U3       [get_ports {nrz_out[11]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {nrz_out[11]}]

set_property PACKAGE_PIN P3       [get_ports {nrz_out[12]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {nrz_out[12]}]

set_property PACKAGE_PIN N3       [get_ports {nrz_out[13]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {nrz_out[13]}]

set_property PACKAGE_PIN P1       [get_ports {nrz_out[14]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {nrz_out[14]}]

set_property PACKAGE_PIN L1       [get_ports {nrz_out[15]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {nrz_out[15]}]

## ------------------------------------------------------------
## PMOD JB pino 1 (A14) -> tx_pmod (Analog Discovery 3)
## ------------------------------------------------------------
set_property PACKAGE_PIN A14      [get_ports tx_pmod]
set_property IOSTANDARD  LVCMOS33 [get_ports tx_pmod]

## ------------------------------------------------------------
## VGA - conector J2 da Basys 3
## ------------------------------------------------------------
set_property PACKAGE_PIN G19      [get_ports {vga_r[0]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {vga_r[0]}]

set_property PACKAGE_PIN H19      [get_ports {vga_r[1]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {vga_r[1]}]

set_property PACKAGE_PIN J19      [get_ports {vga_r[2]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {vga_r[2]}]

set_property PACKAGE_PIN N19      [get_ports {vga_r[3]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {vga_r[3]}]

set_property PACKAGE_PIN J17      [get_ports {vga_g[0]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {vga_g[0]}]

set_property PACKAGE_PIN H17      [get_ports {vga_g[1]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {vga_g[1]}]

set_property PACKAGE_PIN G17      [get_ports {vga_g[2]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {vga_g[2]}]

set_property PACKAGE_PIN D17      [get_ports {vga_g[3]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {vga_g[3]}]

set_property PACKAGE_PIN N18      [get_ports {vga_b[0]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {vga_b[0]}]

set_property PACKAGE_PIN L18      [get_ports {vga_b[1]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {vga_b[1]}]

set_property PACKAGE_PIN K18      [get_ports {vga_b[2]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {vga_b[2]}]

set_property PACKAGE_PIN J18      [get_ports {vga_b[3]}]
set_property IOSTANDARD  LVCMOS33 [get_ports {vga_b[3]}]

set_property PACKAGE_PIN P19      [get_ports vga_hs]
set_property IOSTANDARD  LVCMOS33 [get_ports vga_hs]

set_property PACKAGE_PIN R19      [get_ports vga_vs]
set_property IOSTANDARD  LVCMOS33 [get_ports vga_vs]

## ------------------------------------------------------------
## Configuracao de bitstream
## ------------------------------------------------------------
set_property CONFIG_VOLTAGE    3.3  [current_design]
set_property CFGBVS            VCCO [current_design]
