# Extra- Saída pelo PMOD (Osciloscópio)
Disponibiliza o sinal modulado em um pino do conector PMOD da
placa, permitindo visualizar a forma de onda em um osciloscópio
físico.
## Estrutura desta pasta
```
pmod_osciloscopio/
|-- src/                             Código VHDL adaptado com saída no PMOD
|-- constraints/                     Constraint com mapeamento do pino PMOD
`-- docs/                            Tutorial e capturas do osciloscópio
```

## Equipamentos necessários:
- Placa FPGA Basys 3
- Osciloscópio (mínimo 10 MHz) Analog Discovery 3
- Cabo BNC ou pontas de prova para conectar ao PMOD
## Como reproduzir
Ver o [Tutorial de gravação na placa](./docs/Tutorial%20da%20Placa%20NRZ-L.pdf)