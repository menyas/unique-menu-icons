-- mods/unique_menu_icons/main.lua
--
-- Icon art: MiniDex sprites by Chamber, Solo0993, Blue Emerald, Lake,
-- Neslug and Pikachu25. All credit for the original art goes to them.
--
-- Gives every Gen 1 species its own unique party/menu icon instead of
-- sharing the vanilla body-type icons (BALL, BIRD, BUG, FAIRY, GRASS,
-- HELIX, MON, QUADRUPED, SNAKE, WATER).
--
-- Each icon is a 16x32 PNG: two 16x16 frames stacked vertically for the
-- party-menu bounce animation (frame = { image, frames = 2 }). Icon art
-- follows the engine's 4-shade pixel contract (white/light/dark/black
-- grayscale) rather than literal RGB.
--
-- COLOR: icons and battle/Dex sprites are recolored via 9-10 shared
-- "monster palette" overrides (see INCLUDE_MEWMON and MONSTER_PALETTES
-- below for the full explanation, including a switch for the one
-- palette shared with the title screen and Oak's intro speech).
-- This palette is used by both the "SGB" and "ADVANCED" display
-- modes (they share the same underlying values, only the
-- species-to-palette-name assignment differs) -- OG/OG INV/CLASSIC
-- use an unrelated mechanism and are unaffected.

local SPECIES = {
  "BULBASAUR",
  "IVYSAUR",
  "VENUSAUR",
  "CHARMANDER",
  "CHARMELEON",
  "CHARIZARD",
  "SQUIRTLE",
  "WARTORTLE",
  "BLASTOISE",
  "CATERPIE",
  "METAPOD",
  "BUTTERFREE",
  "WEEDLE",
  "KAKUNA",
  "BEEDRILL",
  "PIDGEY",
  "PIDGEOTTO",
  "PIDGEOT",
  "RATTATA",
  "RATICATE",
  "SPEAROW",
  "FEAROW",
  "EKANS",
  "ARBOK",
  "PIKACHU",
  "RAICHU",
  "SANDSHREW",
  "SANDSLASH",
  "NIDORAN_F",
  "NIDORINA",
  "NIDOQUEEN",
  "NIDORAN_M",
  "NIDORINO",
  "NIDOKING",
  "CLEFAIRY",
  "CLEFABLE",
  "VULPIX",
  "NINETALES",
  "JIGGLYPUFF",
  "WIGGLYTUFF",
  "ZUBAT",
  "GOLBAT",
  "ODDISH",
  "GLOOM",
  "VILEPLUME",
  "PARAS",
  "PARASECT",
  "VENONAT",
  "VENOMOTH",
  "DIGLETT",
  "DUGTRIO",
  "MEOWTH",
  "PERSIAN",
  "PSYDUCK",
  "GOLDUCK",
  "MANKEY",
  "PRIMEAPE",
  "GROWLITHE",
  "ARCANINE",
  "POLIWAG",
  "POLIWHIRL",
  "POLIWRATH",
  "ABRA",
  "KADABRA",
  "ALAKAZAM",
  "MACHOP",
  "MACHOKE",
  "MACHAMP",
  "BELLSPROUT",
  "WEEPINBELL",
  "VICTREEBEL",
  "TENTACOOL",
  "TENTACRUEL",
  "GEODUDE",
  "GRAVELER",
  "GOLEM",
  "PONYTA",
  "RAPIDASH",
  "SLOWPOKE",
  "SLOWBRO",
  "MAGNEMITE",
  "MAGNETON",
  "FARFETCHD",
  "DODUO",
  "DODRIO",
  "SEEL",
  "DEWGONG",
  "GRIMER",
  "MUK",
  "SHELLDER",
  "CLOYSTER",
  "GASTLY",
  "HAUNTER",
  "GENGAR",
  "ONIX",
  "DROWZEE",
  "HYPNO",
  "KRABBY",
  "KINGLER",
  "VOLTORB",
  "ELECTRODE",
  "EXEGGCUTE",
  "EXEGGUTOR",
  "CUBONE",
  "MAROWAK",
  "HITMONLEE",
  "HITMONCHAN",
  "LICKITUNG",
  "KOFFING",
  "WEEZING",
  "RHYHORN",
  "RHYDON",
  "CHANSEY",
  "TANGELA",
  "KANGASKHAN",
  "HORSEA",
  "SEADRA",
  "GOLDEEN",
  "SEAKING",
  "STARYU",
  "STARMIE",
  "MR_MIME",
  "SCYTHER",
  "JYNX",
  "ELECTABUZZ",
  "MAGMAR",
  "PINSIR",
  "TAUROS",
  "MAGIKARP",
  "GYARADOS",
  "LAPRAS",
  "DITTO",
  "EEVEE",
  "VAPOREON",
  "JOLTEON",
  "FLAREON",
  "PORYGON",
  "OMANYTE",
  "OMASTAR",
  "KABUTO",
  "KABUTOPS",
  "AERODACTYL",
  "SNORLAX",
  "ARTICUNO",
  "ZAPDOS",
  "MOLTRES",
  "DRATINI",
  "DRAGONAIR",
  "DRAGONITE",
  "MEWTWO",
  "MEW",
}

-- 4 colors, lightest -> darkest. Edit these to taste.
local RED_YELLOW_PALETTE = {
  { 255, 255, 255 },  -- shade 0 (lightest / background)
  { 248, 152, 80 },   -- shade 1 (light fill)  -> Gen 2 light red/orange
  { 248, 56, 32 },     -- shade 2 (dark fill)   -> Gen 2 dark red
  { 0, 0, 0 },         -- shade 3 (darkest / outline)
}

-- The 10 shared "monster bucket" palettes (data/palettes_gbc.lua's `order`
-- list, right after the map/UI palettes and before per-species entries).
-- Every one of the 151 species is assigned to one of these 10 in the
-- Gen 1 SGB-style species->palette-name table this port actually uses
-- (the per-species Gen 2 table in the same file is present but unused
-- for that assignment -- see the comment above data/palettes_gbc.lua's
-- MEWMON entry). Overriding all 10 with the same colors makes every
-- species render identically, matching how real Gen 2 icons work (one
-- shared palette for the whole roster).
-- OPTION: include MEWMON in the override, or leave it at default?
--
-- MEWMON is shared by three things in this engine: the party menu's
-- icon column (src/ui/PartyMenu.lua, hardcoded), Mew's own species
-- palette, AND the title screen + Oak's intro speech
-- (src/ui/TitleState.lua, src/ui/OakSpeech.lua -- also hardcoded to
-- "MEWMON"). There's no way to override it for icons without also
-- recoloring the title screen and intro, since all three call sites
-- reference the exact same name with no way to distinguish context.
--
-- ON  -> menu icon column + Mew's own sprite get the Gen 2 red look,
--        but the title screen and Oak's intro speech are recolored
--        too (side effect).
-- OFF -> title screen and Oak's intro stay vanilla, but the menu
--        icon column and Mew's own sprite keep their default
--        (non-Gen-2) colors as the trade-off.
--
-- Either way, the other 9 shared species palettes (BLUEMON, REDMON,
-- CYANMON, PURPLEMON, BROWNMON, GREENMON, PINKMON, YELLOWMON,
-- GREYMON) are always recolored, so every species except the ones
-- that map to MEWMON (Mew, Mewtwo, Jynx) always gets the Gen 2 look
-- regardless of this option.
--
-- Exposed as an in-game toggle (Options > Mods > Unique Menu Icons)
-- via mod.options -- row shape confirmed against src/mods/Loader.lua
-- (define() just requires a string .key) and src/mods/ManagerState.lua
-- (OPTION_TYPES = {toggle, choice, number, text}; "toggle" is exactly
-- what a boolean on/off needs). Falls back to DEFAULT_INCLUDE_MEWMON
-- if options aren't available for any reason. Takes effect on restart
-- (content registries freeze after boot).
local DEFAULT_INCLUDE_MEWMON = true

local MONSTER_PALETTES_BASE = {
  "BLUEMON", "REDMON", "CYANMON", "PURPLEMON",
  "BROWNMON", "GREENMON", "PINKMON", "YELLOWMON", "GREYMON",
}

return function(mod)
  mod.options:define({
    {
      key = "include_mewmon",
      label = "GBC PALLETE ON/OFF (ALTERS INTRO AND SOME SPRITES)",
      type = "toggle",
      default = DEFAULT_INCLUDE_MEWMON,
    },
  })

  local includeMewmon = mod.options:get("include_mewmon")
  if includeMewmon == nil then includeMewmon = DEFAULT_INCLUDE_MEWMON end

  local MONSTER_PALETTES = {}
  for _, name in ipairs(MONSTER_PALETTES_BASE) do
    MONSTER_PALETTES[#MONSTER_PALETTES + 1] = name
  end
  if includeMewmon then
    table.insert(MONSTER_PALETTES, 1, "MEWMON")
  end

  local registered, skipped = 0, 0

  for _, name in ipairs(SPECIES) do
    local iconPath = "assets/icons/" .. name .. ".png"

    if mod:read(iconPath) then
      mod.content.icons:register(name, {
        image = mod.assets:path(iconPath),
        frames = 2,
      })
      registered = registered + 1
    else
      skipped = skipped + 1
    end
  end

  local paletteOk, paletteFailed = 0, {}
  for _, paletteName in ipairs(MONSTER_PALETTES) do
    local ok, err = pcall(function()
      mod.content.palettes:override(paletteName, RED_YELLOW_PALETTE)
    end)
    if ok then
      paletteOk = paletteOk + 1
    else
      paletteFailed[#paletteFailed + 1] = paletteName
      mod.log:warn("unique_menu_icons: failed to override palette '%s': %s", paletteName, tostring(err))
    end
  end

  -- ============================================================
  -- EXPERIMENTAL: ADVANCED mode fix.
  --
  -- ADVANCED (internal mode "redpp") does NOT read mod.content.palettes
  -- overrides at all. PaletteFX.pack() special-cases it to read from
  -- PaletteFX.gbcPack() instead of data.palettes -- and gbcPack() is
  -- just `require("data.palettes_gbc")`, cached in a module-local
  -- variable (src/render/PaletteFX.lua:272-277). That's a plain Lua
  -- require, not a mod-content registry, so there's no schema-validated
  -- way to override it.
  --
  -- What we CAN do: call require() on that same module ourselves.
  -- Lua caches modules process-wide (package.loaded), so this returns
  -- the exact same table PaletteFX.gbcPack() will (or already did)
  -- hand back -- and since Lua tables are references, mutating its
  -- .palettes[name] entries in place changes what every holder of that
  -- table sees, regardless of load order.
  --
  -- This reaches past the supported mod API into an internal module,
  -- so it's not guaranteed stable across engine versions and may not
  -- work at all if the mod sandbox restricts require() to mod-owned
  -- paths. Wrapped in pcall so a failure here can't break icon
  -- registration or the data.palettes overrides above.
  local advOk, advErr = pcall(function()
    local gbcPack = require("data.palettes_gbc")
    if type(gbcPack) == "table" and type(gbcPack.palettes) == "table" then
      for _, paletteName in ipairs(MONSTER_PALETTES) do
        if gbcPack.palettes[paletteName] then
          gbcPack.palettes[paletteName] = RED_YELLOW_PALETTE
        end
      end
      return true
    end
    error("data.palettes_gbc module shape unexpected (no .palettes table)")
  end)
  if advOk then
    mod.log:info("unique_menu_icons: ADVANCED mode palette pack patched in place")
  else
    mod.log:warn("unique_menu_icons: ADVANCED mode patch failed: %s", tostring(advErr))
  end

  mod.log:info(
    "unique_menu_icons: registered %d unique icons (%d skipped), %d/%d monster palettes overridden%s",
    registered, skipped, paletteOk, #MONSTER_PALETTES,
    (#paletteFailed > 0) and (" (failed: " .. table.concat(paletteFailed, ", ") .. ")") or ""
  )
end
