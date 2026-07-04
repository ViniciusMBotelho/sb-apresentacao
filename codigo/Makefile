CC = gcc
AS = as
AR = ar
CFLAGS = -Wall -Wextra -O2

.PHONY: all clean

# A ligação mista funciona mesmo quando a libc estática não está instalada.
all: programa_misto

# 1. Monta os arquivos Assembly em arquivos objeto (.o)
my_strlen.o: my_strlen.s
	$(AS) my_strlen.s -o my_strlen.o

my_reverse.o: my_reverse.s
	$(AS) my_reverse.s -o my_reverse.o

nao_usada.o: nao_usada.s
	$(AS) nao_usada.s -o nao_usada.o

# 2. Cria a biblioteca estática (.a) empacotando os objetos
libstrutils.a: my_strlen.o my_reverse.o nao_usada.o
	$(AR) rcs libstrutils.a my_strlen.o my_reverse.o nao_usada.o

# 3. O driver gcc compila o C e aciona o montador para produzir main.o
main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

# 4a. A libstrutils.a é estática; a libc normalmente permanece dinâmica
programa_misto: main.o libstrutils.a
	$(CC) main.o ./libstrutils.a -o programa_misto

# 4b. Todo o executável é estático; requer a libc estática instalada
programa: main.o libstrutils.a
	$(CC) -static main.o ./libstrutils.a -o programa

clean:
	rm -f *.o *.a programa programa_misto
