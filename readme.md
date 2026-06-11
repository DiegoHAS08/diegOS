```markdown
# diegOS

O diegOS é um sistema operacional de 32 bits (arquitetura x86) construído completamente do zero, direto
no metal (*bare-metal*), utilizando C e Assembly x86, com scripts de automação em Python.

Este projeto foi desenhado para explorar os limites mais profundos da computação: como o processador
inicializa, gerenciamento de memória real, comunicação direta com o hardware via Portas I/O e
desenvolvimento sem nenhuma biblioteca padrão (*freestanding environment*).

 Arquitetura e Tecnologias

* Kernel: Escrito em C puro (sem `stdio.h`, `stdlib.h` ou qualquer facilidade de alto nível).
* Bootloader & Inicialização: Escrito em Assembly NASM, configurado sob o padrão Multiboot para comunicação com o GRUB.
* Linker Script: Configuração manual dos segmentos de memória (`.text`, `.rodata`, `.data`, `.bss`) mapeados a partir
de 1MB na RAM.
* Automação (Toolchain): Script em Python que gerencia o fluxo completo de compilação cruzada (*cross-compilation*) e
inicialização do emulador.
* Ambiente de Testes: QEMU (Emulador de hardware x86 de 32 bits).

## Como Executar o Projeto

### Pré-requisitos
Certifique-se de ter as ferramentas básicas instaladas no seu ambiente (preferencialmente Linux/WSL):

```bash
sudo apt update
sudo apt install build-essential nasm python3 qemu-system-x86 gcc-multilib -y
