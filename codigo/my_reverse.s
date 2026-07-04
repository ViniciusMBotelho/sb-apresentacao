.section .text
.globl my_reverse
.type my_reverse, @function

# my_reverse: Inverte uma string in-place
# Entrada: %rdi = ponteiro para a string (char*)
# Saída:   Nenhuma (modifica a memória diretamente)
my_reverse:
    movq %rdi, %rsi        # %rsi procura o fim da string

.find_end:
    cmpb $0, (%rsi)        # Compara o caractere atual com '\0'
    je .prepare            # Se for nulo, achamos o final
    incq %rsi              # Avança o ponteiro de busca
    jmp .find_end

.prepare:
    cmpq %rdi, %rsi        # String vazia: não há caracteres para trocar
    je .done
    decq %rsi              # Recua %rsi para apontar para o último caractere válido (antes de '\0')
    movq %rdi, %rdx        # %rdx percorre a string pela esquerda

.swap:
    cmpq %rsi, %rdx        # Compara se os ponteiros se cruzaram ou se encontraram
    jge .done              # Se sim, a string foi totalmente invertida

    movb (%rdx), %al       # Carrega o caractere da esquerda
    movb (%rsi), %cl       # Usa apenas registradores caller-saved da ABI
    movb %cl, (%rdx)       # Salva o caractere da direita à esquerda
    movb %al, (%rsi)       # Salva o caractere da esquerda à direita
    incq %rdx              # Avança o ponteiro da esquerda
    decq %rsi              # Recua o ponteiro da direita
    jmp .swap              # Repete o processo

.done:
    ret                    # Retorna

.size my_reverse, .-my_reverse
.section .note.GNU-stack,"",@progbits
