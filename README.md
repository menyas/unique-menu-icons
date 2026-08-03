# Unique Menu Icons

Dá a cada um dos 151 Pokémon de Gen 1 um ícone único de menu/equipe,
em vez dos ícones de "grupo" padrão do jogo (BALL, BIRD, BUG, FAIRY,
GRASS, HELIX, MON, QUADRUPED, SNAKE, WATER) compartilhados entre várias
espécies.

## Instalação

1. Copie a pasta `unique_menu_icons/` inteira para a pasta de mods do jogo:
   - **Windows:** `%APPDATA%\love\pokemon-love2d\mods\`
   - **macOS:** `~/Library/Application Support/LOVE/pokemon-love2d/mods/`
   - **Linux:** `~/.local/share/love/pokemon-love2d/mods/`
2. Abra o jogo, vá em Options > Mods e ative `unique_menu_icons`.
3. Reinicie o jogo.

## Sobre a cor dos ícones e sprites de batalha (modos SGB/Advanced)

Nos modos de exibição **SGB** e **ADVANCED**, cada uma das 151
espécies é atribuída a uma de **10 paletas de "monstro"
compartilhadas** (`MEWMON`, `BLUEMON`, `REDMON`, `CYANMON`,
`PURPLEMON`, `BROWNMON`, `GREENMON`, `PINKMON`, `YELLOWMON`,
`GREYMON` — o esquema clássico de Super Game Boy do Gen 1, ainda em
uso aqui mesmo no modo "Advanced"). Isso vale tanto pra coluna de
ícones do menu (que sempre renderiza através da paleta `MEWMON`,
fixa no código do jogo, não importa a espécie) quanto pros sprites de
batalha/Dex de cada Pokémon.

Este mod sobrescreve essas paletas com o esquema de cores autêntico
do Gen 2, extraído direto de uma referência real dos ícones de
Gold/Silver/Crystal: branco `(255,255,255)`, vermelho-claro
`(248,152,80)`, vermelho-escuro `(248,56,32)` e preto `(0,0,0)`. Isso
funciona nos dois modos:

- **SGB** (o padrão do jogo): via `mod.content.palettes:override`.
- **ADVANCED**: esse modo não lê `mod.content.palettes` — ele troca
  de fonte pra `PaletteFX.gbcPack()` (`require("data.palettes_gbc")`,
  um módulo Lua comum e cacheado, sem ligação com o sistema de
  registries de mod). Pra funcionar aqui também, o mod dá esse mesmo
  `require` e **muta a tabela em memória diretamente** — como módulos
  Lua são cacheados pelo processo inteiro, é a mesma tabela que o
  motor usa. **Isso não é a API "oficial" de mods** (é reaproveitar um
  mecanismo interno do Lua), então não tem garantia de continuar
  funcionando em versões futuras do jogo, e está protegido com
  `pcall`: se falhar, o resto do mod continua funcionando normalmente,
  só o Advanced ficaria sem o ajuste.

Os modos OG/OG INV/CLASSIC usam outro mecanismo totalmente diferente
e não são afetados por nada disso.

### A opção "GBC PALLETE ON/OFF"

A paleta `MEWMON` é um caso especial: além de colorir a coluna de
ícones do menu e o sprite de batalha/Dex do próprio **Mew** (e
Mewtwo, e Jynx — as únicas 3 espécies que usam essa paleta), ela
também é reaproveitada pela **tela de título** (`src/ui/TitleState.lua`)
e pela **fala de introdução do Professor Oak** (`src/ui/OakSpeech.lua`)
— chamadas hardcoded no motor do jogo, sem nenhuma forma de
diferenciar "MEWMON pros ícones" de "MEWMON pro título". Não tem como
sobrescrever uma sem afetar a outra.

Por isso existe uma opção liga/desliga **direto no jogo**, em
**Options > Mods > Unique Menu Icons > "GBC PALLETE ON/OFF (ALTERS
INTRO AND SOME SPRITES)"**:

| Opção   | Ícones do menu + Mew | Tela de título + intro do Oak |
| ------- | --------------------- | ------------------------------ |
| Ligada  | Vermelho Gen 2         | Também ficam vermelhos (efeito colateral) |
| Desligada | Cor padrão do jogo   | Intactos, cor original          |

Vem ligada por padrão. Independente da opção, as **outras 9 paletas**
(tudo exceto `MEWMON`) são sempre sobrescritas — ou seja, todas as
espécies exceto Mew/Mewtwo/Jynx sempre ficam no esquema Gen 2 nos
sprites de batalha/Dex, com qualquer valor da opção.

Mude a opção e reinicie o jogo pra aplicar (os registros de conteúdo
"congelam" depois do boot). Se por algum motivo o sistema de opções
não estiver disponível, o mod usa `true` (MEWMON incluído) como
padrão de segurança.

Pra trocar as cores em si, edite a tabela `RED_YELLOW_PALETTE`, logo
acima da opção no `main.lua` (4 cores, do tom mais claro ao mais
escuro).

## O que vem incluído

- `manifest.json` — manifesto do mod (api 2).
- `main.lua` — registra um ícone único (`mod.content.icons:register`)
  para cada uma das 151 espécies de Gen 1 e sobrescreve as paletas de
  "monstro" compartilhadas (9 ou 10, dependendo do `INCLUDE_MEWMON`)
  usadas pelos ícones do menu e pelos sprites de batalha/Dex.
- `assets/icons/*.png` — os 151 ícones (16×32, 2 frames de 16×16
  empilhados para a animação de "bounce" do menu), em 4 tons de cinza
  seguindo o "pixel contract" do engine.

## Como trocar por outra arte

Sobrescreva o arquivo da espécie, mantendo o formato 4 tons de cinza
(branco `255`, claro `170`, escuro `85`, preto `0`):

```
assets/icons/PIKACHU.png
assets/icons/CHARIZARD.png
```

Não precisa mexer no `main.lua` — o caminho já está registrado. Se um
arquivo não existir, o mod simplesmente pula aquela espécie e ela
mantém o ícone vanilla (não quebra o carregamento).

## Lista de espécies

Todas as 151 espécies de Gen 1 (nomes internos padrão: `NIDORAN_F`,
`NIDORAN_M`, `MR_MIME`, `FARFETCHD`, etc.) estão listadas no topo do
`main.lua`.

## Créditos

Os sprites de ícone usados neste mod são do conjunto **MiniDex**,
criado por **Chamber**, **Solo0993**, **Blue Emerald**, **Lake**,
**Neslug** e **Pikachu25**. Todo o crédito da arte original é dos
autores; este mod só faz a conversão/integração pro formato do
gen1recomp e a recolorização de paleta.
