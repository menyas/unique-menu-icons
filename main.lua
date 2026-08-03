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
-- COLOR: only the "MEWMON" shared palette is overridden (to the
-- authentic Gen 2 red scheme, sampled from real Gen 2 icon art). All
-- other shared species palettes (BLUEMON, REDMON, CYANMON, PURPLEMON,
-- BROWNMON, GREENMON, PINKMON, YELLOWMON, GREYMON) are left at their
-- normal game values -- only Mew, Mewtwo, and Jynx (the species that
-- map to MEWMON) plus the menu icon column (hardcoded to MEWMON in
-- src/ui/PartyMenu.lua) get the Gen 2 red look. Every other species
-- keeps its normal in-game colors.
--
-- Side effect: MEWMON is also reused by the title screen
-- (src/ui/TitleState.lua) and Oak's intro speech (src/ui/OakSpeech.lua)
-- -- both hardcoded to "MEWMON" with no way to distinguish that from
-- the icon-column usage -- so those also turn red as a consequence.
--
-- Works in both display modes:
--   SGB      -> via mod.content.palettes:override("MEWMON", ...)
--   ADVANCED -> this mode reads PaletteFX.gbcPack() (a plain
--               require("data.palettes_gbc"), cached, unrelated to
--               mod.content.palettes) instead, so this mod also
--               requires that same module and mutates its MEWMON
--               entry in place -- Lua caches modules process-wide,
--               so this is the same table the engine reads. Not part
--               of the official mod API; wrapped in pcall so a
--               failure here can't break icon registration.
-- OG/OG INV/CLASSIC use an unrelated mechanism and are unaffected.
--
-- Exposed as an in-game toggle (Options > Mods > Unique Menu Icons ->
-- "GBC PALLETE ON/OFF (ALTERS INTRO AND SOME SPRITES)") so you can
-- turn this off without editing the file. Defaults to ON. Takes
-- effect on restart (content registries freeze after boot).

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

-- 4 colors, lightest -> darkest. Sampled from real Gen 2 icon art.
local RED_YELLOW_PALETTE = {
  { 255, 255, 255 },  -- shade 0 (lightest / background)
  { 248, 152, 80 },   -- shade 1 (light fill)  -> Gen 2 light red/orange
  { 248, 56, 32 },     -- shade 2 (dark fill)   -> Gen 2 dark red
  { 0, 0, 0 },         -- shade 3 (darkest / outline)
}

return function(mod)
  mod.options:define({
    {
      key = "gbc_palette_on",
      label = "GBC PALLETE ON/OFF (ALTERS INTRO AND SOME SPRITES)",
      type = "toggle",
      default = true,
    },
  })

  local gbcPaletteOn = mod.options:get("gbc_palette_on")
  if gbcPaletteOn == nil then gbcPaletteOn = true end

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

  local sgbOk, advOk = false, false

  if gbcPaletteOn then
    -- SGB mode: reads mod.content.palettes directly.
    local ok, sgbErr = pcall(function()
      mod.content.palettes:override("MEWMON", RED_YELLOW_PALETTE)
    end)
    sgbOk = ok
    if not ok then
      mod.log:warn("unique_menu_icons: failed to override MEWMON (SGB): %s", tostring(sgbErr))
    end

    -- ADVANCED mode: reads a separate, non-moddable pack loaded via a
    -- plain Lua require(), cached process-wide. Mutate that same table
    -- in place instead. Not part of the official mod API -- see the
    -- comment at the top of this file for details. Wrapped in pcall so
    -- a failure here can't break icon registration or the SGB override.
    local ok2, advErr = pcall(function()
      local gbcPack = require("data.palettes_gbc")
      if type(gbcPack) == "table" and type(gbcPack.palettes) == "table"
          and gbcPack.palettes["MEWMON"] then
        gbcPack.palettes["MEWMON"] = RED_YELLOW_PALETTE
        return true
      end
      error("data.palettes_gbc module shape unexpected (no .palettes.MEWMON)")
    end)
    advOk = ok2
    if not ok2 then
      mod.log:warn("unique_menu_icons: failed to patch MEWMON (ADVANCED): %s", tostring(advErr))
    end
  end

  mod.log:info(
    "unique_menu_icons: registered %d unique icons (%d skipped), gbc_palette_on=%s (SGB: %s, ADVANCED: %s)",
    registered, skipped, tostring(gbcPaletteOn), tostring(sgbOk), tostring(advOk)
  )
end
