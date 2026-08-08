# Unique Menu Icons

Gives every Gen 1 Pokemon its own unique party/menu icon instead of
the vanilla shared body-type icons (BALL, BIRD, BUG, FAIRY, GRASS,
HELIX, MON, QUADRUPED, SNAKE, WATER).

## Installation

Simply drag-and-drop the .zip file into the mods section of the gen1recomp launcher. Restart the game for color pallete changes to be effective.

## Color modes

Options > Mods > Unique Menu Icons > **"ICON COLOR MODE"** offers 3
choices:

| Mode | What you get | Mechanism |
| ---- | ------------- | --------- |
| **ORIGINAL** (default) | Unique silhouettes, colored by whichever display palette you have active in Options (OG, SGB, Advanced, Classic...), exactly like vanilla icons | 2-tone icon art (fill + outline), no patch, no palette override |
| **GBC RED** | Every icon in the same authentic Gen 2 red/white/black duotone, regardless of display palette | trueColor screen-zone patch (see below) |
| **UNIQUE COLORS** | Every icon in its own real, full color | trueColor screen-zone patch (see below) |

Switch modes and restart the game to apply (content registries freeze
after boot).

### Why ORIGINAL mode art only uses 3 tones (not 4-shade)

Party menu icons are hardware OBJs, and the game bakes them through
`OBP0` (`src/ui/PartyMenu.lua`): OBJ color 1 shows as DMG shade 0
(white/lightest), OBJ color 2 as shade 1, and OBJ color 3 as shade 3
(outline) -- **shade 2 is unreachable for an icon, ever**. Built-in
icons get this bake automatically; a mod's own image is authored
directly, with no bake, so if it uses shade 2 (grayscale value 85)
that pixel really does render in the active palette's shade-2 color
-- under the default `MEWMON` palette that's purple, which is why an
early version of this mod's ORIGINAL-mode art showed purple that no
vanilla icon ever would. ORIGINAL mode's art only uses shade 0 (255,
highlight), shade 1 (170, fill), and shade 3 (0, outline) -- the only
three tones a real icon OBJ can actually display.

### Why three separate art sets instead of one

The menu icon column always renders through a single shared,
hardcoded palette ("MEWMON", `src/ui/PartyMenu.lua`), no matter which
species is shown — and that same palette also colors the title screen
and Oak's intro speech. Earlier versions of this mod got Gen 2 colors
by overriding that palette directly, which meant the title screen and
intro turned red too as a side effect.

**GBC RED** and **UNIQUE COLORS** avoid that entirely by using the
same **trueColor zone** mechanism the engine's own trueColor
sprites/tilesets use (`src/render/PaletteFX.lua`):

```lua
function PaletteFX.markTrueColor(x, y, w, h)
```

This queues a rectangle, in screen pixel coordinates, that gets
re-blitted **unshaded** on top of the normal colorized frame — so
whatever's drawn there shows its literal color no matter which
display palette is active. Since `R.icons` (the mod content registry
for menu icons) has no `trueColor` field to opt into this directly,
the mod wraps `PartyMenu:draw()` — a real table method, so it's safely
monkey-patchable, unlike the private `drawIcon()` function it calls
internally — and, right after the original draw runs, marks a
trueColor rect for each party slot's icon at its known screen
position (`x = 8`, `y = PartyMenu.entryY(i) = (i-1)*16`, size 16x16).

**ORIGINAL never installs this patch at all** — it's the plain,
fully-vanilla-behaved option for players who don't want any palette
mechanism touched or bypassed, just the unique silhouettes.

**This patch is not part of the documented/official mod API** — no
schema field covers it, so there's no guarantee it keeps working
across future engine versions. It's the same category of technique
the community "Followers EX" mod uses elsewhere in this engine
(monkey-patching PartyMenu/BoxMenu/Screens methods). It's wrapped in
`pcall`, so if it fails for any reason, icon registration still works
fine — icons for GBC RED/UNIQUE COLORS modes would just render
through whatever display palette is active instead of showing true
color.

## What's included

- `manifest.json` — mod manifest (api 2).
- `main.lua` — defines the `ICON COLOR MODE` option, registers a
  unique icon for each of the 151 Gen 1 species from the selected
  mode's folder, and (for GBC RED / UNIQUE COLORS only) patches
  `PartyMenu:draw()` to mark each icon as a trueColor zone.
- `assets/icons_original/*.png` — 3-tone grayscale art (highlight + fill + outline).
- `assets/icons_gbc_red/*.png` — Gen 2 red/white/black duotone, literal RGB.
- `assets/icons_color/*.png` — full, real per-species color, literal RGB.

All three are 151 icons each, 16x32 (two 16x16 frames stacked for the
menu's bounce animation).

## Swapping in different art

Overwrite the species' file inside whichever mode's folder you're
using. For `icons_original`, keep to the 3 tones a real icon OBJ can
show: highlight pixels at `255`, fill pixels at `170`, and outline
pixels at `0` (see the note above on why) -- so the normal palette
recolor keeps working; `icons_gbc_red` and `icons_color` can use
literal color freely, since they render through the trueColor patch.

```
assets/icons_original/PIKACHU.png
assets/icons_color/CHARIZARD.png
```

No need to touch `main.lua` — the paths are already registered. If a
file is missing in the selected mode, the mod falls back to the
ORIGINAL mode's art for that species; if that's missing too, the
species just keeps its vanilla icon.

## Species list

All 151 Gen 1 species (standard internal names: `NIDORAN_F`,
`NIDORAN_M`, `MR_MIME`, `FARFETCHD`, etc.) are listed at the top of
`main.lua`.

## Credits

The icon sprites used in this mod are from the **MiniDex** set,
created by **Chamber**, **Solo0993**, **Blue Emerald**, **Lake**,
**Neslug**, and **Pikachu25**. All credit for the original art goes
to them; this mod only handles conversion/integration into
gen1recomp's format, the color variants, and the trueColor rendering
patch.