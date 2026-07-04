#include <stdio.h>
#include "string_utils.h"

int main() {
    char texto[] = "Software Basico - Ligacao Estatica";

    printf("==========================================\n");
    printf("Texto Original: \"%s\"\n", texto);
    printf("==========================================\n");

    // 1. Chamando a função my_strlen (escrita em Assembly)
    long long tamanho = my_strlen(texto);
    printf("Tamanho (my_strlen em Assembly): %lld caracteres\n", tamanho);

    // 2. Chamando a função my_reverse (escrita em Assembly)
    my_reverse(texto);
    printf("Texto Invertido (my_reverse em Assembly): \"%s\"\n", texto);
    printf("==========================================\n");

    return 0;
}
