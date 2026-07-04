# Guia e Roteiro de Apresentação: Ligador e Ligação Estática

Este documento serve como um roteiro de suporte para guiar a apresentação do seminário. Os slides do PDF (26 páginas no total) foram divididos em **6 tópicos principais**.

---

## 📌 Visão Geral dos Tópicos

| Tópico | Slides no PDF | Conteúdo Principal |
| :--- | :--- | :--- |
| **1. Contexto e Introdução** | Slides 1 a 4 | Abertura, roteiro geral e o processo de construção do programa. |
| **2. Definições Fundamentais** | Slides 5 a 8 | Conceitos de Ligador, Bibliotecas e Ligação Estática. |
| **3. Processos e Etapas do Linker** | Slides 9 a 13 | Resolução de símbolos, relocação de endereços e formato ELF. |
| **4. Análise de Trade-offs** | Slides 14 a 15 | Vantagens e desvantagens da abordagem estática. |
| **5. Estudo de Caso Prático** | Slides 16 a 22 | Demonstração do código híbrido (C + Assembly x86_64) e ligação. |
| **6. Conclusão e Perguntas** | Slides 23 a 26 | Resumo final, referências e encerramento. |

---

## 🗣️ Guia Passo a Passo da Apresentação

### 🧵 Tópico 1: Contexto e Introdução (Slides 1 a 4)
*   **Slide 1: Capa**
    *   *Roteiro*: Apresentar o grupo, o título do trabalho ("Ligador, Bibliotecas e Ligação Estática") e a disciplina (Software Básico).
*   **Slide 2: Roteiro**
    *   *Roteiro*: Listar os pontos que serão discutidos (Definições, Etapas internas do linker, Vantagens/Desvantagens e o Exemplo de Código).
*   **Slide 3: Transição (Contexto)**
    *   *Roteiro*: Slide de transição visual rápida para introduzir o contexto de compilação.
*   **Slide 4: Cada Ferramenta Produz a Entrada da Próxima**
    *   *Roteiro*: Separar claramente as funções: o compilador traduz C para Assembly; o montador gera arquivos objeto; o linker combina objetos e bibliotecas; o loader mapeia os segmentos do executável na memória e inicia o processo. Explicar que `gcc` é um driver e que `-S` o faz parar antes do montador.
    *   *Dica de fala*: *"Compilador, montador, linker e loader participam de momentos diferentes; o comando `gcc` pode coordenar várias dessas etapas."*

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
    *   *Roteiro*: Explicar que, em tempo de ligação, o linker extrai da biblioteca `.a` os módulos objeto necessários para resolver símbolos pendentes e os incorpora ao executável. Ressaltar que usar uma `.a` não torna automaticamente todo o executável estático, pois outras bibliotecas podem permanecer dinâmicas.

---

### ⚙️ Tópico 3: Processos e Etapas do Linker (Slides 9 a 13)
*   **Slide 9: Transição (Processos e Etapas)**
    *   *Roteiro*: Introduzir como o ligador trabalha "debaixo do capô".
*   **Slide 10: Etapas do Ligador**
    *   *Roteiro*: Mostrar o fluxo das 3 principais etapas: 1) Resolução de Símbolos, 2) Relocação de Endereços, e 3) Geração do Executável.
*   **Slide 11: Resolução de Símbolos**
    *   *Roteiro*: Explicar que o montador gera uma tabela de símbolos para cada `.o`. Símbolos globais definidos podem resolver referências de outros módulos; símbolos locais permanecem restritos ao próprio objeto. O linker associa símbolos indefinidos às definições correspondentes. Se não encontrar uma definição, emite `undefined reference`; se encontrar mais de uma definição global forte, emite `multiple definition`. Uma definição fraca pode ser substituída por uma forte.
*   **Slide 12: Relocação de Endereços**
    *   *Roteiro*: Explicar que um `.o` é relocável: contém offsets relativos às seções e entradas de relocação que indicam quais referências dependem da posição. O linker organiza as seções, atribui posições finais e aplica as correções. Em AMD64, muitas referências usam deslocamentos relativos ao RIP, não endereços absolutos.
*   **Slide 13: Geração do Executável**
    *   *Roteiro*: Explicar como o ligador organiza seções como `.text`, `.rodata`, `.data` e `.bss`. Destacar o ELF Header, os Program Headers que descrevem os segmentos mapeados pelo loader e a tabela de símbolos, que é útil para análise, mas pode ser removida com `strip`.

---

### ⚖️ Tópico 4: Análise de Trade-offs (Slides 14 a 15)
*   **Slide 14: Transição (Vantagens e Desvantagens)**
    *   *Roteiro*: Transição rápida para a análise crítica.
*   **Slide 15: Ligação Estática — Prós e Contras**
    *   *Roteiro*: 
        *   **Prós**: distribuição potencialmente mais simples em sistemas compatíveis, menor risco de bibliotecas ausentes ou incompatíveis e controle da versão incorporada.
        *   **Contras**: o executável tende a ser maior, pode haver duplicação entre programas e atualizações exigem nova ligação e redistribuição.
    *   *Dica de fala*: *"Esses efeitos dependem da plataforma, das opções do linker e das bibliotecas utilizadas; não são garantias absolutas."*

---

### 💻 Tópico 5: Estudo de Caso Prático (Slides 16 a 22)
*   **Slide 16: Transição (Exemplo Prático)**
    *   *Roteiro*: Transição para apresentar o projeto prático que demonstra a ligação.
*   **Slide 17: Código Fonte: C (Interface)**
    *   *Roteiro*: Mostrar o cabeçalho C (`string_utils.h`) definindo as rotinas e a execução no `main.c` (imprimir string, contar tamanho e inverter).
*   **Slide 18: ABI System V AMD64 e `my_strlen`**
    *   *Roteiro*: Explicar que `%rdi` recebe o primeiro argumento e `%rax` devolve o resultado. Mostrar que `my_strlen` percorre a string até `\0` e usa apenas registradores caller-saved.
*   **Slide 19: Implementação completa de `my_reverse`**
    *   *Roteiro*: Mostrar as duas etapas: localizar o fim da string e trocar os bytes das extremidades. Destacar o tratamento da string vazia e o uso de registradores caller-saved.
*   **Slide 20: Processo de Ligação Estática**
    *   *Roteiro*: Explicar os comandos executados pelo linker: 
        1. Montagem dos fontes Assembly com `as`, gerando arquivos `.o`.
        2. Empacotamento de `my_strlen.o`, `my_reverse.o` e `nao_usada.o` em `libstrutils.a` com `ar`.
        3. Ligação mista com `gcc main.o ./libstrutils.a -o programa_misto`.
        4. Executável completamente estático com `gcc -static main.o ./libstrutils.a -o programa`, quando a libc estática estiver instalada.
*   **Slide 21: Saída e Verificação**
    *   *Roteiro*: Comparar `nm main.o`, onde as funções aparecem como indefinidas (`U`), com `nm programa`, onde aparecem definidas (`T`). Confirmar o executável completamente estático com `file` e `ldd`.
*   **Slide 22: Dentro da Biblioteca .a**
    *   *Roteiro*: Mostrar os três módulos do arquivo `.a` e explicar que `nao_usada.o` permanece na biblioteca, mas não entra no executável porque nenhum de seus símbolos foi solicitado.

---

### 🏁 Tópico 6: Conclusão e Perguntas (Slides 23 a 26)
*   **Slide 23: Transição (Considerações Finais)**
    *   *Roteiro*: Transição para fechar a apresentação.
*   **Slide 24: Resumo**
    *   *Roteiro*: Consolidar os aprendizados: o linker resolve símbolos e aplica relocações; uma `.a` fornece módulos objeto selecionados conforme a necessidade; ligação estática envolve trade-offs dependentes do sistema.
*   **Slide 25: Referências**
    *   *Roteiro*: Citar Stallings, os slides da disciplina, GNU Binutils e a ABI System V AMD64, além das referências complementares.
*   **Slide 26: Perguntas? (plain)**
    *   *Roteiro*: Agradecer pela atenção e abrir a sessão para dúvidas da turma ou do professor.
