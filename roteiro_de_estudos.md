# 📋 Roteiro de Estudos e Apresentação
## Seminário: Ligador (Linker), Bibliotecas e Ligação Estática
### Grupo 2 – Alberto Henrique, Gabriel Ramos, Ícaro Vinícius e Vinícius Macedo

---

## 🎯 Divisão Sugerida de Apresentação

| Slide(s) | Tema | Apresentador Sugerido | Tempo |
|-----------|------|----------------------|-------|
| 1-3 | Introdução + Pipeline | **Alberto Henrique** | ~3 min |
| 4-6 | Definições (Ligador, Bibliotecas, Ligação Estática) | **Gabriel Ramos** | ~4 min |
| 7-10 | Etapas do Processo de Ligação | **Ícaro Vinícius** | ~5 min |
| 11-15 | Vantagens/Desvantagens + Exemplo Prático | **Vinícius Macedo** | ~5 min |
| 16-18 | Resumo + Perguntas | **Todos** | ~3 min |

**Tempo total estimado: ~20 minutos**

---

## 📖 Roteiro Detalhado por Slide

---

### Slide 1 – Capa
> Apenas apresentar o grupo e o tema. Nenhum membro precisa falar muito aqui.

**Fala sugerida:**
> "Bom dia/boa tarde. Somos o Grupo 2 e nosso tema é o Ligador, Bibliotecas e Ligação Estática. Vamos explicar o que é cada um, como funcionam, suas vantagens e desvantagens, e fechar com um exemplo prático em C."

---

### Slide 2 – Roteiro
> Apresentar rapidamente os tópicos que serão abordados.

**Fala sugerida:**
> "Primeiro vamos contextualizar onde o Ligador se encaixa no processo de construção do programa, depois vamos para as definições, as etapas internas do processo, prós e contras, e por fim um exemplo prático."

---

### Slide 3 – Do Código-Fonte à Execução (Contexto)
> Usar o diagrama para separar compilador, montador, linker e loader.

**Pontos-chave para falar:**
- O código-fonte passa por: Pré-processador → Compilador → Montador → e gera arquivos-objeto (.o)
- Os arquivos `.o` são **código de máquina**, mas **incompletos** — eles têm referências a funções/variáveis que podem estar em *outros* arquivos
- O **Linker** pega todos esses `.o` e resolve essas referências, gerando o executável final
- O **Loader** mapeia os segmentos do executável na memória e inicia o processo
- O `gcc` é um driver: `-S` para após a compilação; `-c` também aciona o montador, mas não o linker

**Conceito importante para estudar:**
- Arquivo-objeto (.o) contém: código de máquina + tabela de símbolos + informações de relocação
- O arquivo .o NÃO é executável por si só

---

### Slide 4 – O que é o Ligador (Linker)?

**Pontos-chave para falar:**
- **Definição formal:** É a ferramenta que combina múltiplos módulos-objeto e bibliotecas em um único arquivo executável
- **Entrada:** arquivos `.o` (gerados pelo assembler) + bibliotecas (`.a` ou `.so`)
- **Saída:** um executável (formato ELF no Linux, PE no Windows)
- **O que ele faz internamente:** duas coisas principais — resolução de símbolos e relocação de endereços
- Exemplos de linkers: `ld` (GNU Linker, usado pelo GCC), `lld` (LLVM), `link.exe` (Microsoft)
- No dia a dia, o GCC já chama o linker automaticamente — mas dá pra chamar separadamente

**Conceito importante para estudar:**
- **Símbolo** = nome de uma função ou variável global. Cada `.o` exporta símbolos (definições) e importa símbolos (referências externas)
- Quando você escreve `int somar(int a, int b)` num arquivo, o compilador cria um símbolo "somar" na tabela de símbolos daquele `.o`

---

### Slide 5 – O que são Bibliotecas?

**Pontos-chave para falar:**
- Biblioteca = coleção de funções pré-compiladas que podem ser reutilizadas
- Dois tipos principais:

**Biblioteca Estática (.a / .lib):**
- É um "pacote" de arquivos `.o` agrupados
- Criada com o comando `ar` (archiver)
- Quando usada, o código necessário é **copiado** para dentro do executável
- O executável fica maior, mas não depende de nada externo

**Biblioteca Dinâmica (.so / .dll):**
- O código NÃO é copiado — fica em arquivo separado
- Carregada em tempo de execução pelo **loader** do sistema operacional
- Executável fica menor, mas depende do `.so`/`.dll` estar presente no sistema
- Múltiplos programas podem compartilhar a mesma biblioteca na memória

**Exemplo do cotidiano:**
- A `libc` (biblioteca padrão do C) contém `printf`, `malloc`, `strlen`, etc.
- Quando você faz `#include <stdio.h>` e usa `printf`, o código de `printf` vem da `libc`

---

### Slide 6 – O que é Ligação Estática?

**Pontos-chave para falar:**
- Em **tempo de ligação**, o linker extrai de uma biblioteca `.a` os módulos objeto necessários para resolver referências pendentes
- A biblioteca `.a` não precisa acompanhar o programa depois que seus módulos são incorporados
- Usar uma `.a` não garante que o executável inteiro seja estático; outras bibliotecas, como a libc, podem continuar dinâmicas
- Um executável completamente estático reduz dependências em tempo de execução, mas continua dependente da arquitetura, do sistema e das interfaces disponíveis
- Usar o diagrama comparativo para mostrar visualmente a diferença de tamanho

**Quando ligação estática é usada na prática:**
- Alguns sistemas embarcados
- Utilitários de linha de comando distribuídos como binário único
- Alguns containers mínimos, dependendo da libc e da configuração da aplicação

**Duas situações diferentes:**
```bash
# Apenas libstrutils.a é ligada estaticamente; a libc pode permanecer dinâmica
gcc main.o ./libstrutils.a -o programa_misto

# Executável completamente estático; requer as bibliotecas estáticas instaladas
gcc -static main.o ./libstrutils.a -o programa
```

---

### Slide 7 – Etapas do Processo de Ligação

**Pontos-chave para falar:**
- O ligador trabalha em 3 grandes etapas:
  1. **Resolução de Símbolos** — descobre onde cada função/variável está definida
  2. **Relocação de Endereços** — recalcula os endereços de memória
  3. **Geração do Executável** — monta o arquivo final (ELF/PE)

- Mostrar o diagrama de fluxo e explicar que é um processo sequencial

---

### Slide 8 – Resolução de Símbolos (Etapa 1)

**Pontos-chave para falar:**
- Cada arquivo `.o` tem uma **tabela de símbolos** que lista:
  - Símbolos **definidos** naquele arquivo; globais podem resolver referências externas, enquanto locais permanecem restritos ao módulo
  - Símbolos **indefinidos** / referências externas (ex: chama `printf`, mas `printf` não está nesse arquivo)
- O ligador percorre todos os `.o` e faz o "casamento": para cada referência indefinida, procura qual `.o` ou biblioteca define aquele símbolo
- Se NÃO encontrar: **erro de ligação** → `undefined reference to 'funcao'`
- Se encontrar mais de uma definição global forte: **erro de múltipla definição** → `multiple definition of 'funcao'`
- Uma definição fraca pode ser substituída por uma definição forte
- Usar o diagrama de resolução para mostrar visualmente

**Pergunta que podem fazer:**
> "O que é o erro `undefined reference`?"
> R: É quando o linker não encontra a definição de uma função que foi chamada. Geralmente acontece quando você esqueceu de compilar um dos arquivos `.c` ou de linkar a biblioteca correta.

---

### Slide 9 – Relocação de Endereços (Etapa 2)

**Pontos-chave para falar:**
- Um arquivo `.o` é **relocável**: contém offsets relativos às suas seções, símbolos e entradas de relocação
- As entradas de relocação indicam exatamente quais referências dependem da posição final
- O linker organiza as seções de entrada, atribui posições no arquivo final e aplica as correções necessárias
- Em AMD64, muitas referências são codificadas como deslocamentos relativos ao RIP, não como endereços absolutos

**Exemplo simples:**
- `main.o` contém uma chamada a `somar` cujo destino ainda está pendente
- `math.o` define `somar` em um offset de sua seção `.text`
- Depois de posicionar as seções, o linker calcula o deslocamento correto da instrução `call`

**Conceito importante:**
- **Entradas de relocação** são registros de metadados, não instruções, que identificam o local, o símbolo e o tipo de correção
- Você pode vê-las com `readelf -r arquivo.o` ou `objdump -r arquivo.o`

---

### Slide 10 – Geração do Executável (Etapa 3)

**Pontos-chave para falar:**
- O linker combina todas as seções de mesmo tipo:
  - Todas as seções `.text` (código) → uma única seção `.text` no executável
  - Todas as seções `.data` (dados inicializados) → uma única `.data`
  - Todas as seções `.bss` (dados não inicializados) → uma única `.bss`
- Gera o **header** do arquivo (ELF Header no Linux) que contém:
  - O **entry point** — endereço da primeira instrução (geralmente `_start` → `main`)
  - Informações sobre o formato, arquitetura, etc.
- Gera os **Program Headers**, que descrevem os segmentos que o loader deve mapear na memória
- Resultado: um arquivo ELF que o sistema operacional sabe carregar e executar

**Formato ELF (Executable and Linkable Format):**
- É o formato padrão de executáveis no Linux
- Contém ELF Header, Program Headers, segmentos e seções
- A tabela completa de símbolos `.symtab` é útil para depuração e análise, mas pode ser removida com `strip`
- Equivalente no Windows: PE (Portable Executable)

---

### Slide 11 – Vantagens e Desvantagens

**Vantagens — explicar como tendências, não garantias:**
1. **Distribuição potencialmente mais simples:** reduz a quantidade de bibliotecas que precisam acompanhar o programa
2. **Menor risco de bibliotecas ausentes ou incompatíveis:** a versão incorporada permanece sob controle da aplicação
3. **Inicialização potencialmente mais simples:** parte da resolução dinâmica deixa de ser necessária
4. **Reprodutibilidade:** o código incorporado não muda quando uma biblioteca compartilhada do sistema é atualizada

**Desvantagens — explicar cada uma:**
1. **Tamanho:** o executável tende a ser maior que um equivalente que compartilha bibliotecas
2. **Duplicação:** programas diferentes podem carregar cópias próprias do mesmo código
3. **Atualização:** corrigir código incorporado exige nova ligação e redistribuição
4. **Disponibilidade:** algumas bibliotecas de sistema não oferecem uma versão estática

**Caso de uso para mencionar:**
- Go e Rust podem produzir binários com diferentes graus de ligação estática, dependendo da plataforma, da libc e das opções de construção

---

### Slide 12 – Exemplo Prático: Código Fonte

**Pontos-chave para falar:**
- Temos dois arquivos: `math_utils.c` (implementa `somar` e `multiplicar`) e `main.c` (usa essas funções)
- O `math_utils.h` é o header que declara as funções (permite que `main.c` saiba que elas existem)
- Mostrar que `main.c` chama `somar()` e `multiplicar()` — essas referências serão **indefinidas** no `main.o` e precisam ser resolvidas pelo linker

---

### Slide 13 – Exemplo Prático: Processo

**Pontos-chave para falar:**
- **Passo 1:** `as` monta `my_strlen.s`, `my_reverse.s` e `nao_usada.s`, gerando arquivos `.o`
- **Passo 2:** `ar rcs` cria `libstrutils.a` com os três módulos objeto
  - `r` = replace, `c` = create, `s` = index (para busca rápida de símbolos)
- **Passo 3:** `gcc -c main.c -o main.o` produz o objeto que referencia as funções
- **Passo 4:** `gcc main.o ./libstrutils.a -o programa_misto` incorpora a `.a`, mas pode manter a libc dinâmica
- **Passo 5:** `gcc -static main.o ./libstrutils.a -o programa` tenta produzir um executável completamente estático
- A ordem importa: `main.o` aparece antes da biblioteca que resolve suas referências

**Dica:** se possível, demonstrar ao vivo no terminal durante a apresentação!

---

### Slide 14 – Exemplo Prático: Saída

**Pontos-chave para falar:**
- `./programa` mostra `Tamanho: 15` e `Invertido: ocisaB erawtfoS`
- `file programa` confirma que é "statically linked"
- `nm main.o` mostra `U my_strlen` e `U my_reverse`
- `nm programa` mostra as duas funções definidas com `T`; os endereços variam conforme plataforma e opções
- `nm programa | grep funcao_nao_usada` não produz saída, demonstrando que `nao_usada.o` não foi extraído
- Não use tamanhos fixos como regra: eles dependem da libc, do linker, de otimizações e de `strip`

---

### Slide 15 – Dentro da Biblioteca .a

**Pontos-chave para falar:**
- `ar -t` lista os `.o` dentro do `.a`
- `nm -g --defined-only libstrutils.a` mostra os símbolos globais definidos em cada membro
- O diagrama mostra `my_strlen.o`, `my_reverse.o` e `nao_usada.o`
- Uma biblioteca `.a` pode conter muitos `.o` — o linker extrai apenas os necessários

---

### Slide 16 – Resumo

**Pontos-chave para falar:**
- Recapitular os 3 conceitos principais de forma rápida
- Reforçar que o Linker é essencial e que sem ele não conseguimos criar programas que usem múltiplos módulos
- O trade-off da ligação estática é: executável maior e mais difícil de atualizar, mas totalmente independente

---

### Slides 17-18 – Referências e Perguntas

> Apresentar as referências rapidamente e abrir para perguntas.

---

## 🧠 Conceitos Importantes para Estudar (Possíveis Perguntas)

### 1. Qual a diferença entre compilação e ligação?
A **compilação** traduz uma linguagem de alto nível para Assembly. O **montador** transforma Assembly em arquivo objeto `.o`. A **ligação** combina objetos e bibliotecas, resolve símbolos e aplica relocações. O **loader** mapeia os segmentos do executável na memória e inicia o processo. O comando `gcc -c` é um driver que aciona mais de uma dessas ferramentas.

### 2. O que é uma tabela de símbolos?
É uma estrutura de dados dentro de cada `.o` que lista: nomes de funções e variáveis globais, seus endereços (ou marcação como "undefined" se são externas), e seu escopo (local ou global).

### 3. O que é relocação?
É o processo no qual o linker posiciona as seções de entrada e corrige as referências marcadas por entradas de relocação. A correção pode gerar endereços absolutos ou deslocamentos relativos, como referências relativas ao RIP em AMD64.

### 4. Diferença entre `.a` e `.so`?
- `.a`: arquivo que reúne módulos objeto; os membros necessários podem ser incorporados pelo linker
- `.so`: biblioteca compartilhada referenciada na ligação e carregada/mapeada durante a execução
- Usar uma `.a` não implica que todas as demais dependências do executável sejam estáticas

### 5. O que é "DLL Hell"?
Problema de incompatibilidade entre versões de bibliotecas compartilhadas. Incorporar uma versão pode reduzir esse risco específico, mas não torna o programa imune a incompatibilidades de sistema, ABI ou outras dependências.

### 6. Por que o GCC usa ligação dinâmica por padrão?
Para economizar espaço em disco e memória, e permitir atualizações de bibliotecas sem recompilar os programas.

### 7. O que acontece se um símbolo não for encontrado?
O linker emite erro: `undefined reference to 'nome_da_funcao'`. O programa não é gerado.

### 8. Comandos úteis para lembrar:
| Comando | O que faz |
|---------|-----------|
| `gcc -S arquivo.c -o arquivo.s` | Para após gerar Assembly |
| `as arquivo.s -o arquivo.o` | Monta Assembly em objeto |
| `gcc -c arquivo.c -o arquivo.o` | Driver que produz `.o` sem executar a ligação |
| `ar rcs lib.a obj.o` | Cria biblioteca estática |
| `gcc main.o ./lib.a -o programa_misto` | Incorpora a `.a`; outras bibliotecas podem ser dinâmicas |
| `gcc -static main.o ./lib.a -o programa` | Solicita um executável completamente estático |
| `nm arquivo` | Lista símbolos |
| `file arquivo` | Mostra tipo do arquivo |
| `readelf -r arquivo.o` | Mostra entradas de relocação |
| `readelf -l executavel` | Mostra Program Headers e segmentos |
| `ldd executavel` | Lista dependências dinâmicas |
| `readelf -h executavel` | Mostra header ELF |

---

## ⏱️ Dicas para a Apresentação

1. **Não leia os slides** — eles têm palavras-chave, use o roteiro para explicar
2. **Use o diagrama** do pipeline logo no início para contextualizar
3. **No exemplo prático**, se possível, abram um terminal e executem os comandos ao vivo
4. **Preparem-se para perguntas** sobre a diferença entre estático e dinâmico — é a pergunta mais provável
5. **Tempo:** mantenham ~20 minutos, deixando 3-5 minutos para perguntas
6. **Transições:** cada pessoa deve fazer uma transição suave (ex: "Agora o Gabriel vai explicar as definições")
