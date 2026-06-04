# Modulação Digital em VHDL
Trabalho da disciplina de Comunicação de Dados- Sistemas
Reconfiguraveis, ministrada por Vinicius da Silva Borges.
Semestre 7.
## Integrantes
- Matheus Gonçalves Nunes
- Gustavo Trindade Rodrigues
- Victor Oliveira Malvão
- Lucas Barboza Silva

## Descrição
Este trabalho implementa, em VHDL, dois sistemas de modulacao
digital: Unipolar NRZ-L e Unipolar NRZ-I. O codigo foi simulado
no Vivado Simulator e implementado na placa Basys 3.
O projeto contém a visualização da onda gerada pelas modulações
em 3 modos, via LEDs, PMOD no software Waveforms e VGA em um monitor.

## Estrutura do repositório
```
modulacao_vhdl/
|-- README.md                                                   (visao geral, integrantes, indice)
|
|-- nrz_l/
| |-- README.md                                                 (descricao e indice do projeto)
| |-- src/                                                      (codigo-fonte)
| | `-- nrz_l.vhd
| |-- sim/                                                      (testbench)
| | `-- nrz_l_tb.vhd                                            
| |-- constraints/                                              (mapeamento de pinos)
| | `-- nrz_l.xdc
| |-- vivado_project/                                           (pasta gerada pelo Vivado)
| |-- docs/                                                     
| | |-- tutorial_simulacao.pdf                                  (passo a passo da simulacao)
| | |-- tutorial_placa.pdf                                      (passo a passo da gravacao na FPGA)
| | |-- documentacao_projeto.pdf (descricao tecnica e analise)
| | `-- midia/                                                  (prints, fotos, videos)
| `-- extras/                                                   (projetos extras de PMOD e VGA)
|    |
|    |-- pmod_osciloscopio/
|    |   |-- README.md
|    |   |-- src/
|    |   |-- constraints/
|    |   `-- docs/
|    `-- vga/
|       |-- README.md
|       |-- src/
|       |-- constraints/
|       `-- docs/
|-- nrz_i/
| |-- README.md
| |-- src/
| |-- sim/
| |-- constraints/
| |-- vivado_project/
| |-- docs/
| `-- extras/
|    |
|    |-- pmod_osciloscopio/
|    |   |-- README.md
|    |   |-- src/
|    |   |-- constraints/
|    |   `-- docs/
|    `-- vga/
|       |-- README.md
|       |-- src/
|       |-- constraints/
|       `-- docs/
`-- relatorio_final/

```

## Projetos
[Modulação NRZ-L](./nrz_l/) bit representado pelo nível do pulso <br>
[Modulação NRZ-I](./nrz_i/) bit representado pela transição do pulso

## Relatório
[Relatório técnico final](./relatorio_final/relatorio.pdf) <br>
[Vídeo de demonstração](./relatorio_final/video_demo.mp4)
## Ferramentas utilizadas 
Vivado 2023.1 <br>
Placa Basys 3 <br>
Osciloscópio Analog Discovery 3
## Como começar
Recomendamos iniciar pelo projeto NRZ-L. Acesse a pasta
[nrz_l/](./nrz_l/) e siga o README local.