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
> "Primeiro vamos contextualizar onde o Ligador se encaixa no processo de compilação, depois vamos para as definições, as etapas internas do processo, prós e contras, e por fim um exemplo prático."

---

### Slide 3 – Pipeline de Compilação (Contexto)
> Usar o diagrama para mostrar que o Linker é a ÚLTIMA etapa antes de gerar o executável.

**Pontos-chave para falar:**
- O código-fonte passa por: Pré-processador → Compilador → Montador → e gera arquivos-objeto (.o)
- Os arquivos `.o` são **código de máquina**, mas **incompletos** — eles têm referências a funções/variáveis que podem estar em *outros* arquivos
- O **Linker** pega todos esses `.o` e resolve essas referências, gerando o executável final
- Sem o Linker, cada arquivo `.o` seria inútil sozinho

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
- Na ligação estática, TODO o código necessário é copiado para dentro do executável
- O executável resultante é **autossuficiente** — pode rodar em qualquer máquina compatível, sem precisar de bibliotecas instaladas
- Isso é o oposto da ligação dinâmica, onde o executável depende de `.so`/`.dll` externas
- Usar o diagrama comparativo para mostrar visualmente a diferença de tamanho

**Quando ligação estática é usada na prática:**
- Sistemas embarcados (não tem sistema operacional completo)
- Distribuição de ferramentas CLI (ex: binários Go são estaticamente ligados por padrão)
- Containers Docker (para criar imagens menores sem precisar instalar dependências)

**Flag para o GCC:** `gcc -static programa.c -o programa`

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
  - Símbolos **definidos** naquele arquivo (ex: a função `somar` foi escrita aqui)
  - Símbolos **indefinidos** / referências externas (ex: chama `printf`, mas `printf` não está nesse arquivo)
- O ligador percorre todos os `.o` e faz o "casamento": para cada referência indefinida, procura qual `.o` ou biblioteca define aquele símbolo
- Se NÃO encontrar: **erro de ligação** → `undefined reference to 'funcao'`
- Se encontrar MÚLTIPLAS definições: **erro de múltipla definição** → `multiple definition of 'funcao'`
- Usar o diagrama de resolução para mostrar visualmente

**Pergunta que podem fazer:**
> "O que é o erro `undefined reference`?"
> R: É quando o linker não encontra a definição de uma função que foi chamada. Geralmente acontece quando você esqueceu de compilar um dos arquivos `.c` ou de linkar a biblioteca correta.

---

### Slide 9 – Relocação de Endereços (Etapa 2)

**Pontos-chave para falar:**
- **Problema:** cada arquivo `.o` é compilado como se começasse no endereço 0x0000
- Quando o linker junta vários `.o`, os endereços vão colidir
- **Solução:** o linker atribui novos endereços absolutos para cada seção de cada `.o`
- Depois, percorre TODO o código e atualiza cada referência com o endereço correto

**Exemplo simples:**
- `main.o` tem `.text` começando em 0x0000, linker coloca em 0x1000
- `math.o` tem `.text` começando em 0x0000, linker coloca em 0x2000
- Toda chamada a `somar()` dentro de `main.o` precisa ser atualizada para apontar para 0x2000+offset

**Conceito importante:**
- **Entradas de relocação** = instruções dentro do `.o` que dizem ao linker: "aqui tem um endereço que precisa ser corrigido"
- Você pode ver essas entradas com `objdump -r arquivo.o`

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
- Resultado: um arquivo ELF que o sistema operacional sabe carregar e executar

**Formato ELF (Executable and Linkable Format):**
- É o formato padrão de executáveis no Linux
- Contém: header + seções de código + seções de dados + tabela de símbolos
- Equivalente no Windows: PE (Portable Executable)

---

### Slide 11 – Vantagens e Desvantagens

**Vantagens — explicar cada uma:**
1. **Portabilidade:** o executável roda em qualquer máquina com a mesma arquitetura, sem precisar instalar nada
2. **Desempenho:** não tem overhead de carregar bibliotecas em tempo de execução
3. **Confiabilidade:** imune ao "DLL Hell" (quando programas diferentes precisam de versões diferentes da mesma `.dll`)
4. **Distribuição simples:** basta copiar um arquivo

**Desvantagens — explicar cada uma:**
1. **Tamanho maior:** todo o código da biblioteca é copiado, mesmo que você use só uma função
2. **Duplicação:** se 10 programas usam a `libc` estaticamente, cada um tem sua própria cópia na memória
3. **Atualização difícil:** se a biblioteca recebe um patch de segurança, é preciso recompilar e redistribuir todos os programas
4. **Consumo de memória:** mais memória RAM usada por causa da duplicação

**Caso de uso para mencionar:**
- Go compila tudo estaticamente por padrão → facilita deploy, mas binários são grandes
- Rust permite escolher entre estático e dinâmico

---

### Slide 12 – Exemplo Prático: Código Fonte

**Pontos-chave para falar:**
- Temos dois arquivos: `math_utils.c` (implementa `somar` e `multiplicar`) e `main.c` (usa essas funções)
- O `math_utils.h` é o header que declara as funções (permite que `main.c` saiba que elas existem)
- Mostrar que `main.c` chama `somar()` e `multiplicar()` — essas referências serão **indefinidas** no `main.o` e precisam ser resolvidas pelo linker

---

### Slide 13 – Exemplo Prático: Processo

**Pontos-chave para falar:**
- **Passo 1:** `gcc -c` compila sem linkar → gera arquivos `.o`
- **Passo 2:** `ar rcs` cria a biblioteca estática `.a` empacotando o `.o`
  - `r` = replace, `c` = create, `s` = index (para busca rápida de símbolos)
- **Passo 3:** `gcc -static` faz a ligação estática
  - `-L.` = procurar bibliotecas no diretório atual
  - `-lmath` = procurar `libmath.a` (convenção: `-l<nome>` → `lib<nome>.a`)
  - `-static` = forçar ligação estática

**Dica:** se possível, demonstrar ao vivo no terminal durante a apresentação!

---

### Slide 14 – Exemplo Prático: Saída

**Pontos-chave para falar:**
- `./programa` funciona e mostra "Soma: 8" e "Produto: 15"
- `file programa` confirma que é "statically linked"
- `nm programa` mostra os símbolos — `somar` e `multiplicar` estão lá com endereços finais (não mais 0x0000)
- Comparação de tamanho: estático (~872K) vs dinâmico (~17K) — diferença gritante!
  - Isso porque na versão estática, toda a `libc` foi incluída

---

### Slide 15 – Dentro da Biblioteca .a

**Pontos-chave para falar:**
- `ar -t` lista os `.o` dentro do `.a`
- `nm math_utils.o` mostra os símbolos antes da ligação — note que os endereços começam em 0x0000
- O diagrama visual mostra a estrutura hierárquica: `.a` → `.o` → funções
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
A **compilação** traduz código-fonte para código de máquina (gera `.o`). A **ligação** combina múltiplos `.o` e resolve referências entre eles para gerar o executável.

### 2. O que é uma tabela de símbolos?
É uma estrutura de dados dentro de cada `.o` que lista: nomes de funções e variáveis globais, seus endereços (ou marcação como "undefined" se são externas), e seu escopo (local ou global).

### 3. O que é relocação?
É o processo de recalcular endereços de memória quando múltiplos `.o` são combinados. Cada `.o` tem endereços relativos (começando em 0x0), e o linker converte para endereços absolutos no executável final.

### 4. Diferença entre `.a` e `.so`?
- `.a` (estática): código copiado para o executável, maior, independente
- `.so` (dinâmica): código carregado em runtime, menor, dependente

### 5. O que é "DLL Hell"?
Problema que ocorre quando diferentes programas precisam de versões diferentes da mesma biblioteca dinâmica, causando conflitos. A ligação estática evita isso.

### 6. Por que o GCC usa ligação dinâmica por padrão?
Para economizar espaço em disco e memória, e permitir atualizações de bibliotecas sem recompilar os programas.

### 7. O que acontece se um símbolo não for encontrado?
O linker emite erro: `undefined reference to 'nome_da_funcao'`. O programa não é gerado.

### 8. Comandos úteis para lembrar:
| Comando | O que faz |
|---------|-----------|
| `gcc -c arquivo.c` | Compila sem linkar (gera `.o`) |
| `ar rcs lib.a obj.o` | Cria biblioteca estática |
| `gcc -static main.o -lbib` | Ligação estática |
| `nm arquivo` | Lista símbolos |
| `file arquivo` | Mostra tipo do arquivo |
| `objdump -r arquivo.o` | Mostra entradas de relocação |
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
