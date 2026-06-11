ENTRY(_start) /* Avisa que o ponto de entrada do sistema é a marca '_start' do Assembly */

SECTIONS
{
    /* O código começará a ser carregado em 1 Megabyte de memória RAM, */
    /* que é o local padrão onde os kernels de 32 bits começam a rodar. */
    . = 1M; 

    /* Seção de código do sistema */
    .text BLOCK(4K) : ALIGN(4K)
    {
        *(.multiboot) /* Força os bytes mágicos do Multiboot a virem PRIMEIRO */
        *(.text)      /* Depois coloca o resto do código em Assembly e C */
    }

    /* Seção de dados apenas para leitura (como nossos textos fixos) */
    .rodata BLOCK(4K) : ALIGN(4K)
    {
        *(.rodata)
    }

    /* Seção de dados globais (variáveis que podem mudar) */
    .data BLOCK(4K) : ALIGN(4K)
    {
        *(.data)
    }

    /* Seção da nossa Pilha de Memória (Stack) */
    .bss BLOCK(4K) : ALIGN(4K)
    {
        *(COMMON)
        *(.bss)
    }
}