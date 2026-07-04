#include <stdio.h>
#include "string_utils.h"

int main() {
    char texto[] = "Software Basico";
    long long tamanho = my_strlen(texto);
    printf("Tamanho: %lld\n", tamanho);
    my_reverse(texto);
    printf("Invertido: %s\n", texto);
    return 0;
}
