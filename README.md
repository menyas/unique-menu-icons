# Unique Menu Icons

Gives each of the 151 Gen 1 Pokémon a unique menu/team icon,
instead of the game's default “group” icons (BALL, BIRD, BUG, FAIRY,
GRASS, HELIX, MON, QUADRUPED, SNAKE, WATER) shared among multiple
species.

## Installation

1. Copy the entire `unique_menu_icons/` folder to the game’s mods folder:
   - **Windows:** `%APPDATA%\love\pokemon-love2d\mods\`
   - **macOS:** `~/Library/Application Support/LOVE/pokemon-love2d/mods/`
   - **Linux:** `~/.local/share/love/pokemon-love2d/mods/`
2. Open the game, go to Options > Mods, and enable `unique_menu_icons`.
3. Restart the game.

## About the Color of Icons and Battle Sprites (SGB/Advanced Modes)

In **SGB** and **ADVANCED** display modes, each of the 151
species is assigned to one of **10 shared “monster”
palettes** (`MEWMON`, `BLUEMON`, `REDMON`, `CYANMON`,
`PURPLEMON`, `BROWNMON`, `GREENMON`, `PINKMON`, `YELLOWMON`,
`GREYMON`—the classic Gen 1 Super Game Boy color scheme, still in
use here even in “Advanced” mode). This applies both to the
menu icon column (which always renders using the `MEWMON` palette,
hardcoded into the game regardless of species) and to the
battle/Dex sprites for each Pokémon.

This mod overrides these palettes with the authentic
Gen 2 color scheme, extracted directly from an actual reference of the
Gold/Silver/Crystal: white `(255,255,255)`, light red
`(248,152,80)`, dark red `(248,56,32)`, and black `(0,0,0)`. This
works in both modes:

- **SGB** (the game's default): via `mod.content.palettes:override`.
- **ADVANCED**: this mode does not read `mod.content.palettes`—it switches
  the source to `PaletteFX.gbcPack()` (`require(“data.palettes_gbc”)`,
  a standard, cached Lua module, unrelated to the mod
  registry system). To work here as well, the mod provides this same
  `require` and **modifies the table in memory directly**—since Lua modules
  are cached for the entire process, it’s the same table that the
  engine uses. **This is not the “official” mod API** (it reuses an
  internal Lua mechanism), so there’s no guarantee it will continue
  to work in future versions of the game, and it’s protected with
  `pcall`: if it fails, the rest of the mod continues to function normally;
  only Advanced would lose the adjustment.

The OG/OG INV/CLASSIC modes use a completely different mechanism
and are not affected by any of this.

### The “GBC PALLET ON/OFF” option

The `MEWMON` palette is a special case: in addition to coloring the
menu icon column and the battle/Dex sprite of **Mew** itself (and
Mewtwo, and Jynx—the only three species that use this palette), it
is also reused by the **title screen** (`src/ui/TitleState.lua`)
and by **Professor Oak’s introductory speech** (`src/ui/OakSpeech.lua`)
— both of which are hardcoded into the game engine, with no way to
distinguish between “MEWMON for icons” and “MEWMON for the title.” There’s no way to
override one without affecting the other.

That's why there's a toggle option **right in the game**, under
**Options > Mods > Unique Menu Icons > "GBC PALLET ON/OFF (CHANGES
INTRO AND SOME SPRITES)"**:

| Option   | Menu icons + Mew | Title screen + Oak's intro |
| ------- | --------------------- | ------------------------------ |
| On   | Gen 2 Red         | Also turn red (side effect) |
| Off | Default game color   | Unchanged, original color          |

It is enabled by default. Regardless of the setting, the **other 9 palettes**
(all except `MEWMON`) are always overwritten—that is, all
species except Mew/Mewtwo/Jynx always use the Gen 2 color scheme in
battle/Dex sprites, regardless of the option’s value.

Change the option and restart the game to apply the changes (content registers
“freeze” after boot). If for some reason the options system
is unavailable, the mod uses `true` (MEWMON included) as a
safety default.

To change the colors themselves, edit the `RED_YELLOW_PALETTE` table, right
above the option in `main.lua` (4 colors, from lightest to
darkest).

## What's Included

- `manifest.json` — mod manifest (API 2).
- `main.lua` — registers a unique icon (`mod.content.icons:register`)
  for each of the 151 Gen 1 species and overrides the shared
  “monster” palettes (9 or 10, depending on `INCLUDE_MEWMON`)
  used by the menu icons and battle/Dex sprites.
- `assets/icons/*.png` — the 151 icons (16×32, 2 frames of 16×16
  stacked for the menu’s “bounce” animation), in 4 shades of gray
  following the engine’s “pixel contract.”

## How to Replace with Different Art

Overwrite the species file, maintaining the 4-shade-of-gray format
(white `255`, light `170`, dark `85`, black `0`):

```
assets/icons/PIKACHU.png
assets/icons/CHARIZARD.png
```

You don’t need to edit `main.lua`—the path is already registered. If a
file doesn’t exist, the mod simply skips that species and it
keeps the vanilla icon (it doesn’t break the loading process).

## List of Species

All 151 Gen 1 species (default internal names: `NIDORAN_F`,
`NIDORAN_M`, `MR_MIME`, `FARFETCHD`, etc.) are listed at the top of
`main.lua`.

## Credits

The icon sprites used in this mod are from the **MiniDex** set,
created by **Chamber**, **Solo0993**, **Blue Emerald**, **Lake**,
**Neslug**, and **Pikachu25**. All credit for the original artwork goes to the
authors; this mod only converts/integrates the art into the
gen1recomp format and recolors the palette.
