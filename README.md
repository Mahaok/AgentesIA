# Agentes IA — Projeto TopDown 🏹🌾

Jogo 2D *top-down* desenvolvido na **Godot Engine**, no estilo de um RPG/sandbox de sobrevivência inspirado visualmente em *Age of Empires*. O projeto reúne um sistema de personagem controlável, agricultura (plantio e colheita), coleta de recursos, animais de fazenda, inimigos com IA de perseguição/ataque, uma ilha inimiga acessível por barco e uma vila com construções decorativas.

> ⚠️ Este README foi elaborado a partir da análise direta do código-fonte do repositório, já que o projeto ainda não possuía documentação própria. Alguns comportamentos descritos refletem o estado atual (e experimental) do código, incluindo funcionalidades parcialmente implementadas.

---

## 📋 Sumário

- [Visão geral](#-visão-geral)
- [Tecnologias utilizadas](#-tecnologias-utilizadas)
- [Estrutura do repositório](#-estrutura-do-repositório)
- [Como executar o projeto](#-como-executar-o-projeto)
- [Controles](#-controles)
- [Principais sistemas e mecânicas](#-principais-sistemas-e-mecânicas)
  - [Personagem jogável](#1-personagem-jogável)
  - [Autoloads (singletons globais)](#2-autoloads-singletons-globais)
  - [Sistema de plantio e colheita](#3-sistema-de-plantio-e-colheita)
  - [Coleta de recursos](#4-coleta-de-recursos)
  - [Animais de fazenda](#5-animais-de-fazenda)
  - [Inimigos e IA](#6-inimigos-e-ia)
  - [Ilha inimiga, barco e ponte](#7-ilha-inimiga-barco-e-ponte)
  - [Câmera](#8-câmera)
  - [Cenário e decoração](#9-cenário-e-decoração)
- [Grupos globais (Godot Groups)](#-grupos-globais-godot-groups)
- [Estado atual / limitações conhecidas](#-estado-atual--limitações-conhecidas)
- [Possíveis próximos passos](#-possíveis-próximos-passos)
- [Licença](#-licença)

---

## 🎮 Visão geral

**Agentes IA** é um protótipo de jogo em desenvolvimento onde o jogador controla um personagem (camponês) em uma vila vista de cima, podendo:

- Se mover livremente pelo mapa;
- Plantar e colher **tomates** e **melancias**;
- Cortar árvores para coletar **madeira**;
- Interagir com animais (**galinhas**, **vacas**, **ovelhas**);
- Atacar inimigos com golpes à esquerda/direita;
- Atravessar a água por meio de um **barco/canoa** até uma **ilha inimiga**, onde enfrenta goblins, goblins com dinamite (TNT) e slimes;
- Ajustar o zoom da câmera e resetar a cena a qualquer momento.

O nome do repositório ("Agentes IA") remete ao foco do projeto: o comportamento autônomo (IA) dos inimigos e animais, que se movem aleatoriamente, detectam o jogador em áreas de sensor e alternam entre perseguição e ataque.

---

## 🛠️ Tecnologias utilizadas

| Item | Detalhe |
|---|---|
| Engine | **Godot Engine 4.7** (`config/features = "4.7", "GL Compatibility"`) |
| Linguagem | **GDScript** |
| Renderização | `gl_compatibility` (compatível com hardware mais modesto/web) |
| Física | **Jolt Physics** (`3d/physics_engine = "Jolt Physics"`) |
| Resolução base | 960x640, com `stretch/mode = canvas_items` |

---

## 📁 Estrutura do repositório

```
AgentesIA/
├── .gitattributes
└── agentes-ia/                  # Projeto Godot (abrir esta pasta no editor)
    ├── project.godot            # Configurações do projeto (input, autoloads, display)
    ├── Principal.gd             # Script global do gerenciamento de item/plantio
    ├── dados.gd                 # Autoload com o estado (dados) do jogador
    ├── barco_teste.gd           # Lógica alternativa/teste de navegação de barco
    ├── decoracao.gd             # Sorteia texturas aleatórias para elementos decorativos
    │
    ├── personagem/               # Personagens jogáveis e câmera
    │   ├── peao.gd / peao.tscn           # Personagem principal (camponês)
    │   ├── peao_teste.gd / .tscn         # Variante de teste do camponês
    │   ├── peao_jogavel.tscn
    │   ├── arqueiro.gd, cavaleiro.gd,
    │   │   lanceiro.gd, padre.gd         # Unidades adicionais (arqueiro, cavaleiro, lanceiro, padre)
    │   ├── camera_2d.gd                  # Câmera com zoom controlado pelo scroll do mouse
    │   ├── segura_info.gd                # HUD (sementes/tomates coletados)
    │   └── Archer/ Lancer/ Monk/ Pawn/ Warrior/  # Sprites e assets das unidades
    │
    ├── Inimigos/
    │   ├── goblin.gd / .tscn             # Goblin melee com perseguição
    │   ├── slime.gd / .tscn              # Slime que persegue e ataca por contato
    │   └── TNT/
    │       ├── tnt.gd                    # Goblin "bombardeiro" que arremessa dinamite
    │       └── dinamite.gd               # Comportamento da bomba/explosão
    │
    ├── Buildings/
    │   ├── Canoa/canoa.gd                # Embarcação estática (navegação até a ilha)
    │   ├── Porto/ponte.gd                # Ponte/embarque, referência ao barco
    │   ├── Goblin/                       # Sprites de construções goblin
    │   ├── Purple Buildings/, Red Buildings/, Yellow Buildings/  # Sets de construções da vila
    │
    ├── Coletaveis/
    │   ├── componente_coletavel.gd       # Componente genérico de item coletável
    │   └── wood.tscn                     # Cena de madeira coletável (drop das árvores)
    │
    ├── Resources/
    │   ├── Trees/  arvore_unica.gd (PhysicsTree), arvore_branca.gd
    │   ├── Plantas/ tomate.gd, melancia.gd, semente.gd
    │   ├── Chicken/galinha.gd, Cow/vaca.gd, Sheep/ovelha.gd
    │   └── Gold Mine/                    # Assets de mina de ouro (visual)
    │
    ├── Terrain/
    │   ├── mapa.gd / mapa.tscn           # Cena principal do mapa/vila
    │   ├── ilha_inimigos.gd              # Lógica de colisão da ilha inimiga
    │   ├── Ground/, Water/, Bridge/      # Tilesets de terreno, água e pontes
    │
    └── Decoration/                       # Nuvens, arbustos, cogumelos, pedras, etc.
```

---

## ▶️ Como executar o projeto

1. Instale o **Godot Engine 4.7** (ou superior compatível, na versão estável 4.x) — [godotengine.org](https://godotengine.org/download).
2. Clone o repositório:
   ```bash
   git clone https://github.com/Mahaok/AgentesIA.git
   ```
3. Abra o **Godot Engine**, clique em **Import** e selecione o arquivo:
   ```
   AgentesIA/agentes-ia/project.godot
   ```
4. Com o projeto carregado, pressione **F5** (ou o botão "Play") para executar a cena principal, definida em `run/main_scene` (o mapa da vila, `Terrain/mapa.tscn`).

> Não há necessidade de instalar dependências externas: o projeto usa apenas recursos nativos da Godot 4.7.

---

## ⌨️ Controles

| Ação | Tecla / Botão |
|---|---|
| Mover (cima/baixo/esquerda/direita) | `W` `A` `S` `D` |
| Ataque à esquerda | Clique esquerdo do mouse |
| Ataque à direita | Clique direito do mouse |
| Interagir (embarcar/desembarcar, coletar semente) | `E` |
| Plantar item selecionado | `P` |
| Colher planta madura | `C` |
| Trocar item de plantio (tomate / melancia / nada) | `X` |
| Navegar (mover o barco/canoa) | `G` |
| Zoom in / Zoom out da câmera | Scroll do mouse (cima/baixo) |
| Reiniciar a cena atual | `Espaço` |

*(mapeamento definido em `project.godot`, seção `[input]`)*

---

## 🧩 Principais sistemas e mecânicas

### 1. Personagem jogável

O personagem principal (`personagem/peao.gd`, classe `BaseCharacter`) é um `CharacterBody2D` que:

- Move-se em 8 direções via `Input.get_vector("left", "right", "up", "down")`, com `move_speed = 128`;
- Ataca à esquerda/direita (animações `left_attack_name` / `right_attack_name`), travando o `_physics_process` durante a animação de ataque;
- Possui `health`, `min_attack`/`max_attack` (dano aleatório) e fica marcado como `is_dead` quando a vida chega a zero;
- Detecta colisão da área de ataque contra árvores (`PhysicsTree`) e inimigos (grupo `enemy`), aplicando dano;
- Exibe visualmente o item selecionado (tomate/melancia) acima do personagem, sincronizado com `Principal.item_atual`.

Também existem esboços de outras unidades jogáveis/aliadas — **arqueiro**, **cavaleiro**, **lanceiro** e **padre** (`personagem/arqueiro.gd`, `cavaleiro.gd`, `lanceiro.gd`, `padre.gd`) — que atualmente compartilham a mesma lógica de IA usada pelos inimigos (movimento aleatório, perseguição por área de detecção e ataque por distância), sugerindo que serão usadas futuramente como aliados/NPCs controlados por IA em vez de inimigos.

### 2. Autoloads (singletons globais)

Definidos em `project.godot → [autoload]`:

- **`Dados`** (`dados.gd`): guarda o estado persistente do jogador durante a sessão — `tomates` (quantidade colhida), `semente_tomate` (sementes disponíveis) e `por_cima_da_planta` (flag para impedir plantar em cima de outra planta).
- **`Principal`** (`Principal.gd`): controla qual item está selecionado para plantio (`itens = ["tomate", "melancia", "nada_selecionado"]`), realiza o plantio propriamente dito (instancia a cena da planta na posição alinhada ao *grid* de 64px) e escuta o input de reset (`reseta`) para recarregar a cena.

### 3. Sistema de plantio e colheita

- O jogador coleta **sementes de tomate** (`Resources/Plantas/semente.gd`) ao interagir (`E`) próximo a elas.
- Com sementes disponíveis e dentro de uma `area_plantio`, pressionar `P` planta um **tomate** ou **melancia** (`Resources/Plantas/tomate.gd` / `melancia.gd`), alinhado ao grid.
- Cada planta passa por **6 estágios de crescimento**, avançando um frame de sprite a cada 10 segundos, até ficar madura (`pode_colher = true`).
- Ao colher (`C`) uma planta madura próxima, o jogador ganha **+2 sementes** e **+1 unidade colhida**, e a planta é removida da cena.
- O HUD (`personagem/segura_info.gd`) exibe em tempo real a quantidade de sementes e de tomates via `Dados`.

### 4. Coleta de recursos

- Árvores (`Resources/Trees/arvore_unica.gd`, classe `PhysicsTree`) possuem vida aleatória (10–30) e, ao serem atacadas pelo jogador, recebem dano aleatório (`min_attack`–`max_attack`).
- Ao "morrer", a árvore gera de 1 a 5 itens de **madeira** (`Coletaveis/wood.tscn`) espalhados ao redor, e faz *respawn* automático após 5 segundos.
- O componente genérico `Coletaveis/componente_coletavel.gd` detecta quando o personagem toca no item coletável e o remove da cena (a lógica de adicionar o item ao inventário do jogador está comentada no código, indicando um sistema de inventário ainda não finalizado).

### 5. Animais de fazenda

- **Galinha** (`galinha.gd`), **vaca** (`vaca.gd`) e **ovelha** (`ovelha.gd`) se movem aleatoriamente pelo mapa em intervalos definidos por um `Timer`.
- Galinha e vaca fogem do jogador (e de inimigos) quando detectados em sua área de sensor, invertendo a direção do movimento.
- A ovelha, ao sofrer dano (`update_health`), tem um breve pico de velocidade (efeito de "susto").

### 6. Inimigos e IA

Todos os inimigos seguem um padrão semelhante de máquina de estados simples:

1. **Vagar aleatoriamente** — a cada intervalo aleatório (2–5s), sorteiam uma nova direção entre 8 vetores possíveis (incluindo parado).
2. **Detecção** — uma `Area2D` de detecção identifica o jogador (grupo `character`/`enemy`/`aliado`, dependendo da unidade) e passa a persegui-lo.
3. **Perseguição e ataque** — ao ficar próximo o suficiente, o inimigo para, executa a animação de ataque e aplica dano via `update_health()` no corpo detectado.
4. **Morte** — ao receber dano fatal, toca a animação de morte e se remove da cena (`queue_free`) ao final da animação.

Tipos de inimigos implementados:

- **Goblin** (`Inimigos/goblin.gd`): inimigo corpo a corpo padrão, com alcance de ataque de 64px.
- **Goblin com TNT** (`Inimigos/TNT/tnt.gd` + `dinamite.gd`): ao detectar o jogador, arremessa periodicamente uma dinamite (`Inimigos/TNT/dinamite.tscn`) que persegue o alvo por um curto período e explode ao contato ou após 1 segundo, causando dano em área.
- **Slime** (`Inimigos/slime.gd`): inimigo simples que persegue o jogador por contato direto, sem sistema de ataque com timer.

### 7. Ilha inimiga, barco e ponte

- O mapa principal (`Terrain/mapa.tscn` / `mapa.gd`) contém uma **ilha inimiga** separada (`Terrain/ilha_inimigos.gd`) acessível apenas por água.
- **Canoa** (`Buildings/Canoa/canoa.gd`, classe `Barco`) e **barco de teste** (`barco_teste.gd`) implementam a navegação: ao entrar na embarcação, o personagem tem suas camadas de colisão trocadas (de "terra" para "água/barco"), permitindo o deslocamento sobre a água até um ponto de ancoragem (`PinIlha`) e desembarque em `PinDesembarque`.
- A **ponte** (`Buildings/Porto/ponte.gd`, classe `Ponte`) controla o embarque do jogador e detecta a presença do barco na área do porto.
- Esse sistema ainda apresenta duas implementações paralelas (`canoa.gd` e `barco_teste.gd`) com lógicas ligeiramente diferentes, sugerindo iteração em andamento sobre a mecânica de navegação.

### 8. Câmera

A câmera (`personagem/camera_2d.gd`, classe `CharacterCamera`) permite zoom in/out suave pelo scroll do mouse, com limites configuráveis (`min_zoom = 0.5`, `max_zoom = 3.0`).

### 9. Cenário e decoração

- `decoracao.gd` sorteia aleatoriamente uma textura de uma lista (`_textures_list`) para cada `Sprite2D` filho, usado para variar visualmente elementos decorativos repetidos (arbustos, pedras, cogumelos, nuvens).
- A pasta `Buildings/` contém conjuntos de construções (casas roxas, vermelhas, amarelas, construções goblin, porto) usadas para montar visualmente a vila e a ilha inimiga.

---

## 🏷️ Grupos globais (Godot Groups)

Definidos em `project.godot → [global_group]`, usados para identificar tipos de nós em tempo de execução (ex.: `body.is_in_group("enemy")`):

- `enemy` — inimigos (goblins, slimes, TNT);
- `character` — o personagem jogável;
- `aliado` — unidades aliadas (arqueiro, cavaleiro, lanceiro, padre);
- `animais` — animais de fazenda (afetados, por exemplo, por explosões);
- `plantas` — plantações;
- `bomba` — bombas/dinamite;
- `ponte` — elementos de ponte;
- `barco` — embarcações.

---

## 🚧 Estado atual / limitações conhecidas

Por ser um projeto em desenvolvimento ativo, o código apresenta alguns pontos ainda incompletos ou experimentais, identificados na análise:

- Sistema de **inventário** para madeira está com a lógica de adição de item comentada em `componente_coletavel.gd`.
- Existem **duas versões do personagem principal** (`peao.gd`/`peao.tscn` e `peao_teste.gd`/`peao_teste.tscn`), aparentemente uma cópia de trabalho da outra.
- Existem **duas implementações de barco** (`canoa.gd` e `barco_teste.gd`) com comportamentos parecidos, porém não unificados.
- Arquivos temporários do editor (`peao.tscn1916648451.tmp`, `peao.tscn3302004432.tmp`) estão versionados no repositório.
- As unidades aliadas (arqueiro, cavaleiro, lanceiro, padre) ainda reutilizam a IA de inimigo (perseguem e atacam o grupo `enemy`), e não possuem, no código atual, um comportamento diferenciado de "aliado".
- Não há sistema de menu, vitória/derrota ou persistência de save — o `Espaço` apenas recarrega a cena atual.

---

## 🗺️ Possíveis próximos passos

Sugestões de evolução com base na estrutura já existente:

- Finalizar o sistema de inventário (madeira, sementes, colheita) de forma unificada.
- Consolidar as implementações duplicadas de personagem e barco.
- Implementar comportamento próprio de aliados (seguir o jogador, apoiar em combate) distinto da IA de inimigos.
- Adicionar HUD de vida do jogador e dos inimigos.
- Criar um menu inicial e um objetivo/condição de vitória para a exploração da ilha inimiga.

---

## 📄 Licença

O repositório não possui um arquivo de licença até o momento. Recomenda-se adicionar uma licença (ex.: MIT) caso o projeto seja destinado a uso ou contribuição pública.
