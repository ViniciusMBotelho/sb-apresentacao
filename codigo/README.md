# Exemplo de ligação estática: C + Assembly x86-64

Este exemplo cria `libstrutils.a` com três módulos:

- `my_strlen.o` e `my_reverse.o`, usados por `main.o`;
- `nao_usada.o`, que demonstra que o linker não incorpora automaticamente todos
  os módulos de uma biblioteca estática.

## Construção

Para gerar um executável de ligação mista:

```bash
make
```

O resultado é `programa_misto`. As funções de `libstrutils.a` são incorporadas,
mas a libc normalmente permanece como dependência dinâmica.

Para tentar gerar um executável completamente estático:

```bash
make programa
```

Esse segundo comando requer que a versão estática da libc e seus arquivos de
desenvolvimento estejam instalados.

Os comandos equivalentes são:

```bash
as my_strlen.s -o my_strlen.o
as my_reverse.s -o my_reverse.o
as nao_usada.s -o nao_usada.o
ar rcs libstrutils.a my_strlen.o my_reverse.o nao_usada.o
gcc -Wall -Wextra -O2 -c main.c -o main.o

# Somente libstrutils.a é ligada estaticamente.
gcc main.o ./libstrutils.a -o programa_misto

# Executável completamente estático.
gcc -static main.o ./libstrutils.a -o programa
```

O objeto que cria referências aparece antes da biblioteca que as resolve.

## Verificação

```bash
nm main.o | grep -E "my_strlen|my_reverse"
nm programa_misto | grep -E "my_strlen|my_reverse"
nm programa_misto | grep funcao_nao_usada
file programa_misto
ldd programa_misto
```

Antes da ligação, `main.o` mostra `U` para `my_strlen` e `my_reverse`. Depois,
essas funções aparecem definidas com `T` no executável. A busca por
`funcao_nao_usada` não produz saída, pois seu módulo não foi solicitado.

Para o executável completamente estático:

```bash
file programa
ldd programa
```

O primeiro comando deve indicar `statically linked`; o segundo normalmente
informa `not a dynamic executable`.

## Limpeza

```bash
make clean
```
