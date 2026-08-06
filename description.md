# Unique Menu Icons

Gives every Gen 1 Pokemon its own unique party/menu icon instead of the
vanilla shared body-type icons (BALL, BIRD, BUG, FAIRY, GRASS, HELIX, MON,
QUADRUPED, SNAKE, WATER).

## Color modes

Options > Mods > Unique Menu Icons > **"ICON COLOR MODE"** offers 3 choices:

| Mode | What you get | Mechanism |
| --- | --- | --- |
| **ORIGINAL** (default) | Unique silhouettes, colored by whichever display palette you have active in Options (OG, SGB, Advanced, Classic...), exactly like vanilla icons | 2-tone icon art (fill + outline), no patch, no palette override |
| **GBC RED** | Every icon in the same authentic Gen 2 red/white/black duotone, regardless of display palette | trueColor screen-zone patch |
| **UNIQUE COLORS** | Every icon in its own real, full color | trueColor screen-zone patch |

Switch modes and restart the game to apply (content registries freeze after
boot).

GBC RED and UNIQUE COLORS use the same trueColor zone mechanism the engine's
own trueColor sprites/tilesets use, instead of overriding the shared MEWMON
palette — so the title screen and Oak's intro are never affected. This patch
is not part of the documented/official mod API, so it may interact with
other mods that also touch `PartyMenu` rendering (e.g. DexNav, PC Grid UI).
Not compatible with Followers EX, since both mods do essentially the same
thing.

## Installation

Drag-and-drop the release `.zip` into the mods section of the gen1recomp
launcher. Restart the game for color palette changes to take effect.

## Credits

Icon art from the **MiniDex** set, created by Chamber, Solo0993, Blue
Emerald, Lake, Neslug, and Pikachu25. All credit for the original art goes
to them; this mod only handles conversion/integration into gen1recomp's
format, the color variants, and the trueColor rendering patch.
