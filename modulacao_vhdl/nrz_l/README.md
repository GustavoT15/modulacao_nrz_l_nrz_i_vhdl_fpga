# Modulação NRZ-L
Implementação em VHDL da modulação Unipolar NRZ-L.

NRZ-L é a modulação em que o bit é representado pelo nivel do pulso durante todo o intervalo
do bit (1 = nivel alto, 0 = nivel baixo).

## Estrutura desta pasta
```
nrz_l/
|-- src/                               Código-fonte VHDL do circuito
|-- sim/                               Testbench para simulação
|-- constraints/                       Mapeamento dos pinos da FPGA (.xdc)
|-- vivado_project/                    Projeto Vivado pronto para abrir
|-- docs/                              Tutoriais e documentação técnica
`-- extras/                            Atividades opcionais (PMOD e VGA)
```

## Arquivos de código
`src/dut_nrzl.vhd`- código-fonte do circuito principal<br> 
`sim/tb_nrzl_tb.vhd`- testbench para simulação<br>
`constraints/c_nrzl.xdc`- mapeamento dos pinos da FPGA

## Por onde começar
## Documentação 
[Tutorial de simulação](./docs/Modulação%20Digital%20em%20VHDL%20-%20VRZ_L.pdf) - como simular no Vivado passo a passo <br>
[Tutorial de gravação na placa](./docs/Tutorial%20da%20Placa%20NRZ-L.pdf) - como sintetizar, gerar bitstream e gravar na FPGA <br>
[Documentação técnica](Documentação%20Técnica%20-%20Modulação%20NRZ-L.pdf)

diagrama de blocos, descrição das portas e funcionamento
Para uma **simulação rápida** (apenas ver funcionando):
1. Abrir o Vivado e carregar `vivado_project/nrz_l.xpr`
2. Clicar em `Run Simulation`-> `Run Behavioral Simulation`
Para **reproduzir o projeto do zero**, siga esta ordem:
1. **Entenda o circuito** lendo a
[Documentação técnica](./docs/Documentação%20Técnica%20-%20Modulação%20NRZ-L.pdf)
2. **Simule no Vivado** seguindo o
[Tutorial de simulação](./docs/Modulação%20Digital%20em%20VHDL%20-%20VRZ_L.pdf)
3. **Grave na placa** seguindo o
[Tutorial de gravação na placa](./docs/Tutorial%20da%20Placa%20NRZ-L.pdf)
3
4. (Opcional) Explore os
[extras](./extras/) - PMOD e VGA
## Extras (opcionais)
[Saída pelo PMOD para osciloscópio](./extras/pmod_osciloscopio/) - [Saída VGA com cores pulsantes](./extras/vga/)
## Próximo passo
Após concluir este projeto, siga para a
[Modulação NRZ-I](../nrz_i/), que implementa a outra
versão estudada no trabalho