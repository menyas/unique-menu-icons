# Unique Menu Icons

Gives every Gen 1 Pokemon its own unique party/menu icon, instead of
the game's default "group" icons (BALL, BIRD, BUG, FAIRY, GRASS,
HELIX, MON, QUADRUPED, SNAKE, WATER) shared across many species.

## Installation

1. Copy the whole `unique_menu_icons/` folder into the game's mods
   folder:
   - **Windows:** `%APPDATA%\love\pokemon-love2d\mods\`
   - **macOS:** `~/Library/Application Support/LOVE/pokemon-love2d/mods/`
   - **Linux:** `~/.local/share/love/pokemon-love2d/mods/`
2. Open the game, go to Options > Mods, and enable `unique_menu_icons`.
3. Restart the game.

## About icon and battle sprite colors

This mod overrides **only the `MEWMON` palette** (one of the game's
10 shared "monster" palettes: `MEWMON`, `BLUEMON`, `REDMON`,
`CYANMON`, `PURPLEMON`, `BROWNMON`, `GREENMON`, `PINKMON`,
`YELLOWMON`, `GREYMON`) with the authentic Gen 2 color scheme, sampled
directly from real Gold/Silver/Crystal icon art: white
`(255,255,255)`, light red `(248,152,80)`, dark red `(248,56,32)`,
and black `(0,0,0)`. The other 9 keep the game's normal values — the
vast majority of species are unaffected.

`MEWMON` is the palette used by the **party menu's icon column**
(hardcoded in the game's code, `src/ui/PartyMenu.lua`, regardless of
which Pokemon is shown), and it's also the species palette for
**Mew, Mewtwo, and Jynx**. It works in both display modes:

- **SGB** (the game's default): via `mod.content.palettes:override`.
- **ADVANCED**: this mode reads from a separate source
  (`PaletteFX.gbcPack()`, a plain cached `require("data.palettes_gbc")`
  with no connection to the mod content registry system). To also
  work here, this mod calls that same `require` and mutates the
  `MEWMON` entry of the resulting table directly in place — since Lua
  caches modules process-wide, it's the exact same table the engine
  reads. **This is not part of the official mod API**, so it's not
  guaranteed to keep working across future game versions; it's
  wrapped in `pcall` (if it fails, icon registration keeps working
  normally — only the Advanced-mode color fix would be skipped).

OG/OG INV/CLASSIC display modes use an unrelated mechanism and are
unaffected by any of this.

### The "GBC PALLETE ON/OFF" option

`MEWMON` is a special case: besides coloring the menu icon column and
Mew/Mewtwo/Jynx's own battle/Dex sprites, it's also reused by the
**title screen** (`src/ui/TitleState.lua`) and **Professor Oak's
intro speech** (`src/ui/OakSpeech.lua`) — both hardcoded in the
engine with no way to distinguish "MEWMON for icons" from "MEWMON for
the title screen". There's no way to override one without affecting
the other.

Because of that, there's an in-game toggle at **Options > Mods >
Unique Menu Icons > "GBC PALLETE ON/OFF (ALTERS INTRO AND SOME
SPRITES)"**:

| Option | Menu icons + Mew | Title screen + Oak's intro |
| ------ | ---------------- | --------------------------- |
| ON (default) | Gen 2 red | Also turn red (side effect) |
| OFF | Game's normal colors | Untouched, original colors |

Toggle it and restart the game to apply (content registries freeze
after boot). If the options system is unavailable for any reason, the
mod defaults to ON.

To change the actual colors, edit the `RED_YELLOW_PALETTE` table in
`main.lua` (4 colors, lightest to darkest).

## What's included

- `manifest.json` — mod manifest (api 2).
- `main.lua` — registers a unique icon (`mod.content.icons:register`)
  for each of the 151 Gen 1 species, exposes the "GBC PALLETE ON/OFF"
  option, and overrides the `MEWMON` palette when it's on.
- `assets/icons/*.png` — the 151 icons (16x32, two 16x16 frames
  stacked for the menu's bounce animation), in 4-shade grayscale
  following the engine's pixel contract.

## Swapping in different art

Overwrite the species' file, keeping the 4-shade grayscale format
(white `255`, light `170`, dark `85`, black `0`):

```
assets/icons/PIKACHU.png
assets/icons/CHARIZARD.png
```

No need to touch `main.lua` — the path is already registered. If a
file doesn't exist, the mod simply skips that species and it keeps
the vanilla icon (won't break loading).

## Species list

All 151 Gen 1 species (standard internal names: `NIDORAN_F`,
`NIDORAN_M`, `MR_MIME`, `FARFETCHD`, etc.) are listed at the top of
`main.lua`.

## Credits

The icon sprites used in this mod are from the **MiniDex** set,
created by **Chamber**, **Solo0993**, **Blue Emerald**, **Lake**,
**Neslug**, and **Pikachu25**. All credit for the original art goes
to them; this mod only handles converting/integrating it into the
gen1recomp format and the `MEWMON` palette recolor.
