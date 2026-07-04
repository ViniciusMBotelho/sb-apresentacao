.section .text
.globl my_strlen

# my_strlen: Calcula o tamanho de uma string
# Entrada: %rdi = ponteiro para a string (char*)
# Saída:   %rax = tamanho da string (long long)
my_strlen:
    movq $0, %rax          # Inicializa o contador de tamanho em 0
.loop:
    cmpb $0, (%rdi, %rax)  # Compara o byte atual com o caractere nulo '\0'
    je .end                # Se for zero (fim da string), pula para o fim
    incq %rax              # Incrementa o contador
    jmp .loop              # Loop para o próximo caractere
.end:
    ret                    # Retorna com o tamanho em %rax
