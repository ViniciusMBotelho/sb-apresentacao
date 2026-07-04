.section .text
.globl my_reverse

# my_reverse: Inverte uma string in-place
# Entrada: %rdi = ponteiro para a string (char*)
# Saída:   Nenhuma (modifica a memória diretamente)
my_reverse:
    movq %rdi, %rsi        # Copia o ponteiro de início para %rsi

.find_end:
    cmpb $0, (%rsi)        # Compara o caractere atual com '\0'
    je .found_end          # Se for nulo, achamos o final
    incq %rsi              # Avança o ponteiro de busca
    jmp .find_end

.found_end:
    decq %rsi              # Recua %rsi para apontar para o último caractere válido (antes de '\0')

.swap_loop:
    cmpq %rsi, %rdi        # Compara se os ponteiros se cruzaram ou se encontraram
    jae .done              # Se sim, a string foi totalmente invertida

    # Troca de caracteres (swap) usando registradores de 8 bits
    movb (%rdi), %al       # Carrega caractere da esquerda (início) em %al
    movb (%rsi), %bl       # Carrega caractere da direita (fim) em %bl
    movb %bl, (%rdi)       # Salva caractere da direita na posição da esquerda
    movb %al, (%rsi)       # Salva caractere da esquerda na posição da direita

    incq %rdi              # Avança o ponteiro da esquerda
    decq %rsi              # Recua o ponteiro da direita
    jmp .swap_loop         # Repete o processo

.done:
    ret                    # Retorna
