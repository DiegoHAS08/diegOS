MBOOT_PAGE_ALIGN equ 1 << 0 ; Alinha os pedaços do sistema na memória em blocos de 4KB.
MBOOT_MEM_INFO equ 1 << 1 ; Pede ao GRUB para nos dar informações sobre a memória RAM do PC.
MBOOT_HEADER_MAGIC equ 0x1BADB002 ; O "Número Mágico". O GRUB procura por esse número no arquivo.
MBOOT_HEADER_FLAGS equ MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO ; Junta as duas configurações acima.
; O Checksum é uma conta matemática obrigatória que prova ao GRUB que os números acima estão corretos.
MBOOT_CHECKSUM equ -(MBOOT_HEADER_MAGIC + MBOOT_HEADER_FLAGS)

; Avisa ao compilador para criar uma seção especial chamada '.multiboot' no arquivo final.
section .multiboot
align 4 ; Alinha os dados em blocos de 4 bytes na memória RAM.
    dd MBOOT_HEADER_MAGIC ; Escreve o número mágico no arquivo.
    dd MBOOT_HEADER_FLAGS ; Escreve as configurações no arquivo.
    dd MBOOT_CHECKSUM ; Escreve o resultado da conta matemática no arquivo.


; O C precisa de uma pilha de memória para conseguir criar variáveis locais e chamar funções.

section .bss
align 16 ; Alinha a memória da pilha em blocos de 16 bytes (padrão do processador).
stack_bottom:
    resb 16384 ; Reserva 16 Kilobytes de espaço na RAM puramente para a pilha.
stack_top: ; Marca o topo da pilha (a pilha no x86 cresce de cima para baixo).
section .text
global _start
extern kernel_main ; Avisa ao Assembly que a função 'kernel_main' existe em outro arquivo (no C).   

_start: ; O computador começa a executar exatamente aqui após o GRUB.
    mov esp, stack_top ; Joga o endereço do topo da nossa pilha no registrador ESP do processador.
                       ; Agora o C já tem memória para funcionar!

    call kernel_main ; Dá um salto direto para dentro da função 'kernel_main' que criamos no arquivo C
    cli ; Se o código em C terminar, desativa todas as interrupções do PC.
.hang:
    hlt ; Coloca o processador em estado de descanso/parada.
    jmp .hang ; Se por algum motivo o PC acordar, pula de volta para o 'hlt'.


 