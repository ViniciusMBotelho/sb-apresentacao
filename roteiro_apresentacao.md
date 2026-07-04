# Guia e Roteiro de Apresentação: Ligador e Ligação Estática

Este documento serve como um roteiro de suporte para guiar a apresentação do seminário. Os slides do PDF (25 páginas no total) foram divididos em **6 tópicos principais**.

---

## 📌 Visão Geral dos Tópicos

| Tópico | Slides no PDF | Conteúdo Principal |
| :--- | :--- | :--- |
| **1. Contexto e Introdução** | Slides 1 a 4 | Abertura, roteiro geral e o pipeline de compilação. |
| **2. Definições Fundamentais** | Slides 5 a 8 | Conceitos de Ligador, Bibliotecas e Ligação Estática. |
| **3. Processos e Etapas do Linker** | Slides 9 a 13 | Resolução de símbolos, relocação de endereços e formato ELF. |
| **4. Análise de Trade-offs** | Slides 14 a 15 | Vantagens e desvantagens da abordagem estática. |
| **5. Estudo de Caso Prático** | Slides 16 a 21 | Demonstração do código híbrido (C + Assembly x86_64) e ligação. |
| **6. Conclusão e Perguntas** | Slides 22 a 25 | Resumo final, referências e encerramento. |

---

## 🗣️ Guia Passo a Passo da Apresentação

### 🧵 Tópico 1: Contexto e Introdução (Slides 1 a 4)
*   **Slide 1: Capa**
    *   *Roteiro*: Apresentar o grupo, o título do trabalho ("Ligador, Bibliotecas e Ligação Estática") e a disciplina (Software Básico).
*   **Slide 2: Roteiro**
    *   *Roteiro*: Listar os pontos que serão discutidos (Definições, Etapas internas do linker, Vantagens/Desvantagens e o Exemplo de Código).
*   **Slide 3: Transição (Contexto)**
    *   *Roteiro*: Slide de transição visual rápida para introduzir o contexto de compilação.
*   **Slide 4: Pipeline de Compilação**
    *   *Roteiro*: Explicar que a geração de código não termina no compilador. Aponte para o diagrama do pipeline e explique que o **Linker** é o responsável por receber o código objeto gerado pelo montador (`.o`) e as bibliotecas externas para cuspir o executável binário final pronto para rodar.
    *   *Dica de fala*: *"O compilador traduz de C para Assembly, o montador traduz para binário de máquina (código objeto), mas apenas o Linker junta tudo em um programa executável."*

---

### 📚 Tópico 2: Definições Fundamentais (Slides 5 a 8)
*   **Slide 5: Transição (Definições)**
    *   *Roteiro*: Introduzir as terminologias base da matéria.
*   **Slide 6: O que é o Ligador (Linker)?**
    *   *Roteiro*: Focar no conceito de "combinação". Mostre o diagrama à direita: arquivos de código objeto separados (`main.o`, `math.o`) e a biblioteca estática (`libmath.a`) entrando no Ligador e saindo como um único arquivo `programa`.
*   **Slide 7: Bibliotecas**
    *   *Roteiro*: Definir o que são bibliotecas (código pré-compilado para reutilização). Explicar que existem as estáticas (`.a`/`.lib`) e as dinâmicas (`.so`/`.dll`).
    *   *Dica*: Lembre-se de passar rápido sobre a dinâmica, focando na estática para manter o foco do grupo.
*   **Slide 8: Ligação Estática**
    *   *Roteiro*: Explicar que na ligação estática, a cópia do código da biblioteca é fisicamente gravada para dentro do binário final em tempo de compilação. Use o diagrama comparativo para mostrar que no modelo estático a biblioteca está "embutida" no arquivo do programa.

---

### ⚙️ Tópico 3: Processos e Etapas do Linker (Slides 9 a 13)
*   **Slide 9: Transição (Processos e Etapas)**
    *   *Roteiro*: Introduzir como o ligador trabalha "debaixo do capô".
*   **Slide 10: Etapas do Ligador**
    *   *Roteiro*: Mostrar o fluxo das 3 principais etapas: 1) Resolução de Símbolos, 2) Relocação de Endereços, e 3) Geração do Executável.
*   **Slide 11: Resolução de Símbolos**
    *   *Roteiro*: Explicar que o montador gera uma tabela de símbolos para cada `.o`. Símbolos são nomes de funções e variáveis globais. O ligador precisa casar símbolos indefinidos (ex: chamada de `somar()` no `main.o`) com o símbolo definido (em `math_utils.o`). Mostre o arco de resolução no diagrama.
*   **Slide 12: Relocação de Endereços**
    *   *Roteiro*: Explicar que cada compilador monta o código assumindo o endereço `0x0` como ponto de partida. Quando juntamos os arquivos, esses endereços se sobrepõem. O linker ajusta essas referências para endereços absolutos finais na memória do executável.
*   **Slide 13: Geração do Executável**
    *   *Roteiro*: Explicar como o ligador mescla as seções do código. Seções `.text` (código compilado) de vários arquivos são agrupadas em uma única seção `.text` do binário ELF final (como ilustrado no desenho da estrutura ELF à direita). O mesmo ocorre com `.data` e `.bss`.

---

### ⚖️ Tópico 4: Análise de Trade-offs (Slides 14 a 15)
*   **Slide 14: Transição (Vantagens e Desvantagens)**
    *   *Roteiro*: Transição rápida para a análise crítica.
*   **Slide 15: Ligação Estática — Prós e Contras**
    *   *Roteiro*: 
        *   **Prós**: Portabilidade máxima (não depende de pacotes instalados no SO de destino) e imunidade ao "DLL Hell" (onde atualizar uma biblioteca quebra outros programas).
        *   **Contras**: Tamanho do executável inflacionado (pois copia tudo) e duplicação de memória RAM quando múltiplos processos executam o mesmo código de biblioteca.
    *   *Dica de fala*: *"É por isso que linguagens modernas como Go e Rust adotam ligação estática por padrão, focando em simplicidade de deploy e portabilidade."*

---

### 💻 Tópico 5: Estudo de Caso Prático (Slides 16 a 21)
*   **Slide 16: Transição (Exemplo Prático)**
    *   *Roteiro*: Transição para apresentar o projeto prático que demonstra a ligação.
*   **Slide 17: Código Fonte: C (Interface)**
    *   *Roteiro*: Mostrar o cabeçalho C (`string_utils.h`) definindo as rotinas e a execução no `main.c` (imprimir string, contar tamanho e inverter).
*   **Slide 18: Código Fonte: Assembly x86_64**
    *   *Roteiro*: Explicar que a biblioteca estática foi escrita em Assembly puro (GAS) para demonstrar a interoperabilidade de baixo nível. Explique o loop simples de `my_strlen` comparando bytes até achar o caractere terminador `\0`.
*   **Slide 19: Processo de Ligação Estática**
    *   *Roteiro*: Explicar os comandos executados pelo linker: 
        1. Compilação dos fontes assembly com `as` (gerando arquivos `.o`).
        2. Empacotamento em um arquivo de biblioteca `.a` usando o arquivador `ar`.
        3. A compilação final com `gcc -static`, integrando a biblioteca `libstrutils.a` no programa.
*   **Slide 20: Saída e Verificação**
    *   *Roteiro*: Mostrar o resultado da execução e a prova cabal da ligação estática: o comando `ldd programa` retornando a mensagem de que não é um executável dinâmico.
*   **Slide 21: Dentro da Biblioteca .a**
    *   *Roteiro*: Explicar o que de fato é a biblioteca estática: um arquivo de arquivo (archive) que agrupa os módulos de objeto compile-time (`my_strlen.o` e `my_reverse.o`). Apresente o diagrama em árvore mostrando a biblioteca descompactada.

---

### 🏁 Tópico 6: Conclusão e Perguntas (Slides 22 a 25)
*   **Slide 22: Transição (Considerações Finais)**
    *   *Roteiro*: Transição para fechar a apresentação.
*   **Slide 23: Resumo**
    *   *Roteiro*: Consolidar os aprendizados: o linker como peça crucial do desenvolvimento, a ligação estática gerando portabilidade ao custo de tamanho do arquivo.
*   **Slide 24: Referências**
    *   *Roteiro*: Citar o livro de cabeceira da matéria (Bryant & O'Hallaron - CSAPP), o livro clássico "Linkers and Loaders" e a documentação do GNU.
*   **Slide 25: Perguntas? (plain)**
    *   *Roteiro*: Agradecer pela atenção e abrir a sessão para dúvidas da turma ou do professor.
