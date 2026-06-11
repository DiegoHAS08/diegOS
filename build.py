import os # Importa o módulo do Python para mexer com o sistema operacional do PC
import subprocess # Importa o módulo que nos permite rodar comandos de terminal de forma automática.
import sys # Importa o módulo do sistema para fechar o script caso algo dê errado.

# Criamos uma função auxiliar para rodar os comandos no terminal e checar se deram erro.
def run_command(command):
    print(f"Executando: {command}")

    # Roda o comando de terminal e guarda o resultado. shell=True permite usar comandos nativos.
    result = subprocess.run(command, shell=True)

    # Se o 'returncode' for diferente de 0, significa que o compilador encontrou um erro no código.
    if result.returncode != 0:
        print(f"\n[ERRO] O Comando falhou: {command}")
        sys.exit(1) # Fecha o script Python imediatamente para não gerar um arquivo quebrado.

def main():
    print("Iniciando a build do diegOS")
    # Pegamos o 'boot.asm' e usamos o NASM para transformá-lo em 'boot.o' (código de máquina puro).
    # '-f elf32' avisa que queremos o formato padrão de binários de 32 bits.
    run_command("nasm -f elf32 boot.asm -o boot.o")

    # Usamos o 'i686-elf-gcc' (compilador cruzado) para transformar o 'kernel.c' em 'kernel.o'.
    # Flags explicadas:
    # '-c' -> Apenas compila, não tenta criar o programa final ainda.
    # '-ffreestanding' -> Avisa ao GCC que NÃO existe um Windows/Linux por baixo (desativa printf, etc).
    # '-O2' -> Otimiza o código para rodar mais rápido.
    # '-Wall -Wextra' -> Ativa todos os avisos do compilador para nos alertar se fizermos besteira no C.
    run_command("gcc -m32 -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra")

    # Aqui juntamos o 'boot.o' e o 'kernel.o' em um único arquivo chamado 'diegOS.bin'.
    # '-T linker.ld' -> Usa o nosso mapa de memória para saber quem vem primeiro (o bloco Multiboot).
    # '-nostdlib' -> Diz para o compilador não colocar nenhuma biblioteca padrão do sistema atual.
    # '-lgcc' -> Linka com funções matemáticas internas do próprio processador.
    run_command("gcc -m32 -T linker.ld -o diegOS.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc")

    print("\n[SUCESSO] Kernel 'diegOS.bin' gerado com sucesso!")
    print("\n--- Inicializando diegOS no QEMU ---")
    # 'qemu-system-i386' abre um computador virtual de 32 bits.
    # '-kernel diegOS.bin' joga o nosso sistema direto na "placa-mãe" virtual para dar o boot.
    run_command("qemu-system-i386 -kernel diegOS.bin")

if __name__ == "__main__":
    main()