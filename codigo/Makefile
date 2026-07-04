CC = gcc
AS = as
AR = ar
CFLAGS = -Wall -O2

all: programa

# 1. Compila os arquivos Assembly em arquivos objeto (.o)
my_strlen.o: my_strlen.s
	$(AS) my_strlen.s -o my_strlen.o

my_reverse.o: my_reverse.s
	$(AS) my_reverse.s -o my_reverse.o

# 2. Cria a biblioteca estática (.a) empacotando os objetos
libstrutils.a: my_strlen.o my_reverse.o
	$(AR) rcs libstrutils.a my_strlen.o my_reverse.o

# 3. Compila o main.c em arquivo objeto (.o)
main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

# 4. Liga o main.o estaticamente com a biblioteca libstrutils.a
programa: main.o libstrutils.a
	$(CC) main.o -L. -lstrutils -static -o programa

clean:
	rm -f *.o *.a programa
