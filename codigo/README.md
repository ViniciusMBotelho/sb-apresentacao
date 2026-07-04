# Exemplo de Ligação Estática: C + Assembly x86_64

Este projeto prático demonstra como construir uma biblioteca estática em Assembly x86_64 e consumi-la em um programa escrito em C, realizando a ligação 100% estática do binário final.

## Estrutura do Projeto
- `string_utils.h`: Cabeçalho C com as assinaturas das funções.
- `my_strlen.s`: Implementação de `strlen` em Assembly x86_64 (GAS).
- `my_reverse.s`: Implementação de inversão de strings em Assembly x86_64 (GAS).
- `main.c`: Programa C principal que chama as funções utilitárias.
- `Makefile`: Automação da compilação e do processo de ligação.

## Como Executar

### 1. Compilar e Gerar a Biblioteca Estática
Para compilar as funções em Assembly, gerar a biblioteca estática `.a` e ligar com o executável final de forma estática, execute:
```bash
make
```

O `make` executa os seguintes comandos:
```bash
# Compilar os fontes Assembly (.s) para arquivos de objetos (.o)
as my_strlen.s -o my_strlen.o
as my_reverse.s -o my_reverse.o

# Empacotar os arquivos de objeto na biblioteca estática (.a)
ar rcs libstrutils.a my_strlen.o my_reverse.o

# Compilar o arquivo principal em C
gcc -Wall -O2 -c main.c -o main.o

# Realizar a ligação 100% estática (-static)
gcc main.o -L. -lstrutils -static -o programa
```

### 2. Executar o Programa
```bash
./programa
```

### 3. Verificar que a Ligação foi Estática
Para comprovar que o arquivo executável não depende de bibliotecas dinâmicas externas compartilhadas (como a `libc.so`), use o comando `file` ou `ldd`:

```bash
# Verifique o formato do arquivo (deve mostrar "statically linked")
file programa

# Verifique as dependências dinâmicas (deve mostrar "not a dynamic executable")
ldd programa
```

### 4. Analisar os Símbolos no Executável
Você pode inspecionar os símbolos importados da biblioteca estática usando o comando `nm`:
```bash
nm programa | grep -E "my_strlen|my_reverse"
```
Você verá os símbolos correspondentes definidos na seção de texto (`T`) do próprio executável.

### 5. Limpar os Arquivos de Compilação
```bash
make clean
```
