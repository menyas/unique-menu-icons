-- mods/unique_menu_icons/main.lua
--
-- Icon art: MiniDex sprites by Chamber, Solo0993, Blue Emerald, Lake,
-- Neslug and Pikachu25. All credit for the original art goes to them.
--
-- Gives every Gen 1 species its own unique party/menu icon instead of
-- sharing the vanilla body-type icons (BALL, BIRD, BUG, FAIRY, GRASS,
-- HELIX, MON, QUADRUPED, SNAKE, WATER).
--
-- Three color variants, selectable in-game (Options > Mods > Unique
-- Menu Icons > "ICON COLOR MODE"):
--
--   1. ORIGINAL (default) -- 4-shade grayscale contract art, no
--      trueColor patch, no palette override. Icons are recolored by
--      whichever display palette is active in Options (OG, SGB,
--      Advanced, Classic, etc), exactly like vanilla icons. For
--      players who want the unique silhouettes but don't want their
--      chosen display palette touched or bypassed at all.
--
--   2. GBC RED -- every icon in the same authentic Gen 2 red/white/
--      black duotone (sampled from real Gen 2 icon art), via the
--      trueColor zone patch (see below) -- NOT via a MEWMON palette
--      override like earlier versions of this mod did, so the title
--      screen and Oak's intro speech are unaffected.
--
--   3. UNIQUE COLORS -- every icon in its own full, real color (also
--      via the trueColor zone patch).
--
-- HOW THE trueColor PATCH WORKS (modes 2 and 3 only): the icons
-- registry (R.icons in src/mods/Schemas.lua) has no trueColor field,
-- and the menu icon column always renders through a single shared,
-- hardcoded palette ("MEWMON", src/ui/PartyMenu.lua) that also colors
-- the title screen and Oak's intro speech -- so there is no clean way
-- to get accurate icon colors through the palette system itself.
-- Instead, this mod uses the same "trueColor zone" mechanism vanilla
-- trueColor sprites/tilesets use (src/render/PaletteFX.lua):
-- PaletteFX.markTrueColor(x, y, w, h) queues a screen rect (pixel
-- coordinates) that gets re-blitted UNSHADED on top of the normal
-- colorized pass at the end of the frame. We wrap PartyMenu:draw()
-- (a real table method, safely monkey-patchable -- unlike the private
-- local drawIcon() function it calls internally) and, right after the
-- original draw runs, mark a trueColor rect for each party slot's
-- icon at its known screen position: x=8, y=PartyMenu.entryY(i)=
-- (i-1)*16, size 16x16.
--
-- This patch is NOT part of the documented/official mod API -- no
-- schema field covers it, so there's no guarantee it keeps working
-- across future engine versions. It's the same category of technique
-- the community "Followers EX" mod uses elsewhere in this engine.
-- Wrapped in pcall so a failure here can't break icon registration --
-- worst case, icons just render through the normal palette instead of
-- true color. Mode 1 never installs this patch at all.

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

  -- Johto (#152-251). Registered the same way the original 151 always
  -- were: if the matching PNG isn't in assets/<mode>/ yet, the loop
  -- below just skips it and that species keeps whatever fallback icon
  -- the active overhaul mod already draws. No code changes needed once
  -- the art is dropped in -- same as how this mod's Gen 1 set grew
  -- species-by-species from the start.
  --
  -- Tested for icon-registry compatibility with three overhaul mods
  -- that add these species: Crystal 251, Kanto Ascendant, and Kanto
  -- Reforged. Ascendant and Reforged both leave the party-menu icon
  -- registry untouched for Johto species (Reforged's own README calls
  -- this out directly: new species "borrow Gen 1 menu icon classes"),
  -- so registering real art here for these names is a straightforward
  -- upgrade over their shared-silhouette fallback, exactly like it is
  -- for the original 151. Crystal 251 generates its own ROM-derived
  -- icons for its Day Care display specifically; this hasn't been
  -- cross-checked against its Day Care rendering path yet.
  "CHIKORITA", "BAYLEEF", "MEGANIUM",
  "CYNDAQUIL", "QUILAVA", "TYPHLOSION",
  "TOTODILE", "CROCONAW", "FERALIGATR",
  "SENTRET", "FURRET",
  "HOOTHOOT", "NOCTOWL",
  "LEDYBA", "LEDIAN",
  "SPINARAK", "ARIADOS",
  "CROBAT",
  "CHINCHOU", "LANTURN",
  "PICHU",
  "CLEFFA",
  "IGGLYBUFF",
  "TOGEPI", "TOGETIC",
  "NATU", "XATU",
  "MAREEP", "FLAAFFY", "AMPHAROS",
  "BELLOSSOM",
  "MARILL", "AZUMARILL",
  "SUDOWOODO",
  "POLITOED",
  "HOPPIP", "SKIPLOOM", "JUMPLUFF",
  "AIPOM",
  "SUNKERN", "SUNFLORA",
  "YANMA",
  "WOOPER", "QUAGSIRE",
  "ESPEON", "UMBREON",
  "MURKROW",
  "SLOWKING",
  "MISDREAVUS",
  "UNOWN",
  "WOBBUFFET",
  "GIRAFARIG",
  "PINECO", "FORRETRESS",
  "DUNSPARCE",
  "GLIGAR",
  "STEELIX",
  "SNUBBULL", "GRANBULL",
  "QWILFISH",
  "SCIZOR",
  "SHUCKLE",
  "HERACROSS",
  "SNEASEL",
  "TEDDIURSA", "URSARING",
  "SLUGMA", "MAGCARGO",
  "SWINUB", "PILOSWINE",
  "CORSOLA",
  "REMORAID", "OCTILLERY",
  "DELIBIRD",
  "MANTINE",
  "SKARMORY",
  "HOUNDOUR", "HOUNDOOM",
  "KINGDRA",
  "PHANPY", "DONPHAN",
  "PORYGON2",
  "STANTLER",
  "SMEARGLE",
  "TYROGUE", "HITMONTOP",
  "SMOOCHUM",
  "ELEKID",
  "MAGBY",
  "MILTANK",
  "BLISSEY",
  "RAIKOU", "ENTEI", "SUICUNE",
  "LARVITAR", "PUPITAR", "TYRANITAR",
  "LUGIA", "HO_OH",
  "CELEBI",
}

local MODES = {
  { id = "original",      label = "ORIGINAL (no palette changes)",     folder = "assets/icons_original" },
  { id = "gbc_red",        label = "GBC RED (Gen 2 style, all mons)",   folder = "assets/icons_gbc_red" },
  { id = "unique_colors",  label = "UNIQUE COLORS (real per-species)",  folder = "assets/icons_color" },
}
local DEFAULT_MODE = "original"

local function findMode(id)
  for _, m in ipairs(MODES) do
    if m.id == id then return m end
  end
  return nil
end

return function(mod)
  local choices = {}
  for _, m in ipairs(MODES) do
    choices[#choices + 1] = { m.label, m.id }
  end

  mod.options:define({
    {
      key = "icon_color_mode",
      label = "ICON COLOR MODE",
      type = "choice",
      default = DEFAULT_MODE,
      choices = choices,
    },
  })

  local modeId = mod.options:get("icon_color_mode")
  local mode = findMode(modeId) or findMode(DEFAULT_MODE)

  local registered, skipped = 0, 0
  local hasArt = {}

  for _, name in ipairs(SPECIES) do
    local iconPath = mode.folder .. "/" .. name .. ".png"

    -- Fall back to the default mode's art if the selected mode is
    -- somehow missing a file, so the mod never registers a broken path.
    if not mod:read(iconPath) then
      iconPath = findMode(DEFAULT_MODE).folder .. "/" .. name .. ".png"
    end

    if mod:read(iconPath) then
      -- Always override, never register: another mod (PokePCFollowers,
      -- Kanto Reforged, etc.) may register/patch this same species id.
      -- register() would collide with whatever another mod queues for
      -- this id at merge time -- see CHIKORITA/Kanto Reforged and
      -- BULBASAUR/PokePCFollowers reports. override() has no existence
      -- check, so it's safe unconditionally and always wins the merge.
      mod.content.icons:override(name, {
        image = mod.assets:path(iconPath),
        frames = 2,
      })
      registered = registered + 1
      hasArt[name] = true
    else
      skipped = skipped + 1
    end
  end

  -- Only modes 2 and 3 need the trueColor patch. Mode 1 relies on the
  -- normal palette-driven recolor, exactly like vanilla icons, and
  -- deliberately never touches PartyMenu or PaletteFX at all.
  local patchOk, patchErr = true, nil
  if mode.id ~= "original" then
    patchOk, patchErr = pcall(function()
      local PartyMenu = require("src.ui.PartyMenu")
      local PaletteFX = require("src.render.PaletteFX")

      if PartyMenu._uniqueMenuIconsTrueColorWrapped then return end

      local origDraw = PartyMenu.draw
      function PartyMenu:draw(...)
        origDraw(self, ...)

        local party = self.party or (self.game and self.game.save and self.game.save.party)
        if type(party) ~= "table" then return end

        for i, mon in ipairs(party) do
          if mon and hasArt[mon.species] then
            local y = PartyMenu.entryY(i)
            PaletteFX.markTrueColor(8, y, 16, 16)
          end
        end
      end

      PartyMenu._uniqueMenuIconsTrueColorWrapped = true
    end)

    if not patchOk then
      mod.log:warn("unique_menu_icons: trueColor icon patch failed: %s", tostring(patchErr))
    end
  end

  mod.log:info(
    "unique_menu_icons: mode=%s, registered %d unique icons (%d skipped), trueColor patch: %s",
    mode.id, registered, skipped, mode.id == "original" and "not needed" or tostring(patchOk)
  )
end
