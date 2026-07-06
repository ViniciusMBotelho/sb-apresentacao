.section .text
.globl funcao_nao_usada
.type funcao_nao_usada, @function

# Função propositalmente não referenciada pelo programa.
# Ela demonstra que o linker não extrai este módulo da biblioteca.
funcao_nao_usada:
    ret
