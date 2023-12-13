local E, L, V, P, G = unpack(select(2, ...))
local B = E:GetModule("Bags")
local TT = E:GetModule("Tooltip")
local Skins = E:GetModule("Skins")
local Search = E.Libs.ItemSearch

local _G = _G
local type, ipairs, pairs, unpack, select, pcall = type, ipairs, pairs, unpack, select, pcall
local tinsert, tremove, twipe, tmaxn = tinsert, tremove, wipe, table.maxn
local floor, ceil = math.floor, math.ceil
local format, sub, gsub = string.format, string.sub, string.gsub

local BankFrameItemButton_Update = BankFrameItemButton_Update
local BankFrameItemButton_UpdateLocked = BankFrameItemButton_UpdateLocked
local CloseBag, CloseBackpack, CloseBankFrame = CloseBag, CloseBackpack, CloseBankFrame
local CooldownFrame_SetTimer = CooldownFrame_SetTimer
local InCombatLockdown = InCombatLockdown
local CreateFrame = CreateFrame
local DeleteCursorItem = DeleteCursorItem
local GameTooltip_Hide = GameTooltip_Hide
local GetBackpackCurrencyInfo = GetBackpackCurrencyInfo
local GetContainerItemCooldown = GetContainerItemCooldown
local GetContainerItemID = GetContainerItemID
local GetContainerItemInfo = GetContainerItemInfo
local GetContainerItemLink = GetContainerItemLink
local GetContainerItemQuestInfo = GetContainerItemQuestInfo
local GetContainerNumFreeSlots = GetContainerNumFreeSlots
local GetContainerNumSlots = GetContainerNumSlots
local GetCurrencyLink = GetCurrencyLink
local GetCurrentGuildBankTab = GetCurrentGuildBankTab
local GetCVarBool = GetCVarBool
local GetGuildBankItemLink = GetGuildBankItemLink
local GetGuildBankTabInfo = GetGuildBankTabInfo
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local GetMoney = GetMoney
local GetNumBankSlots = GetNumBankSlots
local GetScreenWidth, GetScreenHeight = GetScreenWidth, GetScreenHeight
local IsBagOpen, IsOptionFrameOpen = IsBagOpen, IsOptionFrameOpen
local IsModifiedClick = IsModifiedClick
local IsShiftKeyDown, IsControlKeyDown = IsShiftKeyDown, IsControlKeyDown
local MailFrame = MailFrame
local MerchantFrame = MerchantFrame
local PickupContainerItem = PickupContainerItem
local PlaySound = PlaySound
local PutItemInBackpack = PutItemInBackpack
local PutItemInBag = PutItemInBag
local SetItemButtonCount = SetItemButtonCount
local SetItemButtonDesaturated = SetItemButtonDesaturated
local SetItemButtonTexture = SetItemButtonTexture
local SetItemButtonTextureVertexColor = SetItemButtonTextureVertexColor
local ToggleFrame = ToggleFrame
local UseContainerItem = UseContainerItem

local BACKPACK_TOOLTIP = BACKPACK_TOOLTIP
local CONTAINER_OFFSET_X, CONTAINER_OFFSET_Y = CONTAINER_OFFSET_X, CONTAINER_OFFSET_Y
local CONTAINER_SCALE = CONTAINER_SCALE
local CONTAINER_SPACING, VISIBLE_CONTAINER_SPACING = CONTAINER_SPACING, VISIBLE_CONTAINER_SPACING
local CONTAINER_WIDTH = CONTAINER_WIDTH
local ITEM_ACCOUNTBOUND = ITEM_ACCOUNTBOUND
local ITEM_BIND_ON_EQUIP = ITEM_BIND_ON_EQUIP
local ITEM_BIND_ON_USE = ITEM_BIND_ON_USE
local ITEM_BNETACCOUNTBOUND = ITEM_BNETACCOUNTBOUND
local ITEM_SOULBOUND = ITEM_SOULBOUND
local MAX_CONTAINER_ITEMS = MAX_CONTAINER_ITEMS
local MAX_WATCHED_TOKENS = MAX_WATCHED_TOKENS
local NUM_BAG_FRAMES = NUM_BAG_FRAMES
local NUM_CONTAINER_FRAMES = NUM_CONTAINER_FRAMES
local SEARCH = SEARCH

local SEARCH_STRING = ""

Skulyitemcache = {
	[117] = "Tough Jerky",
	[159] = "Refreshing Spring Water",
	[200] = "Thick Cloth Vest",
	[201] = "Thick Cloth Pants",
	[202] = "Thick Cloth Shoes",
	[203] = "Thick Cloth Gloves",
	[236] = "Cured Leather Armor",
	[237] = "Cured Leather Pants",
	[238] = "Cured Leather Boots",
	[239] = "Cured Leather Gloves",
	[285] = "Scalemail Vest",
	[286] = "Scalemail Pants",
	[287] = "Scalemail Boots",
	[718] = "Scalemail Gloves",
	[765] = "Silverleaf",
	[774] = "Malachite",
	[787] = "Slitherskin Mackerel",
	[818] = "Tigerseye",
	[843] = "Tanned Leather Boots",
	[844] = "Tanned Leather Gloves",
	[845] = "Tanned Leather Pants",
	[846] = "Tanned Leather Jerkin",
	[847] = "Chainmail Armor",
	[848] = "Chainmail Pants",
	[849] = "Chainmail Boots",
	[850] = "Chainmail Gloves",
	[858] = "Lesser Healing Potion",
	[1179] = "Ice Cold Milk",
	[1181] = "Scroll of Spirit",
	[1202] = "Wall Shield",
	[1205] = "Melon Juice",
	[1210] = "Shadowgem",
	[1645] = "Moonberry Juice",
	[1708] = "Sweet Nectar",
	[1843] = "Tanned Leather Belt",
	[1844] = "Tanned Leather Bracers",
	[1845] = "Chainmail Belt",
	[1846] = "Chainmail Bracers",
	[1849] = "Cured Leather Belt",
	[1850] = "Cured Leather Bracers",
	[1852] = "Scalemail Bracers",
	[1853] = "Scalemail Belt",
	[2122] = "Cracked Leather Belt",
	[2148] = "Polished Scale Belt",
	[2149] = "Polished Scale Boots",
	[2150] = "Polished Scale Bracers",
	[2151] = "Polished Scale Gloves",
	[2152] = "Polished Scale Leggings",
	[2153] = "Polished Scale Vest",
	[2287] = "Haunch of Meat",
	[2320] = "Coarse Thread",
	[2321] = "Fine Thread",
	[2324] = "Bleach",
	[2325] = "Black Dye",
	[2370] = "Battered Leather Harness",
	[2371] = "Battered Leather Belt",
	[2372] = "Battered Leather Pants",
	[2373] = "Battered Leather Boots",
	[2374] = "Battered Leather Bracers",
	[2375] = "Battered Leather Gloves",
	[2376] = "Worn Heater Shield",
	[2387] = "Rusted Chain Belt",
	[2392] = "Light Mail Armor",
	[2393] = "Light Mail Belt",
	[2394] = "Light Mail Leggings",
	[2395] = "Light Mail Boots",
	[2396] = "Light Mail Bracers",
	[2397] = "Light Mail Gloves",
	[2398] = "Light Chain Armor",
	[2399] = "Light Chain Belt",
	[2400] = "Light Chain Leggings",
	[2401] = "Light Chain Boots",
	[2402] = "Light Chain Bracers",
	[2403] = "Light Chain Gloves",
	[2417] = "Augmented Chain Vest",
	[2418] = "Augmented Chain Leggings",
	[2419] = "Augmented Chain Belt",
	[2420] = "Augmented Chain Boots",
	[2421] = "Augmented Chain Bracers",
	[2422] = "Augmented Chain Gloves",
	[2423] = "Brigandine Vest",
	[2424] = "Brigandine Belt",
	[2425] = "Brigandine Leggings",
	[2426] = "Brigandine Boots",
	[2427] = "Brigandine Bracers",
	[2428] = "Brigandine Gloves",
	[2435] = "Embroidered Armor",
	[2437] = "Embroidered Pants",
	[2438] = "Embroidered Boots",
	[2440] = "Embroidered Gloves",
	[2446] = "Kite Shield",
	[2447] = "Peacebloom",
	[2448] = "Heavy Pavise",
	[2449] = "Earthroot",
	[2450] = "Briarthorn",
	[2451] = "Crested Heater Shield",
	[2452] = "Swiftthistle",
	[2459] = "Swiftness Potion",
	[2470] = "Reinforced Leather Vest",
	[2471] = "Reinforced Leather Belt",
	[2472] = "Reinforced Leather Pants",
	[2473] = "Reinforced Leather Boots",
	[2474] = "Reinforced Leather Bracers",
	[2475] = "Reinforced Leather Gloves",
	[2489] = "Two-Handed Sword",
	[2491] = "Large Axe",
	[2493] = "Wooden Mallet",
	[2495] = "Walking Stick",
	[2520] = "Broadsword",
	[2521] = "Flamberge",
	[2522] = "Crescent Axe",
	[2523] = "Bullova",
	[2524] = "Truncheon",
	[2525] = "War Hammer",
	[2526] = "Main Gauche",
	[2527] = "Battle Staff",
	[2555] = "Recipe: Swiftness Potion",
	[2572] = "Red Linen Robe",
	[2589] = "Linen Cloth",
	[2592] = "Wool Cloth",
	[2593] = "Flask of Port",
	[2594] = "Flagon of Mead",
	[2595] = "Jug of Bourbon",
	[2596] = "Skin of Dwarven Stout",
	[2598] = "Pattern: Red Linen Robe",
	[2604] = "Red Dye",
	[2605] = "Green Dye",
	[2678] = "Mild Spices",
	[2723] = "Bottle of Pinot Noir",
	[2880] = "Weak Flux",
	[2892] = "Deadly Poison",
	[2901] = "Mining Pick",
	[2957] = "Journeyman's Vest",
	[2996] = "Bolt of Linen Cloth",
	[3026] = "Reinforced Bow",
	[3027] = "Heavy Recurve Bow",
	[3371] = "Crystal Vial",
	[3419] = "Red Rose",
	[3420] = "Black Rose",
	[3421] = "Simple Wildflowers",
	[3422] = "Beautiful Wildflowers",
	[3423] = "Bouquet of White Roses",
	[3424] = "Bouquet of Black Roses",
	[3466] = "Strong Flux",
	[3587] = "Embroidered Belt",
	[3588] = "Embroidered Bracers",
	[3597] = "Thick Cloth Belt",
	[3598] = "Thick Cloth Bracers",
	[3602] = "Knitted Belt",
	[3644] = "Barbaric Cloth Bracers",
	[3770] = "Mutton Chop",
	[3771] = "Wild Hog Shank",
	[3775] = "Crippling Poison",
	[3857] = "Coal",
	[3891] = "Augmented Chain Helm",
	[3892] = "Embroidered Hat",
	[3893] = "Reinforced Leather Cap",
	[3894] = "Brigandine Helm",
	[4289] = "Salt",
	[4291] = "Silken Thread",
	[4340] = "Gray Dye",
	[4341] = "Yellow Dye",
	[4342] = "Purple Dye",
	[4357] = "Rough Blasting Powder",
	[4361] = "Bent Copper Tube",
	[4364] = "Coarse Blasting Powder",
	[4371] = "Bronze Tube",
	[4382] = "Bronze Framework",
	[4389] = "Gyrochronatom",
	[4399] = "Wooden Stock",
	[4400] = "Heavy Stock",
	[4404] = "Silver Contact",
	[4470] = "Simple Wood",
	[4496] = "Small Brown Pouch",
	[4497] = "Heavy Brown Bag",
	[4498] = "Brown Leather Satchel",
	[4499] = "Huge Brown Sack",
	[4536] = "Shiny Red Apple",
	[4537] = "Tel'Abim Banana",
	[4538] = "Snapvine Watermelon",
	[4539] = "Goldenbark Apple",
	[4540] = "Tough Hunk of Bread",
	[4541] = "Freshly Baked Bread",
	[4542] = "Moist Cornbread",
	[4544] = "Mulgore Spice Bread",
	[4560] = "Fine Scimitar",
	[4570] = "Birchwood Maul",
	[4592] = "Longjaw Mud Snapper",
	[4593] = "Bristle Whisker Catfish",
	[4594] = "Rockscale Cod",
	[4599] = "Cured Ham Steak",
	[4601] = "Soft Banana Bread",
	[4602] = "Moon Harvest Pumpkin",
	[5069] = "Fire Wand",
	[5232] = "Soulstone",
	[5237] = "Mind-Numbing Poison",
	[5243] = "Firebelcher",
	[5512] = "Healthstone",
	[5635] = "Sharp Claw",
	[5642] = "Recipe: Free Action Potion",
	[5772] = "Pattern: Red Woolen Bag",
	[5956] = "Blacksmith Hammer",
	[6047] = "Plans: Golden Scale Coif",
	[6217] = "Copper Rod",
	[6256] = "Fishing Pole",
	[6260] = "Blue Dye",
	[6261] = "Orange Dye",
	[6270] = "Pattern: Blue Linen Vest",
	[6274] = "Pattern: Blue Overalls",
	[6367] = "Big Iron Fishing Pole",
	[6461] = "Slime-Encrusted Pads",
	[6523] = "Buckled Harness",
	[6524] = "Studded Leather Harness",
	[6525] = "Grunt's Harness",
	[6526] = "Battle Harness",
	[6529] = "Shiny Bauble",
	[6530] = "Nightcrawlers",
	[6532] = "Bright Baubles",
	[6555] = "Bard's Cloak",
	[6631] = "Living Root",
	[6947] = "Instant Poison",
	[6948] = "Hearthstone",
	[7005] = "Skinning Knife",
	[7111] = "Nightsky Armor",
	[7228] = "Tigule and Foror's Strawberry Ice Cream",
	[7683] = "Bloody Brass Knuckles",
	[7685] = "Orb of the Forgotten Seer",
	[7713] = "Illusionary Rod",
	[8088] = "Platemail Belt",
	[8089] = "Platemail Boots",
	[8090] = "Platemail Bracers",
	[8091] = "Platemail Gloves",
	[8092] = "Platemail Helm",
	[8093] = "Platemail Leggings",
	[8094] = "Platemail Armor",
	[8164] = "Test Stationery",
	[8343] = "Heavy Silken Thread",
	[8766] = "Morning Glory Dew",
	[8836] = "Arthas' Tears",
	[8950] = "Homemade Cherry Pie",
	[8952] = "Roasted Quail",
	[8953] = "Deep Fried Plantains",
	[8957] = "Spinefin Halibut",
	[9260] = "Volatile Rum",
	[9311] = "Default Stationery",
	[9411] = "Rockshard Pauldrons",
	[9492] = "Electromagnetic Gigaflux Reactivator",
	[9743] = "Simple Shoes",
	[10290] = "Pink Dye",
	[10314] = "Pattern: Lavender Mageweave Shirt",
	[10317] = "Pattern: Pink Mageweave Shirt",
	[10647] = "Engineer's Ink",
	[10648] = "Common Parchment",
	[10777] = "Arachnid Gloves",
	[10837] = "Tooth of Eranikus",
	[10918] = "Wound Poison",
	[10938] = "Lesser Magic Essence",
	[10939] = "Greater Magic Essence",
	[10940] = "Strange Dust",
	[10978] = "Small Glimmering Shard",
	[10998] = "Lesser Astral Essence",
	[11082] = "Greater Astral Essence",
	[11083] = "Soul Dust",
	[11084] = "Large Glimmering Shard",
	[11134] = "Lesser Mystic Essence",
	[11135] = "Greater Mystic Essence",
	[11137] = "Vision Dust",
	[11138] = "Small Glowing Shard",
	[11139] = "Large Glowing Shard",
	[11174] = "Lesser Nether Essence",
	[11175] = "Greater Nether Essence",
	[11176] = "Dream Dust",
	[11177] = "Small Radiant Shard",
	[11178] = "Large Radiant Shard",
	[11311] = "Emberscale Cape",
	[11987] = "Iridium Circle",
	[12162] = "Plans: Hardened Iron Shortsword",
	[12250] = "Midnight Axe",
	[12251] = "Big Stick",
	[12410] = "Thorium Helm",
	[12662] = "Demonic Rune",
	[13478] = "Recipe: Elixir of Superior Defense",
	[14099] = "Native Sash",
	[14341] = "Rune Thread",
	[14343] = "Small Brilliant Shard",
	[14344] = "Large Brilliant Shard",
	[14364] = "Mystic's Slippers",
	[14468] = "Pattern: Runecloth Bag",
	[14526] = "Pattern: Mooncloth",
	[15215] = "Furious Falchion",
	[15740] = "Pattern: Frostsaber Boots",
	[15945] = "Runic Stave",
	[16202] = "Lesser Eternal Essence",
	[16203] = "Greater Eternal Essence",
	[16204] = "Illusion Dust",
	[16217] = "Formula: Enchant Shield - Greater Stamina",
	[16221] = "Formula: Enchant Chest - Major Health",
	[17020] = "Arcane Powder",
	[17030] = "Ankh",
	[17031] = "Rune of Teleportation",
	[17032] = "Rune of Portals",
	[17034] = "Maple Seed",
	[17185] = "Round Buckler",
	[17187] = "Banded Buckler",
	[17189] = "Metal Buckler",
	[17190] = "Ornate Buckler",
	[17192] = "Reinforced Targe",
	[18154] = "Blizzard Stationery",
	[18567] = "Elemental Flux",
	[18727] = "Crimson Felt Hat",
	[18730] = "Shadowy Laced Handwraps",
	[18731] = "Pattern: Heavy Leather Ball",
	[20243] = "Highlander's Runecloth Bandage",
	[20725] = "Nexus Crystal",
	[20815] = "Jeweler's Kit",
	[20824] = "Simple Grinder",
	[21099] = "Recipe: Smoked Sagefish",
	[21140] = "Auction Stationery",
	[21219] = "Recipe: Sagefish Delight",
	[21322] = "Ursa's Embrace",
	[21383] = "Winterfall Spirit Beads",
	[21552] = "Striped Yellowtail",
	[21957] = "Design: Necklace of the Diamond Tower",
	[22058] = "Valentine's Day Stationery",
	[22250] = "Herb Pouch",
	[22412] = "Thuzadin Mantle",
	[22445] = "Arcane Dust",
	[22446] = "Greater Planar Essence",
	[22447] = "Lesser Planar Essence",
	[22448] = "Small Prismatic Shard",
	[22449] = "Large Prismatic Shard",
	[22450] = "Void Crystal",
	[22460] = "Prismatic Sphere",
	[22572] = "Mote of Air",
	[22917] = "Recipe: Transmute Primal Fire to Earth",
	[22918] = "Recipe: Transmute Primal Water to Air",
	[22922] = "Recipe: Major Nature Protection Potion",
	[23094] = "Brilliant Blood Garnet",
	[23099] = "Reckless Flame Spessarite",
	[23100] = "Glinting Shadow Draenite",
	[23104] = "Jagged Deep Peridot",
	[23114] = "Smooth Golden Draenite",
	[23118] = "Solid Azure Moonstone",
	[23572] = "Primal Nether",
	[23590] = "Plans: Adamantite Maul",
	[23591] = "Plans: Adamantite Cleaver",
	[23592] = "Plans: Adamantite Dagger",
	[23593] = "Plans: Adamantite Rapier",
	[23618] = "Plans: Adamantite Sharpening Stone",
	[23811] = "Schematic: White Smoke Flare",
	[23814] = "Schematic: Green Smoke Flare",
	[23816] = "Schematic: Fel Iron Toolbox",
	[24000] = "Formula: Enchant Bracer - Superior Healing",
	[24001] = "Recipe: Elixir of Major Agility",
	[24002] = "Plans: Felsteel Shield Spike",
	[24003] = "Formula: Enchant Chest - Exceptional Stats",
	[24004] = "Thrallmar Tabard",
	[24006] = "Grunt's Waterskin",
	[24009] = "Dried Fruit Rations",
	[24183] = "Design: Nightseye Panther",
	[24429] = "Expedition Flare",
	[25475] = "Blue Wind Rider",
	[25511] = "Thunderforge Leggings",
	[25526] = "Plans: Greater Rune of Warding",
	[25735] = "Pattern: Heavy Clefthoof Vest",
	[25736] = "Pattern: Heavy Clefthoof Leggings",
	[25737] = "Pattern: Heavy Clefthoof Boots",
	[25738] = "Pattern: Felstalker Belt",
	[25739] = "Pattern: Felstalker Bracers",
	[25740] = "Pattern: Felstalker Breastplate",
	[25741] = "Pattern: Netherfury Belt",
	[25742] = "Pattern: Netherfury Leggings",
	[25743] = "Pattern: Netherfury Boots",
	[25823] = "Grunt's Waraxe",
	[25824] = "Farseer's Band",
	[25835] = "Explorer's Walking Stick",
	[25836] = "Preserver's Cudgel",
	[25838] = "Warden's Hauberk",
	[25846] = "Plans: Adamantite Rod",
	[25861] = "Crude Throwing Axe",
	[25869] = "Recipe: Transmute Earthstorm Diamond",
	[25897] = "Bracing Earthstorm Diamond",
	[27717] = "Expedition Forager Leggings",
	[27854] = "Smoked Talbuk Venison",
	[27855] = "Mag'har Grainbread",
	[27856] = "Skethyl Berries",
	[27858] = "Sunspring Carp",
	[27860] = "Purified Draenic Water",
	[28271] = "Formula: Enchant Gloves - Precise Strikes",
	[28399] = "Filtered Draenic Water",
	[28458] = "Bold Tourmaline",
	[28459] = "Delicate Tourmaline",
	[28461] = "Brilliant Tourmaline",
	[28463] = "Solid Zircon",
	[28464] = "Sparkling Zircon",
	[28467] = "Smooth Amber",
	[28468] = "Rigid Zircon",
	[28470] = "Subtle Amber",
	[28632] = "Plans: Adamantite Weightstone",
	[29102] = "Reins of the Cobalt War Talbuk",
	[29103] = "Reins of the White War Talbuk",
	[29104] = "Reins of the Silver War Talbuk",
	[29105] = "Reins of the Tan War Talbuk",
	[29108] = "Blade of the Unyielding",
	[29135] = "Earthcaller's Headdress",
	[29137] = "Hellscream's Will",
	[29139] = "Ceremonial Cover",
	[29141] = "Tempest Leggings",
	[29145] = "Band of Ancestral Spirits",
	[29147] = "Talbuk Hide Spaulders",
	[29152] = "Marksman's Bow",
	[29155] = "Stormcaller",
	[29165] = "Warbringer",
	[29167] = "Blackened Spear",
	[29168] = "Ancestral Band",
	[29170] = "Windcaller's Orb",
	[29171] = "Earthwarden",
	[29172] = "Ashyen's Gift",
	[29173] = "Strength of the Untamed",
	[29174] = "Watcher's Cowl",
	[29190] = "Arcanum of Renewal",
	[29192] = "Arcanum of Ferocity",
	[29194] = "Arcanum of Nature Warding",
	[29197] = "Arcanum of Fire Warding",
	[29232] = "Recipe: Transmute Skyfire Diamond",
	[29266] = "Azure-Shield of Coldarra",
	[29267] = "Light-Bearer's Faith Shield",
	[29268] = "Mazthoril Honor Shield",
	[29269] = "Sapphiron's Wing Bone",
	[29270] = "Flametongue Seal",
	[29271] = "Talisman of Kalecgos",
	[29272] = "Orb of the Soul-Eater",
	[29273] = "Khadgar's Knapsack",
	[29274] = "Tears of Heaven",
	[29275] = "Searing Sunblade",
	[29367] = "Ring of Cryptic Dreams",
	[29368] = "Manasurge Pendant",
	[29369] = "Shawl of Shifting Probabilities",
	[29370] = "Icon of the Silver Crescent",
	[29373] = "Band of Halos",
	[29374] = "Necklace of Eternal Hope",
	[29375] = "Bishop's Cloak",
	[29376] = "Essence of the Martyr",
	[29379] = "Ring of Arathi Warlords",
	[29381] = "Choker of Vile Intent",
	[29382] = "Blood Knight War Cloak",
	[29383] = "Bloodlust Brooch",
	[29384] = "Ring of Unyielding Force",
	[29385] = "Farstrider Defender's Cloak",
	[29386] = "Necklace of the Juggernaut",
	[29387] = "Gnomeregan Auto-Dodger 600",
	[29451] = "Clefthoof Ribs",
	[29664] = "Pattern: Reinforced Mining Bag",
	[29720] = "Pattern: Clefthide Leg Armor",
	[29721] = "Pattern: Nethercleft Leg Armor",
	[29914] = "Hellfire Skiver",
	[29915] = "Desolation Rod",
	[29916] = "Ironstar Repeater",
	[29935] = "Fire Scarred Breastplate",
	[29936] = "Skyfire Greaves",
	[29944] = "Protectorate Breastplate",
	[29945] = "Magistrate's Greaves",
	[30183] = "Nether Vortex",
	[30744] = "Draenic Leather Pack",
	[30745] = "Heavy Toolbox",
	[30746] = "Mining Sack",
	[30747] = "Gem Pouch",
	[30748] = "Enchanter's Satchel",
	[30749] = "Draenic Sparring Blade",
	[30750] = "Draenic Warblade",
	[30751] = "Mag'hari Light Axe",
	[30752] = "Mag'hari Battleaxe",
	[30753] = "Warphorn Spear",
	[30754] = "Ancient Bone Mace",
	[30755] = "Mag'hari Fighting Claw",
	[30761] = "Infernoweave Leggings",
	[30762] = "Infernoweave Robe",
	[30763] = "Infernoweave Boots",
	[30764] = "Infernoweave Gloves",
	[30766] = "Inferno Tempered Leggings",
	[30767] = "Inferno Tempered Gauntlets",
	[30768] = "Inferno Tempered Boots",
	[30769] = "Inferno Tempered Chestguard",
	[30770] = "Inferno Forged Boots",
	[30772] = "Inferno Forged Leggings",
	[30773] = "Inferno Forged Hauberk",
	[30774] = "Inferno Forged Gloves",
	[30776] = "Inferno Hardened Chestguard",
	[30778] = "Inferno Hardened Leggings",
	[30779] = "Inferno Hardened Boots",
	[30780] = "Inferno Hardened Gloves",
	[30817] = "Simple Flour",
	[31356] = "Recipe: Flask of Distilled Wisdom",
	[31358] = "Design: Dawnstone Crab",
	[31359] = "Design: Regal Deep Peridot",
	[31361] = "Pattern: Cobrahide Leg Armor",
	[31362] = "Pattern: Nethercobra Leg Armor",
	[31390] = "Plans: Wildguard Breastplate",
	[31391] = "Plans: Wildguard Leggings",
	[31392] = "Plans: Wildguard Helm",
	[31402] = "Design: The Natural Ward",
	[31773] = "Mag'har Tabard",
	[31804] = "Cenarion Expedition Tabard",
	[31829] = "Reins of the Cobalt Riding Talbuk",
	[31831] = "Reins of the Silver Riding Talbuk",
	[31833] = "Reins of the Tan Riding Talbuk",
	[31835] = "Reins of the White Riding Talbuk",
	[32070] = "Recipe: Earthen Elixir",
	[32083] = "Faceguard of Determination",
	[32084] = "Helmet of the Steadfast Champion",
	[32085] = "Warpstalker Helm",
	[32086] = "Storm Master's Helmet",
	[32087] = "Mask of the Deceiver",
	[32088] = "Cowl of Beastly Rage",
	[32089] = "Mana-Binders Cowl",
	[32090] = "Cowl of Naaru Blessings",
	[33149] = "Formula: Enchant Cloak - Stealth",
	[33151] = "Formula: Enchant Cloak - Subtlety",
	[33192] = "Carved Witch Doctor's Stick",
	[33207] = "Implacable Guardian Sabatons",
	[33222] = "Nyn'jah's Tabi Boots",
	[33257] = "Scaled Marshwalkers",
	[33279] = "Iron-Tusk Girdle",
	[33280] = "War-Feathered Loop",
	[33287] = "Gnarled Ironwood Pauldrons",
	[33291] = "Voodoo-Woven Belt",
	[33296] = "Brooch of Deftness",
	[33304] = "Cloak of Subjugated Power",
	[33324] = "Treads of the Life Path",
	[33325] = "Voodoo Shaker",
	[33331] = "Chain of Unleashed Rage",
	[33333] = "Kharmaa's Shroud of Hope",
	[33334] = "Fetish of the Primal Gods",
	[33386] = "Man'kin'do's Belt",
	[33444] = "Pungent Seal Whey",
	[33445] = "Honeymint Tea",
	[33449] = "Crusty Flatbread",
	[33451] = "Fillet of Icefin",
	[33454] = "Salted Venison",
	[33470] = "Frostweave Cloth",
	[33484] = "Dory's Embrace",
	[33501] = "Bloodthirster's Wargreaves",
	[33512] = "Furious Deathgrips",
	[33513] = "Eternium Rage-Shackles",
	[33514] = "Pauldrons of Gruesome Fate",
	[33515] = "Unwavering Legguards",
	[33516] = "Bracers of the Ancient Phalanx",
	[33517] = "Bonefist Gauntlets",
	[33518] = "High Justicar's Legplates",
	[33519] = "Handguards of the Templar",
	[33520] = "Vambraces of the Naaru",
	[33522] = "Chestguard of the Stoic Guardian",
	[33523] = "Sabatons of the Righteous Defender",
	[33524] = "Girdle of the Protector",
	[33527] = "Shifting Camouflage Pants",
	[33528] = "Gauntlets of Sniping",
	[33529] = "Steadying Bracers",
	[33530] = "Natural Life Leggings",
	[33531] = "Polished Waterscale Gloves",
	[33532] = "Gleaming Earthen Bracers",
	[33534] = "Grips of Nature's Wrath",
	[33535] = "Earthquake Bracers",
	[33536] = "Stormwrap",
	[33537] = "Treads of Booming Thunder",
	[33538] = "Shallow-Grave Trousers",
	[33539] = "Trickster's Stickyfingers",
	[33540] = "Master Assassin Wristwraps",
	[33552] = "Pants of Splendid Recovery",
	[33557] = "Gargon's Bracers of Peaceful Slumber",
	[33559] = "Starfire Waistband",
	[33566] = "Blessed Elunite Coverings",
	[33577] = "Moon-Walkers",
	[33578] = "Armwraps of the Kaldorei Protector",
	[33579] = "Vestments of Hibernation",
	[33580] = "Band of the Swift Paw",
	[33582] = "Footwraps of Wild Encroachment",
	[33583] = "Waistguard of the Great Beast",
	[33584] = "Pantaloons of Arcane Annihilation",
	[33585] = "Achromic Trousers of the Naaru",
	[33586] = "Studious Wraps",
	[33587] = "Light-Blessed Bonds",
	[33588] = "Runed Spell-Cuffs",
	[33589] = "Wristguards of Tranquil Thought",
	[33593] = "Slikk's Cloak of Placation",
	[33810] = "Amani Mask of Death",
	[33832] = "Battlemaster's Determination",
	[33965] = "Hauberk of the Furious Elements",
	[33970] = "Pauldrons of the Furious Elements",
	[33972] = "Mask of Primal Power",
	[33973] = "Pauldrons of Tribal Fury",
	[33974] = "Grasp of the Moonkin",
	[33999] = "Cenarion War Hippogryph",
	[34049] = "Battlemaster's Audacity",
	[34050] = "Battlemaster's Perseverance",
	[34052] = "Dream Shard",
	[34053] = "Small Dream Shard",
	[34054] = "Infinite Dust",
	[34055] = "Greater Cosmic Essence",
	[34056] = "Lesser Cosmic Essence",
	[34057] = "Abyss Crystal",
	[34162] = "Battlemaster's Depravity",
	[34163] = "Battlemaster's Cruelty",
	[34171] = "Winter Stationery",
	[34172] = "Pattern: Drums of Speed",
	[34174] = "Pattern: Drums of Restoration",
	[35321] = "Cloak of Arcane Alacrity",
	[35324] = "Cloak of Swift Reprieve",
	[35326] = "Battlemaster's Alacrity",
	[35377] = "Stalker's Chain Gauntlets",
	[35379] = "Stalker's Chain Leggings",
	[35948] = "Savory Snowplum",
	[35949] = "Tundra Berries",
	[35950] = "Sweet Potato Bread",
	[35951] = "Poached Emperor Salmon",
	[35953] = "Mead Basted Caribou",
	[36799] = "Mana Gem",
	[36883] = "Combatant Greatsword",
	[37705] = "Crystallized Water",
	[37915] = "Pattern: Dress Shoes",
	[38327] = "Pattern: Haliscan Jacket",
	[38328] = "Pattern: Haliscan Pantaloons",
	[38426] = "Eternium Thread",
	[39354] = "Light Parchment",
	[39505] = "Virtuoso Inking Set",
	[39684] = "Hair Trigger",
	[40035] = "Honey Mead",
	[40036] = "Snowplum Brandy",
	[40042] = "Caraway Burnwine",
	[40533] = "Walnut Stock",
	[41377] = "Shielded Skyflare Diamond",
	[41401] = "Insightful Earthsiege Diamond",
	[42253] = "Iceweb Spider Silk",
	[43656] = "Tome of Kings",
	[44570] = "Glass of Eversong Wine",
	[44571] = "Bottle of Silvermoon Port",
	[44573] = "Cup of Frog Venom Brew",
	[44574] = "Skin of Mulgore Firewater",
	[44575] = "Flask of Bitter Cactus Cider",
	[44654] = "Dalaran Spear",
	[45582] = "Darkspear Tabard",
	[46810] = "Bountiful Cookbook",
	[46830] = "Save the Orphans Action Alert",
	[49241] = "Waterlogged Cloth Vest",
	[49242] = "Waterlogged Cloth Belt",
	[49243] = "Waterlogged Cloth Pants",
	[49244] = "Waterlogged Cloth Boots",
	[49245] = "Waterlogged Cloth Bracers",
	[49246] = "Waterlogged Cloth Gloves",
	[49247] = "Drenched Leather Belt",
	[49248] = "Drenched Leather Boots",
	[49249] = "Drenched Leather Bracers",
	[49250] = "Drenched Leather Gloves",
	[49251] = "Drenched Leather Pants",
	[49252] = "Drenched Leather Vest",
	[49253] = "Slightly Worm-Eaten Hardtack",
	[49254] = "Tarp Collected Dew",
	[49257] = "Seashell Throwing Axe",
	[49258] = "Light Throwing Tusk",
	[49259] = "Salvaged Chain Armor",
	[49260] = "Salvaged Chain Belt",
	[49261] = "Salvaged Chain Boots",
	[49262] = "Salvaged Chain Bracers",
	[49263] = "Salvaged Chain Gloves",
	[49264] = "Salvaged Chain Leggings",
	[49265] = "Recovered Knit Belt",
	[49266] = "Recovered Knit Boots",
	[49267] = "Recovered Knit Bracers",
	[49268] = "Recovered Knit Gloves",
	[49269] = "Recovered Knit Pants",
	[49270] = "Recovered Knit Vest",
	[49271] = "Water-Stained Leather Belt",
	[49272] = "Water-Stained Leather Boots",
	[49273] = "Water-Stained Leather Bracers",
	[49274] = "Water-Stained Leather Gloves",
	[49275] = "Water-Stained Leather Harness",
	[49276] = "Water-Stained Leather Pants",
	[49600] = "Goblin Shortbread",
	[49601] = "Volcanic Spring Water",
	[51967] = "Enumerated Sandals",
	[51972] = "Enumerated Bracers",
	[51973] = "Enumerated Handwraps",
	[51976] = "Earthbound Shoulderguards",
	[51994] = "Tumultuous Cloak",
	[51995] = "Turbulent Necklace",
	[51996] = "Tumultuous Necklace",
	[51999] = "Satchel of Helpful Goods",
	[52196] = "Chimera's Eye",
	[52552] = "Primal Boots",
	[52555] = "Hypnotic Dust",
	[52679] = "Acolyte's Pants",
	[52718] = "Lesser Celestial Essence",
	[52719] = "Greater Celestial Essence",
	[52720] = "Small Heavenly Shard",
	[52721] = "Heavenly Shard",
	[52722] = "Maelstrom Crystal",
	[52908] = "Hatchling Handlers",
	[52915] = "Aggra's Sash",
	[52917] = "Gallywix Laborer's Gloves",
	[52918] = "Delicia's Tights",
	[52919] = "Oxidizing Axe",
	[52927] = "Victor's Robes",
	[52928] = "Banana Holder",
	[52929] = "Kilag's Vest",
	[52931] = "Orcish Scout Boots",
	[52932] = "Parachute Wrist Straps",
	[52934] = "Pygmy Cloak",
	[52936] = "S.B.R.B. Prototype 3",
	[52938] = "Jealousy's Edge",
	[52939] = "Cage-Launcher's Mail",
	[52940] = "Candy's Cloak",
	[52946] = "Spy Strangler Gloves",
	[52951] = "Chicken Chopper",
	[52959] = "Oystein Bracers",
	[52960] = "Silver Platter",
	[52961] = "Gnomish Parachute Scrap",
	[52962] = "Greely's Spare Dagger",
	[52967] = "Oil-Stained Leggings",
	[52969] = "Heartache Dagger",
	[52971] = "Igneous Leggings",
	[52972] = "Ex-Stealer's Gloves",
	[52980] = "Pristine Hide",
	[53239] = "Holgom's Bracers",
	[53248] = "Raptor Scrap Cloak",
	[53559] = "White Bone Rod",
	[53563] = "Stegodon Tusk Mace",
	[53569] = "Confiscated Poacher's Gun",
	[53588] = "Outrider Chainmail",
	[54297] = "Cracking Whip",
	[54298] = "Skyrocket Gun",
	[54303] = "Total Disaster Bracers",
	[54308] = "Gassy Bracers",
	[54309] = "Gas Soaked Boots",
	[54505] = "Breeches of Mended Nightmares",
	[54593] = "Pattern: Vicious Embersilk Cowl",
	[54594] = "Pattern: Vicious Embersilk Pants",
	[54595] = "Pattern: Vicious Embersilk Robe",
	[54596] = "Pattern: Vicious Fireweave Cowl",
	[54597] = "Pattern: Vicious Fireweave Pants",
	[54598] = "Pattern: Vicious Fireweave Robe",
	[54599] = "Pattern: Powerful Enchanted Spellthread",
	[54600] = "Pattern: Powerful Ghostly Spellthread",
	[54601] = "Pattern: Belt of the Depths",
	[54602] = "Pattern: Dreamless Belt",
	[54603] = "Pattern: Breeches of Mended Nightmares",
	[54604] = "Pattern: Flame-Ascended Pantaloons",
	[54605] = "Pattern: Illusionary Bag",
	[54747] = "Bottle of Grog",
	[55059] = "Hardened Elementium Girdle",
	[56537] = "Belt of Nefarious Whispers",
	[56539] = "Corded Viper Belt",
	[56563] = "Twilight Scale Chestguard",
	[56627] = "Labor Camp Frock",
	[56640] = "Leggings of Loss",
	[56645] = "Kadrak's Breastplate",
	[56717] = "Mystlash Bracers",
	[56723] = "Deerstalker Leggings",
	[56843] = "Lighthammer Pauldrons",
	[56844] = "Bone Valley Mace",
	[56846] = "Bloodcraver Pauldrons",
	[56863] = "Nasmira's Soup Stirrer",
	[56865] = "Salvaged Steamwheedle Helm",
	[56866] = "Failed Liferocket Prototype",
	[56882] = "Cleaned-Up Pauldrons",
	[57469] = "Saurboz's Leggings",
	[57470] = "Incinerator's Gauntlets",
	[57471] = "Elf-Killer Breastplate",
	[57477] = "Overlord's Favor",
	[57491] = "Spare Part Leggings",
	[57834] = "Frog Boots",
	[57851] = "Swamp Gas Gauntlets",
	[58085] = "Flask of Steelskin",
	[58086] = "Flask of the Draconic Mind",
	[58087] = "Flask of the Winds",
	[58088] = "Flask of Titanic Strength",
	[58149] = "Flask of Enhancement",
	[58256] = "Sparkling Oasis Water",
	[58257] = "Highland Spring Water",
	[58260] = "Pine Nut Bread",
	[58261] = "Buttery Wheat Roll",
	[58262] = "Sliced Raw Billfish",
	[58263] = "Grilled Shark",
	[58264] = "Sour Green Apple",
	[58265] = "Highland Pomegranate",
	[58268] = "Roasted Beef",
	[58269] = "Massive Turkey Leg",
	[58274] = "Fresh Water",
	[58499] = "Grasp of Victory",
	[59359] = "Reinforced Bio-Optic Killshades",
	[59408] = "Boots of Intimidation",
	[59412] = "Boots of Financial Victory",
	[59417] = "Rockard Greaves",
	[59529] = "Flame Retardant Sheet",
	[59543] = "Pigman Belt",
	[59568] = "Painstakingly Crafted Belt",
	[59569] = "Clean Room Boots",
	[59577] = "Sputtervalve Gun",
	[59578] = "Bracers of Angry Mutterings",
	[61931] = "Polished Helm of Valor",
	[61935] = "Tarnished Raging Berserker's Helm",
	[61936] = "Mystical Coif of Elements",
	[61937] = "Stained Shadowcraft Cap",
	[61942] = "Preened Tribal War Feathers",
	[61958] = "Tattered Dreadmist Mask",
	[62038] = "Worn Stoneskin Gargoyle Cape",
	[62039] = "Inherited Cape of the Black Baron",
	[62040] = "Ancient Bloodmoon Cloak",
	[62253] = "Grunt's Plate Armor",
	[62254] = "Grunt's Plate Belt",
	[62255] = "Grunt's Plate Boots",
	[62256] = "Grunt's Plate Bracers",
	[62257] = "Grunt's Plate Gloves",
	[62258] = "Grunt's Plate Leggings",
	[62259] = "Grunt's Plate Helm",
	[62260] = "Grunt's Chain Belt",
	[62261] = "Grunt's Chain Boots",
	[62262] = "Grunt's Chain Bracers",
	[62263] = "Grunt's Chain Gloves",
	[62264] = "Grunt's Chain Leggings",
	[62265] = "Grunt's Chain Vest",
	[62266] = "Grunt's Chain Circlet",
	[62286] = "Guild Vault Voucher (7th Slot)",
	[62287] = "Guild Vault Voucher (8th Slot)",
	[62298] = "Reins of the Golden King",
	[62321] = "Lesser Inscription of Unbreakable Quartz",
	[62333] = "Greater Inscription of Unbreakable Quartz",
	[62342] = "Lesser Inscription of Charged Lodestonez",
	[62343] = "Greater Inscription of Charged Lodestone",
	[62344] = "Lesser Inscription of Jagged Stone",
	[62345] = "Greater Inscription of Jagged Stone",
	[62346] = "Greater Inscription of Shattered Crystal",
	[62347] = "Lesser Inscription of Shattered Crystal",
	[62461] = "Goblin Trike Key",
	[62799] = "Recipe: Broiled Dragon Feast",
	[62800] = "Recipe: Seafood Magnifique Feast",
	[63125] = "Reins of the Dark Phoenix",
	[63138] = "Dark Phoenix Hatchling",
	[63206] = "Wrap of Unity",
	[63207] = "Wrap of Unity",
	[63352] = "Shroud of Cooperation",
	[63353] = "Shroud of Cooperation",
	[63359] = "Banner of Cooperation",
	[63398] = "Armadillo Pup",
	[63556] = "Bear Hug Bracers",
	[63557] = "Manly Pauldrons",
	[63563] = "Maloof's Spare Boots",
	[63565] = "Bracers of Desperate Need",
	[64398] = "Standard of Unity",
	[64399] = "Battle Standard of Coordination",
	[64400] = "Banner of Cooperation",
	[64401] = "Standard of Unity",
	[64402] = "Battle Standard of Coordination",
	[64645] = "Tyrande's Favorite Doll",
	[64670] = "Vanishing Powder",
	[65274] = "Cloak of Coordination",
	[65322] = "Mr. Tauren's Boots",
	[65360] = "Cloak of Coordination",
	[65361] = "Guild Page",
	[65362] = "Guild Page",
	[65363] = "Guild Herald",
	[65364] = "Guild Herald",
	[65435] = "Recipe: Cauldron of Battle",
	[65498] = "Recipe: Big Cauldron of Battle",
	[65931] = "Essence of Eranikus' Shade",
	[65937] = "Serpentis' Gloves",
	[66014] = "Vishas' Hood",
	[66032] = "Gloves of the \"Pure\"",
	[66100] = "Plans: Ebonsteel Belt Buckle",
	[66101] = "Plans: Pyrium Shield Spike",
	[66103] = "Plans: Pyrium Weapon Chain",
	[66104] = "Plans: Hardened Elementium Hauberk",
	[66105] = "Plans: Hardened Elementium Girdle",
	[66106] = "Plans: Elementium Deathplate",
	[66107] = "Plans: Elementium Girdle of Pain",
	[66108] = "Plans: Light Elementium Chestguard",
	[66109] = "Plans: Light Elementium Belt",
	[66110] = "Plans: Elementium Spellblade",
	[66111] = "Plans: Elementium Hammer",
	[66112] = "Plans: Elementium Poleaxe",
	[66113] = "Plans: Elementium Bonesplitter",
	[66114] = "Plans: Elementium Shank",
	[66115] = "Plans: Elementium Earthguard",
	[66116] = "Plans: Elementium Stormshield",
	[66117] = "Plans: Vicious Pyrium Bracers",
	[66118] = "Plans: Vicious Pyrium Gauntlets",
	[66119] = "Plans: Vicious Pyrium Belt",
	[66120] = "Plans: Vicious Pyrium Boots",
	[66121] = "Plans: Vicious Pyrium Shoulders",
	[66122] = "Plans: Vicious Pyrium Legguards",
	[66123] = "Plans: Vicious Pyrium Helm",
	[66124] = "Plans: Vicious Pyrium Breastplate",
	[66125] = "Plans: Vicious Ornate Pyrium Bracers",
	[66126] = "Plans: Vicious Ornate Pyrium Gauntlets",
	[66127] = "Plans: Vicious Ornate Pyrium Belt",
	[66128] = "Plans: Vicious Ornate Pyrium Boots",
	[66129] = "Plans: Vicious Ornate Pyrium Shoulders",
	[66130] = "Plans: Vicious Ornate Pyrium Legguards",
	[66131] = "Plans: Vicious Ornate Pyrium Helm",
	[66132] = "Plans: Vicious Ornate Pyrium Breastplate",
	[67042] = "Pattern: Vicious Wyrmhide Bracers",
	[67044] = "Pattern: Vicious Wyrmhide Belt",
	[67046] = "Pattern: Vicious Leather Bracers",
	[67048] = "Pattern: Vicious Leather Gloves",
	[67049] = "Pattern: Vicious Charscale Bracers",
	[67053] = "Pattern: Vicious Charscale Gloves",
	[67054] = "Pattern: Vicious Dragonscale Bracers",
	[67055] = "Pattern: Vicious Dragonscale Shoulders",
	[67056] = "Pattern: Vicious Wyrmhide Gloves",
	[67058] = "Pattern: Vicious Wyrmhide Boots",
	[67060] = "Pattern: Vicious Leather Boots",
	[67062] = "Pattern: Vicious Leather Shoulders",
	[67063] = "Pattern: Vicious Charscale Boots",
	[67064] = "Pattern: Vicious Charscale Belt",
	[67065] = "Pattern: Vicious Dragonscale Boots",
	[67066] = "Pattern: Vicious Dragonscale Gloves",
	[67068] = "Pattern: Lightning Lash",
	[67070] = "Pattern: Belt of Nefarious Whispers",
	[67072] = "Pattern: Stormleather Sash",
	[67073] = "Pattern: Corded Viper Belt",
	[67074] = "Pattern: Vicious Wyrmhide Shoulders",
	[67075] = "Pattern: Vicious Wyrmhide Chest",
	[67076] = "Pattern: Vicious Leather Belt",
	[67077] = "Pattern: Vicious Leather Helm",
	[67078] = "Pattern: Vicious Charscale Shoulders",
	[67079] = "Pattern: Vicious Charscale Legs",
	[67080] = "Pattern: Vicious Dragonscale Belt",
	[67081] = "Pattern: Vicious Dragonscale Helm",
	[67082] = "Pattern: Razor-Edged Cloak",
	[67083] = "Pattern: Twilight Dragonscale Cloak",
	[67084] = "Pattern: Charscale Leg Armor",
	[67085] = "Pattern: Vicious Wyrmhide Legs",
	[67086] = "Pattern: Vicious Wyrmhide Helm",
	[67087] = "Pattern: Vicious Leather Chest",
	[67089] = "Pattern: Vicious Leather Legs",
	[67090] = "Pattern: Vicious Charscale Chest",
	[67091] = "Pattern: Vicious Charscale Helm",
	[67092] = "Pattern: Vicious Dragonscale Legs",
	[67093] = "Pattern: Vicious Dragonscale Chest",
	[67094] = "Pattern: Chestguard of Nature's Fury",
	[67095] = "Pattern: Assassin's Chestplate",
	[67096] = "Pattern: Twilight Scale Chestguard",
	[67100] = "Pattern: Dragonkiller Tunic",
	[67107] = "Reins of the Kor'kron Annihilator",
	[67154] = "Staff of the Unwelcome",
	[67157] = "Harness of Binding",
	[67160] = "Dagger of Suffering",
	[67161] = "Dagger of Wretched Spectres",
	[67177] = "Amulet of the Kaldorei Spirit",
	[67178] = "Blade of Wretched Spirits",
	[67196] = "Witch Doctor's Spaulders",
	[67197] = "Rocksnitch Helmet",
	[67210] = "Wand of Sudden Changes",
	[67212] = "Bear Hunter's Belt",
	[67438] = "Flask of Flowing Water",
	[67536] = "Darkspear Satchel",
	[67603] = "Plans: Elementium Gutslicer",
	[67606] = "Plans: Forged Elementium Mindcrusher",
	[68136] = "Guild Vault Voucher (8th Slot)",
	[68193] = "Pattern: Dragonscale Leg Armor",
	[68199] = "Pattern: Black Embersilk Gown",
	[68776] = "Quicksilver Alchemist Stone",
	[68777] = "Vibrant Alchemist Stone",
	[69209] = "Illustrious Guild Tabard",
	[69210] = "Renowned Guild Tabard",
	[69239] = "Winterspring Cub",
	[69764] = "Extinct Turtle Shell",
	[69887] = "Burnished Helm of Might",
	[69892] = "Ripped Sandstorm Cloak",
	[71033] = "Lil' Tarecgosa",
	[71721] = "Pattern: Drakehide Leg Armor",
}

local sellvalueNum = 1
local deletevalueNum = 1
local totalsum = 0
local includesoulbound = false
local SkulySort_Timer = nil
GrayDelete_Timer = nil
myAceTimer = LibStub("AceTimer-3.0"):Embed(B)

function B:GetContainerItemInfo(containerIndex, slotIndex)
		if _G.GetContainerItemInfo then
			local info = {}
			info.iconFileID, info.stackCount, info.isLocked, info.quality, info.isReadable, info.hasLoot, info.hyperlink, info.isFiltered, info.hasNoValue, info.itemID, info.isBound = GetContainerItemInfo(containerIndex, slotIndex)
			return info
		else
			return GetContainerItemInfo(containerIndex, slotIndex) or {}
		end
	end


function B:GetContainerFrame(arg)
	if type(arg) == "boolean" and arg == true then
		return B.BankFrame
	elseif type(arg) == "number" then
		if B.BankFrame then
			for _, bagID in ipairs(B.BankFrame.BagIDs) do
				if bagID == arg then
					return B.BankFrame
				end
			end
		end
	end

	return B.BagFrame
end

function B:Tooltip_Show()
	GameTooltip:SetOwner(self)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(self.ttText)

	if self.ttText2 then
		if self.ttText2desc then
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine(self.ttText2, self.ttText2desc, 1, 1, 1)
		else
			GameTooltip:AddLine(self.ttText2)
		end
	end

	if self.ttValue and self.ttValue() > 0 then
		GameTooltip:AddLine(E:FormatMoney(self.ttValue(), E.db.bags.moneyFormat, not E.db.bags.moneyCoins), 1, 1, 1)
	end

	GameTooltip:Show()
end

function B:DisableBlizzard()
	BankFrame:UnregisterAllEvents()

	for i = 1, NUM_CONTAINER_FRAMES do
		_G["ContainerFrame"..i]:Kill()
	end
end

function B:SearchReset()
	SEARCH_STRING = ""
end

function B:IsSearching()
	return SEARCH_STRING ~= "" and SEARCH_STRING ~= SEARCH
end

function B:UpdateSearch()
	local search = self:GetText()
	if self.Instructions then
		self.Instructions:SetShown(search == "")
	end

	local MIN_REPEAT_CHARACTERS = 3
	local prevSearch = SEARCH_STRING
	if #search > MIN_REPEAT_CHARACTERS then
		local repeatChar = true
		for i = 1, MIN_REPEAT_CHARACTERS, 1 do
			if sub(search, (0 - i), (0 - i)) ~= sub(search, (-1 - i), (-1 - i)) then
				repeatChar = false
				break
			end
		end

		if repeatChar then
			B:ResetAndClear()
			return
		end
	end

	--Keep active search term when switching between bank and reagent bank
	if search == SEARCH and prevSearch ~= "" then
		search = prevSearch
	elseif search == SEARCH then
		search = ""
	end

	SEARCH_STRING = search

	B:RefreshSearch()
	B:SetGuildBankSearch(SEARCH_STRING)
end

function B:OpenEditbox()
	B.BagFrame.detail:Hide()
	B.BagFrame.editBox:Show()
	B.BagFrame.editBox:SetText(SEARCH)
	B.BagFrame.editBox:HighlightText()
end

function B:ResetAndClear()
	B.BagFrame.editBox:SetText(SEARCH)
	B.BagFrame.editBox:ClearFocus()

	if B.BankFrame then
		B.BankFrame.editBox:SetText(SEARCH)
		B.BankFrame.editBox:ClearFocus()
	end

	B:SearchReset()
end

function B:SetSearch(query)
	local empty = #(gsub(query, " ", "")) == 0
	local method = Search.Matches
	local allowPartialMatch
	if Search.Filters.tipPhrases.keywords[query] then
		if query == "rel" or query == "reli" or query == "relic" then
			allowPartialMatch = true
		end
		method = Search.TooltipPhrase
		query = Search.Filters.tipPhrases.keywords[query]
	end

	for _, bagFrame in pairs(B.BagFrames) do
		for _, bagID in ipairs(bagFrame.BagIDs) do
			for slotID = 1, GetContainerNumSlots(bagID) do
				local _, _, _, _, _, _, link = GetContainerItemInfo(bagID, slotID)
				local button = bagFrame.Bags[bagID][slotID]
				local success, result = pcall(method, Search, link, query, allowPartialMatch)

				if empty or (success and result) then
					SetItemButtonDesaturated(button, button.locked or button.junkDesaturate)
					button.searchOverlay:Hide()
					button:SetAlpha(1)
				else
					SetItemButtonDesaturated(button, 1)
					button.searchOverlay:Show()
					button:SetAlpha(0.5)
				end
			end
		end
	end
end

function B:SetGuildBankSearch(query)
	local empty = #(gsub(query, " ", "")) == 0
	local method = Search.Matches
	local allowPartialMatch
	if Search.Filters.tipPhrases.keywords[query] then
		if query == "rel" or query == "reli" or query == "relic" then
			allowPartialMatch = true
		end
		method = Search.TooltipPhrase
		query = Search.Filters.tipPhrases.keywords[query]
	end

	if GuildBankFrame and GuildBankFrame:IsShown() then
		local tab = GetCurrentGuildBankTab()
		local _, _, isViewable = GetGuildBankTabInfo(tab)

		if isViewable then
			for slotID = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
				local link = GetGuildBankItemLink(tab, slotID)
				--A column goes from 1-14, e.g. GuildBankColumn1Button14 (slotID 14) or GuildBankColumn2Button3 (slotID 17)
				local col = ceil(slotID / 14)
				local btn = (slotID % 14)
				if col == 0 then col = 1 end
				if btn == 0 then btn = 14 end
				local button = _G["GuildBankColumn"..col.."Button"..btn]
				local success, result = pcall(method, Search, link, query, allowPartialMatch)
				if empty or (success and result) then
					SetItemButtonDesaturated(button, button.locked or button.junkDesaturate)
					button.searchOverlay:Hide()
					button:SetAlpha(1)
				else
					SetItemButtonDesaturated(button, 1)
					button.searchOverlay:Show()
					button:SetAlpha(0.5)
				end
			end
		end
	end
end

function B:UpdateItemLevelDisplay()
	if not E.private.bags.enable then return end

	local font = E.Libs.LSM:Fetch("font", E.db.bags.itemLevelFont)

	for _, bagFrame in pairs(B.BagFrames) do
		for _, bagID in ipairs(bagFrame.BagIDs) do
			for slotID = 1, GetContainerNumSlots(bagID) do
				local slot = bagFrame.Bags[bagID][slotID]
				if slot and slot.itemLevel then
					slot.itemLevel:FontTemplate(font, E.db.bags.itemLevelFontSize, E.db.bags.itemLevelFontOutline)
				end
			end
		end

		B:UpdateAllSlots(bagFrame)
	end
end

function B:UpdateCountDisplay()
	if not E.private.bags.enable then return end

	local font = E.Libs.LSM:Fetch("font", E.db.bags.countFont)

	for _, bagFrame in pairs(B.BagFrames) do
		for _, bagID in ipairs(bagFrame.BagIDs) do
			for slotID = 1, GetContainerNumSlots(bagID) do
				local slot = bagFrame.Bags[bagID][slotID]
				if slot and slot.Count then
					slot.Count:FontTemplate(font, E.db.bags.countFontSize, E.db.bags.countFontOutline)
				end
			end
		end

		B:UpdateAllSlots(bagFrame)
	end
end

function B:UpdateBagTypes(isBank)
	local f = B:GetContainerFrame(isBank)
	for _, bagID in ipairs(f.BagIDs) do
		if f.Bags[bagID] then
			f.Bags[bagID].type = select(2, GetContainerNumFreeSlots(bagID))
		end
	end
end


function B:UpdateAllBagSlots()
	if not E.private.bags.enable then return end

	for _, bagFrame in pairs(B.BagFrames) do
		B:UpdateAllSlots(bagFrame)
	end
end

local function ColorizeProfessionBagSlots(slot, profR, profG, profB, qualityR, qualityG, qualityB)
	local fadeR, fadeG, fadeB, fadeA = unpack(E.media.backdropfadecolor)

	if B.db.professionBagColorsStyle == "BACKDROP" or B.db.professionBagColorsStyle == "BOTH" then
		local mult = B.db.professionBagColorsMult
		if E.db.bags.transparent then
			slot:SetBackdropColor(profR * mult, profG * mult, profB * mult, fadeA)
		else
			slot.backdropTexture:SetVertexColor(profR * mult, profG * mult, profB * mult, 1)
		end
	else
		if E.db.bags.transparent then
			slot:SetBackdropColor(fadeR, fadeG, fadeB, fadeA)
		else
			slot.backdropTexture:SetVertexColor(unpack(E.media.backdropcolor))
		end
	end

	if B.db.professionBagColorsStyle == "BORDER" or B.db.professionBagColorsStyle == "BOTH" then
		slot:SetBackdropBorderColor(profR, profG, profB)
		slot.ignoreBorderColors = true
	else
		if B.db.qualityColors and (slot.rarity and slot.rarity > 1) then
			slot:SetBackdropBorderColor(qualityR, qualityG, qualityB)
			slot.ignoreBorderColors = true
		else
			slot:SetBackdropBorderColor(unpack(E.media.bordercolor))
			slot.ignoreBorderColors = nil
		end
	end
end

function B:UpdateSlot(frame, bagID, slotID)
	if (frame.Bags[bagID] and frame.Bags[bagID].numSlots ~= GetContainerNumSlots(bagID)) or not frame.Bags[bagID] or not frame.Bags[bagID][slotID] then return end

	local slot = frame.Bags[bagID][slotID]
	local bagType = frame.Bags[bagID].type
	local texture, count, locked, _, readable = GetContainerItemInfo(bagID, slotID)
	local link = GetContainerItemLink(bagID, slotID)

	slot.name, slot.rarity, slot.locked, slot.readable, slot.isJunk, slot.junkDesaturate = nil, nil, locked, readable, nil, nil

	slot:Show()
	slot.questIcon:Hide()
	slot.JunkIcon:Hide()
	slot.itemLevel:SetText("")
	slot.bindType:SetText("")

	local borderR, borderG, borderB = unpack(E.media.bordercolor)
	local fadeR, fadeG, fadeB, fadeA = unpack(E.media.backdropfadecolor)
	local backdropR, backdropG, backdropB = unpack(E.media.backdropcolor)

	if link then
		local name, _, itemRarity, iLvl, _, iType, _, _, itemEquipLoc, _, itemPrice = GetItemInfo(link)
		local isQuestItem, questId, isActiveQuest = GetContainerItemQuestInfo(bagID, slotID)
		local qualityR, qualityG, qualityB

		slot.name = name
		slot.rarity = itemRarity
		slot.isJunk = (slot.rarity and slot.rarity == 0) and (itemPrice and itemPrice > 0) and (iType and iType ~= "Quest")
		slot.junkDesaturate = slot.isJunk and B.db.junkDesaturate

		if slot.rarity then
			qualityR, qualityG, qualityB = GetItemQualityColor(slot.rarity)
		end

		if B.db.showBindType and (slot.rarity and slot.rarity > 1) then
			local bindTypeLines = GetCVarBool("colorblindmode") and 8 or 7
			local BoE, BoU

			E.ScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
			if slot.GetInventorySlot then -- this fixes bank bagid -1
				E.ScanTooltip:SetInventoryItem("player", slot:GetInventorySlot())
			else
				E.ScanTooltip:SetBagItem(bagID, slotID)
			end
			E.ScanTooltip:Show()

			for i = 2, bindTypeLines do
				local line = _G["ElvUI_ScanTooltipTextLeft"..i]:GetText()
				if (not line or line == "") or (line == ITEM_SOULBOUND or line == ITEM_ACCOUNTBOUND or line == ITEM_BNETACCOUNTBOUND) then break end

				BoE, BoU = line == ITEM_BIND_ON_EQUIP, line == ITEM_BIND_ON_USE

				if not B.db.showBindType and (slot.rarity and slot.rarity > 1) or (BoE or BoU) then break end
			end

			E.ScanTooltip:Hide()

			if BoE or BoU then
				slot.bindType:SetText(BoE and L["BoE"] or L["BoU"])
				slot.bindType:SetVertexColor(qualityR, qualityG, qualityB)
			end
		end

		-- Item Level
		if iLvl and B.db.itemLevel and (itemEquipLoc ~= nil and itemEquipLoc ~= "" and itemEquipLoc ~= "INVTYPE_BAG" and itemEquipLoc ~= "INVTYPE_QUIVER" and itemEquipLoc ~= "INVTYPE_TABARD") and (slot.rarity and slot.rarity > 1) and iLvl >= B.db.itemLevelThreshold then
			slot.itemLevel:SetText(iLvl)
			if B.db.itemLevelCustomColorEnable then
				slot.itemLevel:SetTextColor(B.db.itemLevelCustomColor.r, B.db.itemLevelCustomColor.g, B.db.itemLevelCustomColor.b)
			else
				slot.itemLevel:SetTextColor(qualityR, qualityG, qualityB)
			end
		end

		-- Junk Icon
		if B.db.junkIcon and slot.isJunk then
			slot.JunkIcon:Show()
		end

		-- Quest Icon
		if B.db.questIcon and (questId and not isActiveQuest) then
			slot.questIcon:Show()
		end

		local color = B.db.countFontColor
		slot.Count:SetTextColor(color.r, color.g, color.b)

		if B.db.professionBagColors and B.ProfessionColors[bagType] then -- Profession Bags with Item
			local profR, profG, profB = unpack(B.ProfessionColors[bagType])
			ColorizeProfessionBagSlots(slot, profR, profG, profB, qualityR, qualityG, qualityB)
		elseif B.db.questItemColors and (questId and not isActiveQuest) then -- Quest Starter Item
			slot:SetBackdropBorderColor(unpack(B.QuestColors.questStarter))
			slot.ignoreBorderColors = true
		elseif B.db.questItemColors and (questId or isQuestItem) then -- Quest Item
			slot:SetBackdropBorderColor(unpack(B.QuestColors.questItem))
			slot.ignoreBorderColors = true
		elseif B.db.qualityColors and (slot.rarity and slot.rarity > 1) then -- Color slot according to item quality
			slot:SetBackdropBorderColor(qualityR, qualityG, qualityB)
			slot.ignoreBorderColors = true
		else
			slot:SetBackdropBorderColor(borderR, borderG, borderB)
			slot.ignoreBorderColors = nil
		end

		if B.db.transparent then
			slot:SetBackdropColor(fadeR, fadeG, fadeB, fadeA)
		else
			slot.backdropTexture:SetVertexColor(backdropR, backdropG, backdropB)
		end
	else
		if B.db.professionBagColors and B.ProfessionColors[bagType] then -- Profession Bags without Item
			local profR, profG, profB = unpack(B.ProfessionColors[bagType])
			ColorizeProfessionBagSlots(slot, profR, profG, profB)
		else -- Empty
			if B.db.transparent then
				slot:SetBackdropColor(fadeR, fadeG, fadeB, fadeA)
			else
				slot.backdropTexture:SetVertexColor(backdropR, backdropG, backdropB)
			end

			slot:SetBackdropBorderColor(borderR, borderG, borderB)
			slot.ignoreBorderColors = nil
		end
	end

	if texture then
		local start, duration, enable = GetContainerItemCooldown(bagID, slotID)
		CooldownFrame_SetTimer(slot.cooldown, start, duration, enable)
		if duration > 0 and enable == 0 then
			SetItemButtonTextureVertexColor(slot, 0.4, 0.4, 0.4)
		else
			SetItemButtonTextureVertexColor(slot, 1, 1, 1)
		end
		slot.hasItem = 1
	else
		slot.cooldown:Hide()
		slot.hasItem = nil
	end

	SetItemButtonTexture(slot, texture)
	SetItemButtonCount(slot, count)
	SetItemButtonDesaturated(slot, slot.locked or slot.junkDesaturate)

	if GameTooltip:GetOwner() == slot and not slot.hasItem then
		GameTooltip_Hide()
	end
end

function B:UpdateBagSlots(frame, bagID)
	for slotID = 1, GetContainerNumSlots(bagID) do
		B:UpdateSlot(frame, bagID, slotID)
	end
end

function B:RefreshSearch()
	B:SetSearch(SEARCH_STRING)
end

function B:SortingFadeBags(bagFrame, registerUpdate)
	if not (bagFrame and bagFrame.BagIDs) then return end
	bagFrame.registerUpdate = registerUpdate
		if button ~= nil then
			for _, bagID in ipairs(bagFrame.BagIDs) do
				for slotID = 1, GetContainerNumSlots(bagID) do
					local button = bagFrame.Bags[bagID][slotID]
					SetItemButtonDesaturated(button, 1)
					button.searchOverlay:Show()
					button:SetAlpha(0.5)
				end
			end
		end
end

function B:UpdateCooldowns(frame)
	if not (frame and frame.BagIDs) then return end

	for _, bagID in ipairs(frame.BagIDs) do
		for slotID = 1, GetContainerNumSlots(bagID) do
			local start, duration, enable = GetContainerItemCooldown(bagID, slotID)
			CooldownFrame_SetTimer(frame.Bags[bagID][slotID].cooldown, start, duration, enable)
		end
	end
end

function B:UpdateAllSlots(frame)
	if not (frame and frame.BagIDs) then return end

	for _, bagID in ipairs(frame.BagIDs) do
		local bag = frame.Bags[bagID]
		if bag then B:UpdateBagSlots(frame, bagID) end
	end

	-- Refresh search in case we moved items around
	if not frame.registerUpdate and B:IsSearching() then
		B:RefreshSearch()
	end
end

function B:SetSlotAlphaForBag(f)
	for _, bagID in ipairs(f.BagIDs) do
		if f.Bags[bagID] then
			for slotID = 1, GetContainerNumSlots(bagID) do
				if f.Bags[bagID][slotID] then
					if bagID == self.id then
						f.Bags[bagID][slotID]:SetAlpha(1)
					else
						f.Bags[bagID][slotID]:SetAlpha(0.1)
					end
				end
			end
		end
	end
end

function B:ResetSlotAlphaForBags(f)
	for _, bagID in ipairs(f.BagIDs) do
		if f.Bags[bagID] then
			for slotID = 1, GetContainerNumSlots(bagID) do
				if f.Bags[bagID][slotID] then
					f.Bags[bagID][slotID]:SetAlpha(1)
				end
			end
		end
	end
end

function B:Layout(isBank)
	if not E.private.bags.enable then return end

	local f = B:GetContainerFrame(isBank)
	if not f then return end

	local buttonSize = isBank and B.db.bankSize or B.db.bagSize
	local buttonSpacing = isBank and B.db.bankButtonSpacing or B.db.bagButtonSpacing
	local containerWidth = ((isBank and B.db.bankWidth) or B.db.bagWidth)
	local numContainerColumns = floor(containerWidth / (buttonSize + buttonSpacing))
	local holderWidth = ((buttonSize + buttonSpacing) * numContainerColumns) - buttonSpacing
	local numContainerRows, numBags, numBagSlots = 0, 0, 0
	local bagSpacing = isBank and B.db.split.bankSpacing or B.db.split.bagSpacing
	local countColor = E.db.bags.countFontColor
	local isSplit = B.db.split[isBank and "bank" or "player"]

	f.holderFrame:Width(holderWidth)
	f.totalSlots = 0
	local lastButton, lastRowButton, lastContainerButton, newBag
	local numContainerSlots = GetNumBankSlots()

	for i, bagID in ipairs(f.BagIDs) do
		if isSplit then
			newBag = (bagID ~= -1 or bagID ~= 0) and B.db.split["bag"..bagID] or false
		end

		--Bag Containers
		if (not isBank) or (isBank and bagID ~= -1 and numContainerSlots >= 1 and not (i - 1 > numContainerSlots)) then
			if not f.ContainerHolder[i] then
				if isBank then
					f.ContainerHolder[i] = CreateFrame("CheckButton", "ElvUIBankBag"..bagID - 4, f.ContainerHolder, "BankItemButtonBagTemplate")
					f.ContainerHolder[i]:SetScript("OnClick", function(holder)
						local inventoryID = holder:GetInventorySlot()
						PutItemInBag(inventoryID)
					end)
				else
					if bagID == 0 then
						f.ContainerHolder[i] = CreateFrame("CheckButton", "ElvUIMainBagBackpack", f.ContainerHolder, "ItemButtonTemplate")

						f.ContainerHolder[i].model = CreateFrame("Model", "$parentItemAnim", f.ContainerHolder[i], "ItemAnimTemplate")
						f.ContainerHolder[i].model:SetPoint("BOTTOMRIGHT", -10, 0)

						f.ContainerHolder[i]:SetScript("OnClick", function()
							PutItemInBackpack()
						end)
						f.ContainerHolder[i]:SetScript("OnReceiveDrag", function()
							PutItemInBackpack()
						end)
						f.ContainerHolder[i]:SetScript("OnEnter", function(holder)
							GameTooltip:SetOwner(holder, "ANCHOR_LEFT")
							GameTooltip:SetText(BACKPACK_TOOLTIP, 1, 1, 1)
							GameTooltip:Show()
						end)
						f.ContainerHolder[i]:SetScript("OnLeave", GameTooltip_Hide)
					else
						f.ContainerHolder[i] = CreateFrame("CheckButton", "ElvUIMainBag"..(bagID - 1).."Slot", f.ContainerHolder, "BagSlotButtonTemplate")
						f.ContainerHolder[i]:SetScript("OnClick", function(holder)
							local id = holder:GetID()
							PutItemInBag(id)
						end)
					end
				end

				f.ContainerHolder[i]:SetTemplate(E.db.bags.transparent and "Transparent", true)
				f.ContainerHolder[i]:StyleButton()
				f.ContainerHolder[i]:SetNormalTexture("")
				f.ContainerHolder[i]:SetCheckedTexture(nil)
				f.ContainerHolder[i]:SetPushedTexture("")
				f.ContainerHolder[i].id = bagID
				f.ContainerHolder[i]:HookScript("OnEnter", function(ch) B.SetSlotAlphaForBag(ch, f) end)
				f.ContainerHolder[i]:HookScript("OnLeave", function(ch) B.ResetSlotAlphaForBags(ch, f) end)

				if isBank then
					f.ContainerHolder[i]:SetID(bagID)
					if not f.ContainerHolder[i].tooltipText then
						f.ContainerHolder[i].tooltipText = ""
					end
				end

				f.ContainerHolder[i].iconTexture = _G[f.ContainerHolder[i]:GetName().."IconTexture"]
				if bagID == 0 then
					f.ContainerHolder[i].iconTexture:SetTexture("Interface\\Buttons\\Button-Backpack-Up")
				end
				f.ContainerHolder[i].iconTexture:SetInside()
				f.ContainerHolder[i].iconTexture:SetTexCoord(unpack(E.TexCoords))
			end

			f.ContainerHolder:Size(((buttonSize + buttonSpacing) * (isBank and i - 1 or i)) + buttonSpacing, buttonSize + (buttonSpacing * 2))

			if isBank then
				BankFrameItemButton_Update(f.ContainerHolder[i])
				BankFrameItemButton_UpdateLocked(f.ContainerHolder[i])
			end

			f.ContainerHolder[i]:Size(buttonSize)
			f.ContainerHolder[i]:ClearAllPoints()
			if (isBank and i == 2) or (not isBank and i == 1) then
				f.ContainerHolder[i]:Point("BOTTOMLEFT", f.ContainerHolder, "BOTTOMLEFT", buttonSpacing, buttonSpacing)
			else
				f.ContainerHolder[i]:Point("LEFT", lastContainerButton, "RIGHT", buttonSpacing, 0)
			end

			lastContainerButton = f.ContainerHolder[i]
		end

		--Bag Slots
		local numSlots = GetContainerNumSlots(bagID)
		if numSlots > 0 then
			if not f.Bags[bagID] then
				f.Bags[bagID] = CreateFrame("Frame", f:GetName().."Bag"..bagID, f.holderFrame)
				f.Bags[bagID]:SetID(bagID)
			end

			f.Bags[bagID].numSlots = numSlots
			f.Bags[bagID].type = select(2, GetContainerNumFreeSlots(bagID))

			--Hide unused slots
			for y = 1, MAX_CONTAINER_ITEMS do
				if f.Bags[bagID][y] then
					f.Bags[bagID][y]:Hide()
				end
			end

			for slotID = 1, numSlots do
				f.totalSlots = f.totalSlots + 1
				if not f.Bags[bagID][slotID] then
					f.Bags[bagID][slotID] = CreateFrame("CheckButton", f.Bags[bagID]:GetName().."Slot"..slotID, f.Bags[bagID], bagID == -1 and "BankItemButtonGenericTemplate" or "ContainerFrameItemButtonTemplate")
					f.Bags[bagID][slotID]:StyleButton()
					f.Bags[bagID][slotID]:SetTemplate(E.db.bags.transparent and "Transparent", true)
					f.Bags[bagID][slotID]:SetNormalTexture(nil)
					f.Bags[bagID][slotID]:SetCheckedTexture(nil)

					f.Bags[bagID][slotID].Count = _G[f.Bags[bagID][slotID]:GetName().."Count"]
					f.Bags[bagID][slotID].Count:ClearAllPoints()
					f.Bags[bagID][slotID].Count:Point("BOTTOMRIGHT", -1, 3)
					f.Bags[bagID][slotID].Count:FontTemplate(E.Libs.LSM:Fetch("font", E.db.bags.countFont), E.db.bags.countFontSize, E.db.bags.countFontOutline)
					f.Bags[bagID][slotID].Count:SetTextColor(countColor.r, countColor.g, countColor.b)

					if not f.Bags[bagID][slotID].questIcon then
						f.Bags[bagID][slotID].questIcon = _G[f.Bags[bagID][slotID]:GetName().."IconQuestTexture"] or _G[f.Bags[bagID][slotID]:GetName()].IconQuestTexture
						f.Bags[bagID][slotID].questIcon:SetTexture(E.Media.Textures.BagQuestIcon)
						f.Bags[bagID][slotID].questIcon:SetTexCoord(0, 1, 0, 1)
						f.Bags[bagID][slotID].questIcon:SetInside()
						f.Bags[bagID][slotID].questIcon:Hide()
					end

					if not f.Bags[bagID][slotID].JunkIcon then
						local JunkIcon = f.Bags[bagID][slotID]:CreateTexture(nil, "OVERLAY")
						JunkIcon:SetTexture(E.Media.Textures.BagJunkIcon)
						JunkIcon:Point("TOPLEFT", 1, 0)
						JunkIcon:Hide()
						f.Bags[bagID][slotID].JunkIcon = JunkIcon
					end

					f.Bags[bagID][slotID].iconTexture = _G[f.Bags[bagID][slotID]:GetName().."IconTexture"]
					f.Bags[bagID][slotID].iconTexture:SetInside(f.Bags[bagID][slotID])
					f.Bags[bagID][slotID].iconTexture:SetTexCoord(unpack(E.TexCoords))

					f.Bags[bagID][slotID].searchOverlay:SetAllPoints()

					f.Bags[bagID][slotID].cooldown = _G[f.Bags[bagID][slotID]:GetName().."Cooldown"]
					f.Bags[bagID][slotID].cooldown.CooldownOverride = "bags"
					E:RegisterCooldown(f.Bags[bagID][slotID].cooldown)
					f.Bags[bagID][slotID].bagID = bagID
					f.Bags[bagID][slotID].slotID = slotID

					f.Bags[bagID][slotID].itemLevel = f.Bags[bagID][slotID]:CreateFontString(nil, "ARTWORK")
					f.Bags[bagID][slotID].itemLevel:Point("BOTTOMRIGHT", -1, 3)
					f.Bags[bagID][slotID].itemLevel:FontTemplate(E.Libs.LSM:Fetch("font", E.db.bags.itemLevelFont), E.db.bags.itemLevelFontSize, E.db.bags.itemLevelFontOutline)

					f.Bags[bagID][slotID].bindType = f.Bags[bagID][slotID]:CreateFontString(nil, "ARTWORK")
					f.Bags[bagID][slotID].bindType:Point("TOP", 0, -2)
					f.Bags[bagID][slotID].bindType:FontTemplate(E.Libs.LSM:Fetch("font", E.db.bags.itemLevelFont), E.db.bags.itemLevelFontSize, E.db.bags.itemLevelFontOutline)
				end

				f.Bags[bagID][slotID]:SetID(slotID)
				f.Bags[bagID][slotID]:Size(buttonSize)

				if f.Bags[bagID][slotID].JunkIcon then
					f.Bags[bagID][slotID].JunkIcon:Size(buttonSize / 2)
				end

				B:UpdateSlot(f, bagID, slotID)

				if f.Bags[bagID][slotID]:GetPoint() then
					f.Bags[bagID][slotID]:ClearAllPoints()
				end

				if lastButton then
					local anchorPoint, relativePoint = (B.db.reverseSlots and "BOTTOM" or "TOP"), (B.db.reverseSlots and "TOP" or "BOTTOM")
					if isSplit and newBag and slotID == 1 then
						f.Bags[bagID][slotID]:Point(anchorPoint, lastRowButton, relativePoint, 0, B.db.reverseSlots and (buttonSpacing + bagSpacing) or -(buttonSpacing + bagSpacing))
						lastRowButton = f.Bags[bagID][slotID]
						numContainerRows = numContainerRows + 1
						numBags = numBags + 1
						numBagSlots = 0
					elseif isSplit and numBagSlots % numContainerColumns == 0 then
						f.Bags[bagID][slotID]:Point(anchorPoint, lastRowButton, relativePoint, 0, B.db.reverseSlots and buttonSpacing or -buttonSpacing)
						lastRowButton = f.Bags[bagID][slotID]
						numContainerRows = numContainerRows + 1
					elseif (not isSplit) and (f.totalSlots - 1) % numContainerColumns == 0 then
						f.Bags[bagID][slotID]:Point(anchorPoint, lastRowButton, relativePoint, 0, B.db.reverseSlots and buttonSpacing or -buttonSpacing)
						lastRowButton = f.Bags[bagID][slotID]
						numContainerRows = numContainerRows + 1
					else
						anchorPoint, relativePoint = (B.db.reverseSlots and "RIGHT" or "LEFT"), (B.db.reverseSlots and "LEFT" or "RIGHT")
						f.Bags[bagID][slotID]:Point(anchorPoint, lastButton, relativePoint, B.db.reverseSlots and -buttonSpacing or buttonSpacing, 0)
					end
				else
					local anchorPoint = B.db.reverseSlots and "BOTTOMRIGHT" or "TOPLEFT"
					f.Bags[bagID][slotID]:Point(anchorPoint, f.holderFrame, anchorPoint, 0, B.db.reverseSlots and f.bottomOffset - 8 or 0)
					lastRowButton = f.Bags[bagID][slotID]
					numContainerRows = numContainerRows + 1
				end

				lastButton = f.Bags[bagID][slotID]
				numBagSlots = numBagSlots + 1
			end
		else
			--Hide unused slots
			for y = 1, MAX_CONTAINER_ITEMS do
				if f.Bags[bagID] and f.Bags[bagID][y] then
					f.Bags[bagID][y]:Hide()
				end
			end

			if f.Bags[bagID] then
				f.Bags[bagID].numSlots = numSlots
			end

			local container = isBank and f.ContainerHolder[i]
			if container then
				BankFrameItemButton_Update(container)
				BankFrameItemButton_UpdateLocked(container)
			end
		end
	end

	f:Size(containerWidth, (((buttonSize + buttonSpacing) * numContainerRows) - buttonSpacing) + (isSplit and (numBags * bagSpacing) or 0) + f.topOffset + f.bottomOffset) -- 8 is the cussion of the f.holderFrame
end

function B:UpdateAll()
	if B.BagFrame then B:Layout() end
	if B.BankFrame then B:Layout(true) end
end

function B:OnEvent(event, ...)
	if event == "ITEM_LOCK_CHANGED" or event == "ITEM_UNLOCKED" then
		local bag, slot = ...
		B:UpdateSlot(self, bag, slot)
		
	elseif event == "BAG_UPDATE" then
		for _, bagID in ipairs(self.BagIDs) do
			local numSlots = GetContainerNumSlots(bagID)
			if (not self.Bags[bagID] and numSlots ~= 0) or (self.Bags[bagID] and numSlots ~= self.Bags[bagID].numSlots) then
				B:Layout(self.isBank)
				return
			end
		end

		B:UpdateBagTypes()
		B:UpdateBagSlots(self, ...)

		--Refresh search in case we moved items around
		if B:IsSearching() then B:RefreshSearch() end
	elseif event == "BAG_UPDATE_COOLDOWN" then
		if not self:IsShown() then return end

		B:UpdateCooldowns(self)
	elseif event == "PLAYERBANKSLOTS_CHANGED" then
		B:UpdateBagTypes()
		B:UpdateBagSlots(self, -1)
	elseif (event == "QUEST_ACCEPTED" or event == "QUEST_REMOVED" or event == "QUEST_LOG_UPDATE") and self:IsShown() then
		B:UpdateAllSlots(self)
	end
end

function B:UpdateTokens()
	local f = B.BagFrame
	local numTokens = 0

	for _, button in ipairs(f.currencyButton) do
		button:Hide()
	end

	for i = 1, MAX_WATCHED_TOKENS do
		local name, count, icon, currencyID = GetBackpackCurrencyInfo(i)
		if not name then break end

		local button = f.currencyButton[i]
		button:ClearAllPoints()
		button.icon:SetTexture(icon)

		if B.db.currencyFormat == "ICON_TEXT" then
			button.text:SetText(name..": "..count)
		elseif B.db.currencyFormat == "ICON_TEXT_ABBR" then
			button.text:SetText(E:AbbreviateString(name)..": "..count)
		elseif B.db.currencyFormat == "ICON" then
			button.text:SetText(count)
		end

		button.currencyID = currencyID
		button:Show()
		numTokens = numTokens + 1
	end

	if numTokens == 0 then
		if f.bottomOffset > 8 then
			f.bottomOffset = 8
			B:Layout()
		end
	else
		if f.bottomOffset < 28 then
			f.bottomOffset = 28
			B:Layout()
		end

		if numTokens == 1 then
			f.currencyButton[1]:Point("BOTTOM", f.currencyButton, "BOTTOM", -(f.currencyButton[1].text:GetWidth() / 2), 3)
		elseif numTokens == 2 then
			f.currencyButton[1]:Point("BOTTOM", f.currencyButton, "BOTTOM", -(f.currencyButton[1].text:GetWidth()) - (f.currencyButton[1]:GetWidth() / 2), 3)
			f.currencyButton[2]:Point("BOTTOMLEFT", f.currencyButton, "BOTTOM", f.currencyButton[2]:GetWidth() / 2, 3)
		else
			f.currencyButton[1]:Point("BOTTOMLEFT", f.currencyButton, "BOTTOMLEFT", 3, 3)
			f.currencyButton[2]:Point("BOTTOM", f.currencyButton, "BOTTOM", -(f.currencyButton[2].text:GetWidth() / 3), 3)
			f.currencyButton[3]:Point("BOTTOMRIGHT", f.currencyButton, "BOTTOMRIGHT", -(f.currencyButton[3].text:GetWidth()) - (f.currencyButton[3]:GetWidth() / 2), 3)
		end
	end
end

function B:Token_OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetBackpackToken(self:GetID())
end

function B:Token_OnClick()
	if IsModifiedClick("CHATLINK") then
		HandleModifiedItemClick(GetCurrencyLink(self.currencyID))
	end
end

function B:UpdateGoldText()
	B.BagFrame.goldText:SetText(E:FormatMoney(GetMoney(), E.db.bags.moneyFormat, not E.db.bags.moneyCoins))

	local goldPos = E.db.bags.moneyCoins and (E.db.bags.moneyFormat == "SMART" or E.db.bags.moneyFormat == "FULL" or E.db.bags.moneyFormat == "BLIZZARD")
	B.BagFrame.goldText:Point("BOTTOMRIGHT", B.BagFrame.holderFrame, "TOPRIGHT", goldPos and -8 or -2, 4)
end

function B:GetGraysValue()
	local value = 0

	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemID = GetContainerItemID(bag, slot)
			if itemID then
				local _, _, rarity, _, _, iType, _, _, _, _, itemPrice = GetItemInfo(itemID)
				if itemPrice and itemPrice > 0 then
					local stackCount = select(2, GetContainerItemInfo(bag, slot)) or 1
					local stackPrice = itemPrice * stackCount
					if (rarity and rarity == 0) and (iType and iType ~= "Quest") then
						value = value + stackPrice
					end
				end
			end
		end
	end

	return value
end

function B:VendorGrays(delete)
	if B.SellFrame:IsShown() then return end

	if (not MerchantFrame or not MerchantFrame:IsShown()) and not delete then
		E:Print(L["You must be at a vendor."])
		return
	end

	for bag = 0, 4, 1 do
		for slot = 1, GetContainerNumSlots(bag), 1 do
			local itemID = GetContainerItemID(bag, slot)
			if itemID then
				local _, name, rarity, _, _, iType, _, _, _, _, itemPrice = GetItemInfo(itemID)

				if (rarity and rarity == 0) and (iType and iType ~= "Quest") and (itemPrice and itemPrice > 0) then
					tinsert(B.SellFrame.Info.itemList, {bag, slot, itemPrice, name})
				end
			end
		end
	end

	if not B.SellFrame.Info.itemList or tmaxn(B.SellFrame.Info.itemList) < 1 then return end

	--Resetting stuff
	B.SellFrame.Info.delete = delete or false
	B.SellFrame.Info.ProgressTimer = 0
	B.SellFrame.Info.SellInterval = E.db.bags.vendorGrays.interval
	B.SellFrame.Info.GreensSellInterval = E.db.bags.vendorGreens.interval
	B.SellFrame.Info.ProgressMax = tmaxn(B.SellFrame.Info.itemList)
	B.SellFrame.Info.goldGained = 0
	B.SellFrame.Info.itemsSold = 0

	B.SellFrame.statusbar:SetValue(0)
	B.SellFrame.statusbar:SetMinMaxValues(0, B.SellFrame.Info.ProgressMax)
	B.SellFrame.statusbar.ValueText:SetText("0 / "..B.SellFrame.Info.ProgressMax)

	--Time to sell
	B.SellFrame:Show()
end

function B:VendorGrayCheck()
	local value = B:GetGraysValue()

	if value == 0 then
		E:Print(L["No gray items to delete."])
	elseif not MerchantFrame or not MerchantFrame:IsShown() then
		E.PopupDialogs.DELETE_GRAYS.Money = value
		E:StaticPopup_Show("DELETE_GRAYS")
	else
		B:VendorGrays()
	end
end


function B:VendorGreens(delete)

	if B.SellFrameGreens:IsShown() then return end

	if (not MerchantFrame or not MerchantFrame:IsShown()) then
		E:Print(L["You must be at a vendor."])
		return
	end
	
	local scanTooltip

	for bag = 0, 4, 1 do
		for slot = 1, GetContainerNumSlots(bag), 1 do
			local itemID = GetContainerItemID(bag, slot)
			if itemID then
				local _, name, rarity, _, _, iType, _, _, _, _, itemPrice = GetItemInfo(itemID)
				if (rarity and rarity == 2) and (iType and iType ~= "Quest") and ((iType and iType == "Armor") or (iType and iType == "Weapon")) and (itemPrice and itemPrice > (sellvalueNum * 10000)) then
					--tinsert(B.SellFrameGreens.Info.itemList, {bag, slot, itemPrice, name})

					
				if not scanTooltip then
						scanTooltip = CreateFrame("GameTooltip", "soulboundScanTooltip", UIParent, "GameTooltipTemplate")
						scanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
				end
					scanTooltip:ClearLines()
					scanTooltip:SetHyperlink("item:"..itemID)
					
					for id=1, scanTooltip:NumLines() do
						local text = _G["soulboundScanTooltipTextLeft" .. id]

							if text then
							if id == 2 then
								--if ((text and text:GetText() == ITEM_BIND_ON_PICKUP and not includesoulbound) or (text and text:GetText() == ITEM_SOULBOUND and not includesoulbound) or text and text:GetText() == ITEM_BIND_QUEST) then
									if (text and text:GetText() ~= ITEM_BIND_ON_PICKUP and text:GetText() ~= ITEM_SOULBOUND) and not includesoulbound then
										return
									else
										tinsert(B.SellFrameGreens.Info.itemList, {bag, slot, itemPrice, name})
								end
							end
							
							
							end



					end
					
				end	
			end
		end
	end

	if not B.SellFrameGreens.Info.itemList or tmaxn(B.SellFrameGreens.Info.itemList) < 1 then return end

	--Resetting stuff
	B.SellFrameGreens.Info.delete = delete or false
	B.SellFrameGreens.Info.ProgressTimer = 0
	B.SellFrameGreens.Info.GreensSellInterval = E.db.bags.vendorGreens.interval
	B.SellFrameGreens.Info.ProgressMax = tmaxn(B.SellFrameGreens.Info.itemList)
	B.SellFrameGreens.Info.goldGained = 0
	B.SellFrameGreens.Info.itemsSold = 0

	B.SellFrameGreens.statusbar:SetValue(0)
	B.SellFrameGreens.statusbar:SetMinMaxValues(0, B.SellFrameGreens.Info.ProgressMax)
	B.SellFrameGreens.statusbar.ValueText:SetText("0 / "..B.SellFrameGreens.Info.ProgressMax)

	--Time to sell
	B.SellFrameGreens:Show()
end

function B:SetButtonTexture(button, texture)
	button:SetNormalTexture(texture)
	button:SetPushedTexture(texture)
	button:SetDisabledTexture(texture)

	local Normal, Pushed, Disabled = button:GetNormalTexture(), button:GetPushedTexture(), button:GetDisabledTexture()

	Normal:SetTexCoord(unpack(E.TexCoords))
	Normal:SetInside()

	Pushed:SetTexCoord(unpack(E.TexCoords))
	Pushed:SetInside()

	Disabled:SetTexCoord(unpack(E.TexCoords))
	Disabled:SetInside()
	Disabled:SetDesaturated(true)
end

function B:ConstructContainerFrame(name, isBank)
	local strata = E.db.bags.strata or "DIALOG"

	local f = CreateFrame("Button", name, E.UIParent)
	f:SetTemplate("Transparent")
	f:SetFrameStrata(strata)

	f:RegisterEvent("BAG_UPDATE") -- Has to be on both frames
	f:RegisterEvent("BAG_UPDATE_COOLDOWN") -- Has to be on both frames
	f.events = isBank and {"PLAYERBANKSLOTS_CHANGED"} or {"ITEM_LOCK_CHANGED", "ITEM_UNLOCKED", "QUEST_ACCEPTED", "QUEST_REMOVED", "QUEST_LOG_UPDATE"}

	for _, event in pairs(f.events) do
		f:RegisterEvent(event)
	end

	f:Hide()

	f.isBank = isBank
	f.bottomOffset = isBank and 8 or 28
	f.topOffset = isBank and 45 or 50
	f.BagIDs = isBank and {-1, 5, 6, 7, 8, 9, 10, 11} or {0, 1, 2, 3, 4}
	f.Bags = {}

	local mover = (isBank and ElvUIBankMover) or ElvUIBagMover
	if mover then
		f:Point(mover.POINT, mover)
		f.mover = mover
	end

	--Allow dragging the frame around
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton", "RightButton")
	f:RegisterForClicks("AnyUp")
	f:SetScript("OnEvent", B.OnEvent)
	f:SetScript("OnShow", B.RefreshSearch)
	f:SetScript("OnDragStart", function(frame) if IsShiftKeyDown() then frame:StartMoving() end end)
	f:SetScript("OnDragStop", function(frame) frame:StopMovingOrSizing() end)
	f:SetScript("OnClick", function(frame) if IsControlKeyDown() then B.PostBagMove(frame.mover) end end)
	f:SetScript("OnLeave", GameTooltip_Hide)
	f:SetScript("OnEnter", function(frame)
		GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT", 0, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine(L["Hold Shift + Drag:"], L["Temporary Move"], 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Hold Control + Right Click:"], L["Reset Position"], 1, 1, 1)
		GameTooltip:Show()
	end)

	f.closeButton = CreateFrame("Button", name.."CloseButton", f, "UIPanelCloseButton")
	f.closeButton:Point("TOPRIGHT", 0, 2)

	Skins:HandleCloseButton(f.closeButton)

	f.holderFrame = CreateFrame("Frame", nil, f)
	f.holderFrame:Point("TOP", f, "TOP", 0, -f.topOffset)
	f.holderFrame:Point("BOTTOM", f, "BOTTOM", 0, 8)

	f.ContainerHolder = CreateFrame("Button", name.."ContainerHolder", f)
	f.ContainerHolder:Point("BOTTOMLEFT", f, "TOPLEFT", 0, 1)
	f.ContainerHolder:SetTemplate("Transparent")
	f.ContainerHolder:Hide()

	if isBank then
		--Bag Text
		f.bagText = f:CreateFontString(nil, "OVERLAY")
		f.bagText:FontTemplate()
		f.bagText:Point("BOTTOMRIGHT", f.holderFrame, "TOPRIGHT", -2, 4)
		f.bagText:SetJustifyH("RIGHT")
		f.bagText:SetText(L["Bank"])

		-- Stack Button
		f.stackButton = CreateFrame("Button", name.."StackButton", f)
		f.stackButton:Size(16 + E.Border)
		f.stackButton:SetTemplate()
		f.stackButton:Point("RIGHT", f.bagText, "LEFT", -5, E.Border * 2)
		B:SetButtonTexture(f.stackButton, [[Interface\Cursor\Repair]])
		f.stackButton:StyleButton(nil, true)
		f.stackButton.ttText = L["Stack Items In Bank"]
		f.stackButton.ttText2 = L["Hold Shift:"]
		f.stackButton.ttText2desc = L["Stack Items To Bags"]
		f.stackButton:SetScript("OnEnter", B.Tooltip_Show)
		f.stackButton:SetScript("OnLeave", GameTooltip_Hide)
		f.stackButton:SetScript("OnClick", function()
			f:UnregisterAllEvents() --Unregister to prevent unnecessary updates
			if not f.registerUpdate then f.registerUpdate = true end
			if IsShiftKeyDown() then
				B:CommandDecorator(B.Stack, "bank bags")()
			else
				B:CommandDecorator(B.Compress, "bank")()
			end
		end)

		--Sort Button
		f.sortButton = CreateFrame("Button", name.."SortButton", f)
		f.sortButton:Size(16 + E.Border)
		f.sortButton:SetTemplate()
		f.sortButton:Point("RIGHT", f.stackButton, "LEFT", -5, 0)
		B:SetButtonTexture(f.sortButton, E.Media.Textures.Broom)
		f.sortButton:StyleButton(nil, true)
		f.sortButton.ttText = L["Sort Bags"]
		f.sortButton:SetScript("OnEnter", B.Tooltip_Show)
		f.sortButton:SetScript("OnLeave", GameTooltip_Hide)
		f.sortButton:SetScript("OnClick", function()
			f:UnregisterAllEvents() --Unregister to prevent unnecessary updates
			if not f.registerUpdate then
				B:SortingFadeBags(f, true)
			end
			B:CommandDecorator(B.SortBags, "bank")()
		end)
		if E.db.bags.disableBankSort then
			f.sortButton:Disable()
		end

		--Toggle Bags Button
		f.bagsButton = CreateFrame("Button", name.."BagsButton", f.holderFrame)
		f.bagsButton:Size(16 + E.Border)
		f.bagsButton:SetTemplate()
		f.bagsButton:Point("RIGHT", f.sortButton, "LEFT", -5, 0)
		B:SetButtonTexture(f.bagsButton, [[Interface\Buttons\Button-Backpack-Up]])
		f.bagsButton:StyleButton(nil, true)
		f.bagsButton.ttText = L["Toggle Bags"]
		f.bagsButton:SetScript("OnEnter", B.Tooltip_Show)
		f.bagsButton:SetScript("OnLeave", GameTooltip_Hide)
		f.bagsButton:SetScript("OnClick", function()
			local numSlots = GetNumBankSlots()
			PlaySound("igMainMenuOption")
			if numSlots >= 1 then
				ToggleFrame(f.ContainerHolder)
			else
				E:StaticPopup_Show("NO_BANK_BAGS")
			end
		end)

		--Purchase Bags Button
		f.purchaseBagButton = CreateFrame("Button", nil, f.holderFrame)
		f.purchaseBagButton:Size(16 + E.Border)
		f.purchaseBagButton:SetTemplate()
		f.purchaseBagButton:Point("RIGHT", f.bagsButton, "LEFT", -5, 0)
		B:SetButtonTexture(f.purchaseBagButton, [[Interface\Icons\INV_Misc_Coin_01]])
		f.purchaseBagButton:StyleButton(nil, true)
		f.purchaseBagButton.ttText = L["Purchase Bags"]
		f.purchaseBagButton:SetScript("OnEnter", B.Tooltip_Show)
		f.purchaseBagButton:SetScript("OnLeave", GameTooltip_Hide)
		f.purchaseBagButton:SetScript("OnClick", function()
			local _, full = GetNumBankSlots()
			if full then
				E:StaticPopup_Show("CANNOT_BUY_BANK_SLOT")
			else
				E:StaticPopup_Show("BUY_BANK_SLOT")
			end
		end)

		f:SetScript("OnShow", B.RefreshSearch)
		f:SetScript("OnHide", function()
			CloseBankFrame()

			if E.db.bags.clearSearchOnClose then
				B.ResetAndClear(f.editBox)
			end
		end)

		--Search
		f.editBox = CreateFrame("EditBox", name.."EditBox", f)
		f.editBox:FontTemplate()
		f.editBox:SetFrameLevel(f.editBox:GetFrameLevel() + 2)
		f.editBox:CreateBackdrop()
		f.editBox.backdrop:Point("TOPLEFT", f.editBox, "TOPLEFT", -20, 2)
		f.editBox:Height(15)
		f.editBox:Point("BOTTOMLEFT", f.holderFrame, "TOPLEFT", (E.Border * 2) + 18, E.Border * 2 + 2)
		f.editBox:Point("RIGHT", f.purchaseBagButton, "LEFT", -5, 0)
		f.editBox:SetAutoFocus(false)
		f.editBox:SetScript("OnEscapePressed", B.ResetAndClear)
		f.editBox:SetScript("OnEnterPressed", function(eb) eb:ClearFocus() end)
		f.editBox:SetScript("OnEditFocusGained", f.editBox.HighlightText)
		f.editBox:SetScript("OnTextChanged", B.UpdateSearch)
		f.editBox:SetScript("OnChar", B.UpdateSearch)
		f.editBox:SetText(SEARCH)

		f.editBox.searchIcon = f.editBox:CreateTexture(nil, "OVERLAY")
		f.editBox.searchIcon:SetTexture([[Interface\Common\UI-Searchbox-Icon]])
		f.editBox.searchIcon:Point("LEFT", f.editBox.backdrop, "LEFT", E.Border + 1, -1)
		f.editBox.searchIcon:Size(15)
	else
		--Gold Text
		f.goldText = f:CreateFontString(nil, "OVERLAY")
		f.goldText:FontTemplate()
		f.goldText:Point("BOTTOMRIGHT", f.holderFrame, "TOPRIGHT", -2, 4)
		f.goldText:SetJustifyH("RIGHT")

		-- Stack Button
		f.stackButton = CreateFrame("Button", name.."StackButton", f)
		f.stackButton:Size(16 + E.Border)
		f.stackButton:SetTemplate()
		f.stackButton:Point("RIGHT", f.goldText, "LEFT", -5, E.Border * 2)
		B:SetButtonTexture(f.stackButton, [[Interface\Cursor\Repair]])
		f.stackButton:StyleButton(nil, true)
		f.stackButton.ttText = L["Stack Items In Bags"]
		f.stackButton.ttText2 = L["Hold Shift:"]
		f.stackButton.ttText2desc = L["Stack Items To Bank"]
		f.stackButton:SetScript("OnEnter", B.Tooltip_Show)
		f.stackButton:SetScript("OnLeave", GameTooltip_Hide)
		f.stackButton:SetScript("OnClick", function()
			f:UnregisterAllEvents() --Unregister to prevent unnecessary updates
			if not f.registerUpdate then f.registerUpdate = true end
			if IsShiftKeyDown() then
				B:CommandDecorator(B.Stack, "bags bank")()
			else
				B:CommandDecorator(B.Compress, "bags")()
			end
		end)

		--Sort Button
		f.sortButton = CreateFrame("Button", name.."SortButton", f)
		f.sortButton:Size(16 + E.Border)
		f.sortButton:SetTemplate()
		f.sortButton:Point("RIGHT", f.stackButton, "LEFT", -5, 0)
		B:SetButtonTexture(f.sortButton, E.Media.Textures.Broom)
		f.sortButton:StyleButton(nil, true)
		f.sortButton.ttText = L["Sort Bags"]
		f.sortButton:SetScript("OnEnter", B.Tooltip_Show)
		f.sortButton:SetScript("OnLeave", GameTooltip_Hide)
		f.sortButton:SetScript("OnClick", function()
			f:UnregisterAllEvents() --Unregister to prevent unnecessary updates
			if not f.registerUpdate then B:SortingFadeBags(f, true) end
			B:CommandDecorator(B.SortBags, "bags")()
		end)
		if E.db.bags.disableBagSort then
			f.sortButton:Disable()
		end

		--Bags Button
		f.bagsButton = CreateFrame("Button", name.."BagsButton", f)
		f.bagsButton:Size(16 + E.Border)
		f.bagsButton:SetTemplate()
		f.bagsButton:Point("RIGHT", f.sortButton, "LEFT", -5, 0)
		B:SetButtonTexture(f.bagsButton, [[Interface\Buttons\Button-Backpack-Up]])
		f.bagsButton:StyleButton(nil, true)
		f.bagsButton.ttText = L["Toggle Bags"]
		f.bagsButton:SetScript("OnEnter", B.Tooltip_Show)
		f.bagsButton:SetScript("OnLeave", GameTooltip_Hide)
		f.bagsButton:SetScript("OnClick", function() ToggleFrame(f.ContainerHolder) end)

		--Vendor Grays
		f.vendorGraysButton = CreateFrame("Button", nil, f.holderFrame)
		f.vendorGraysButton:Size(16 + E.Border)
		f.vendorGraysButton:SetTemplate()
		f.vendorGraysButton:Point("RIGHT", f.bagsButton, "LEFT", -5, 0)
		B:SetButtonTexture(f.vendorGraysButton, [[Interface\Icons\INV_Misc_Coin_01]])
		f.vendorGraysButton:StyleButton(nil, true)
		f.vendorGraysButton.ttText = L["Vendor / Delete Grays"]
		f.vendorGraysButton.ttValue = B.GetGraysValue
		f.vendorGraysButton:SetScript("OnEnter", B.Tooltip_Show)
		f.vendorGraysButton:SetScript("OnLeave", GameTooltip_Hide)
		f.vendorGraysButton:SetScript("OnClick", B.VendorGrayCheck)

		--Search
		f.editBox = CreateFrame("EditBox", name.."EditBox", f)
		f.editBox:SetFrameLevel(f.editBox:GetFrameLevel() + 2)
		f.editBox:CreateBackdrop()
		f.editBox.backdrop:Point("TOPLEFT", f.editBox, "TOPLEFT", -20, 2)
		f.editBox:Height(15)
		f.editBox:Point("BOTTOMLEFT", f.holderFrame, "TOPLEFT", (E.Border * 2) + 18, E.Border * 2 + 2)
		f.editBox:Point("RIGHT", f.vendorGraysButton, "LEFT", -5, 0)
		f.editBox:SetAutoFocus(false)
		f.editBox:SetScript("OnEscapePressed", B.ResetAndClear)
		f.editBox:SetScript("OnEnterPressed", function(eb) eb:ClearFocus() end)
		f.editBox:SetScript("OnEditFocusGained", f.editBox.HighlightText)
		f.editBox:SetScript("OnTextChanged", B.UpdateSearch)
		f.editBox:SetScript("OnChar", B.UpdateSearch)
		f.editBox:SetText(SEARCH)
		f.editBox:FontTemplate()

		f.editBox.searchIcon = f.editBox:CreateTexture(nil, "OVERLAY")
		f.editBox.searchIcon:SetTexture([[Interface\Common\UI-Searchbox-Icon]])
		f.editBox.searchIcon:Point("LEFT", f.editBox.backdrop, "LEFT", E.Border + 1, -1)
		f.editBox.searchIcon:Size(15)

		--Currency
		f.currencyButton = CreateFrame("Frame", nil, f)
		f.currencyButton:Point("BOTTOM", 0, 4)
		f.currencyButton:Point("TOPLEFT", f.holderFrame, "BOTTOMLEFT", 0, 18)
		f.currencyButton:Point("TOPRIGHT", f.holderFrame, "BOTTOMRIGHT", 0, 18)
		f.currencyButton:Height(22)

		for i = 1, MAX_WATCHED_TOKENS do
			f.currencyButton[i] = CreateFrame("Button", f:GetName().."CurrencyButton"..i, f.currencyButton)
			f.currencyButton[i]:Size(16)
			f.currencyButton[i]:SetTemplate()
			f.currencyButton[i]:SetID(i)
			f.currencyButton[i].icon = f.currencyButton[i]:CreateTexture(nil, "OVERLAY")
			f.currencyButton[i].icon:SetInside()
			f.currencyButton[i].icon:SetTexCoord(unpack(E.TexCoords))
			f.currencyButton[i].text = f.currencyButton[i]:CreateFontString(nil, "OVERLAY")
			f.currencyButton[i].text:Point("LEFT", f.currencyButton[i], "RIGHT", 2, 0)
			f.currencyButton[i].text:FontTemplate()

			f.currencyButton[i]:SetScript("OnEnter", B.Token_OnEnter)
			f.currencyButton[i]:SetScript("OnLeave", GameTooltip_Hide)
			f.currencyButton[i]:SetScript("OnClick", B.Token_OnClick)
			f.currencyButton[i]:Hide()
		end

		f:SetScript("OnHide", function()
			CloseBackpack()
			for i = 1, NUM_BAG_FRAMES do
				CloseBag(i)
			end

			if ElvUIBags and ElvUIBags.buttons then
				for _, bagButton in pairs(ElvUIBags.buttons) do
					bagButton:SetChecked(false)
				end
			end

			if E.db.bags.clearSearchOnClose then
				B.ResetAndClear(f.editBox)
			end
		end)
	end

	tinsert(UISpecialFrames, f:GetName()) --Keep an eye on this for taints..
	tinsert(B.BagFrames, f)
	return f
end

function B:ToggleBags(id)
	if id and (GetContainerNumSlots(id) == 0) then return end

	if B.BagFrame:IsShown() then
		B:CloseBags()
	else
		B:OpenBags()
	end
end

function B:ToggleBackpack()
	if IsOptionFrameOpen() then return end

	if IsBagOpen(0) then
		B:OpenBags()
		PlaySound("igBackPackOpen")
	else
		B:CloseBags()
		PlaySound("igBackPackClose")
	end
end

function B:OpenAllBags(frame)
	local mail = frame == MailFrame and frame:IsShown()
	local vendor = frame == MerchantFrame and frame:IsShown()

	if (not mail and not vendor) or (mail and B.db.autoToggle.mail) or (vendor and B.db.autoToggle.vendor) then
		B:OpenBags()
	else
		B:CloseBags()
	end

end

function B:ToggleSortButtonState(isBank)
	local button, disable
	if isBank and B.BankFrame then
		button = B.BankFrame.sortButton
		disable = E.db.bags.disableBankSort
	elseif not isBank and B.BagFrame then
		button = B.BagFrame.sortButton
		disable = E.db.bags.disableBagSort
	end

	if button and disable then
		button:Disable()
	elseif button and not disable then
		button:Enable()
	end
end

function B:OpenBags()
	B.BagFrame:Show()

	TT:GameTooltip_SetDefaultAnchor(GameTooltip)
end

function B:CloseBags()
	B.BagFrame:Hide()

	if B.BankFrame then
		B.BankFrame:Hide()
	end

	TT:GameTooltip_SetDefaultAnchor(GameTooltip)
end

function B:OpenBank()
	if not B.BankFrame then
		B.BankFrame = B:ConstructContainerFrame("ElvUI_BankContainerFrame", true)
	end

	--Call :Layout first so all elements are created before we update
	B:Layout(true)

	if B.db.autoToggle.bank then
		B:OpenBags()
		B:UpdateTokens()
	end

	B.BankFrame:Show()
end

function B:PLAYERBANKBAGSLOTS_CHANGED()
	B:Layout(true)
end

function B:GuildBankFrame_Update()
	B:SetGuildBankSearch(SEARCH_STRING)
end

function B:CloseBank()
	if not B.BankFrame then return end

	B.BankFrame:Hide()
	B.BagFrame:Hide()
end

function B:GUILDBANKFRAME_OPENED(event)
	if GuildItemSearchBox then
		GuildItemSearchBox:SetScript("OnEscapePressed", B.ResetAndClear)
		GuildItemSearchBox:SetScript("OnEnterPressed", function(sb) sb:ClearFocus() end)
		GuildItemSearchBox:SetScript("OnEditFocusGained", GuildItemSearchBox.HighlightText)
		GuildItemSearchBox:SetScript("OnTextChanged", B.UpdateSearch)
		GuildItemSearchBox:SetScript("OnChar", B.UpdateSearch)
	end

	hooksecurefunc("GuildBankFrame_Update", B.GuildBankFrame_Update)

	B:UnregisterEvent(event)
end

function B:PlayerEnteringWorld()
	B:UpdateBagTypes()
	B:Layout()
end

function B:PLAYER_ENTERING_WORLD()
	B:UpdateGoldText()
	
	-- Update bag types for bagslot coloring
	E:Delay(2, B.PlayerEnteringWorld)
end

function B:updateContainerFrameAnchors()
	local xOffset, yOffset, screenHeight, freeScreenHeight, leftMostPoint, column
	local screenWidth = GetScreenWidth()
	local containerScale = 1
	local leftLimit = 0

	if BankFrame:IsShown() then
		leftLimit = BankFrame:GetRight() - 25
	end

	while containerScale > CONTAINER_SCALE do
		screenHeight = GetScreenHeight() / containerScale
		-- Adjust the start anchor for bags depending on the multibars
		xOffset = CONTAINER_OFFSET_X / containerScale
		yOffset = CONTAINER_OFFSET_Y / containerScale
		-- freeScreenHeight determines when to start a new column of bags
		freeScreenHeight = screenHeight - yOffset
		leftMostPoint = screenWidth - xOffset
		column = 1

		for _, frameName in ipairs(ContainerFrame1.bags) do
			local frameHeight = _G[frameName]:GetHeight()

			if freeScreenHeight < frameHeight then
				-- Start a new column
				column = column + 1
				leftMostPoint = screenWidth - (column * CONTAINER_WIDTH * containerScale) - xOffset
				freeScreenHeight = screenHeight - yOffset
			end

			freeScreenHeight = freeScreenHeight - frameHeight - VISIBLE_CONTAINER_SPACING
		end

		if leftMostPoint < leftLimit then
			containerScale = containerScale - 0.01
		else
			break
		end
	end

	if containerScale < CONTAINER_SCALE then
		containerScale = CONTAINER_SCALE
	end

	screenHeight = GetScreenHeight() / containerScale
	-- Adjust the start anchor for bags depending on the multibars
	-- xOffset = CONTAINER_OFFSET_X / containerScale
	yOffset = CONTAINER_OFFSET_Y / containerScale
	-- freeScreenHeight determines when to start a new column of bags
	freeScreenHeight = screenHeight - yOffset
	column = 0

	local bagsPerColumn = 0
	for index, frameName in ipairs(ContainerFrame1.bags) do
		local frame = _G[frameName]
		frame:SetScale(1)

		if index == 1 then
			-- First bag
			frame:Point("BOTTOMRIGHT", ElvUIBagMover, "BOTTOMRIGHT", E.Spacing, -E.Border)
			bagsPerColumn = bagsPerColumn + 1
		elseif freeScreenHeight < frame:GetHeight() then
			-- Start a new column
			column = column + 1
			freeScreenHeight = screenHeight - yOffset
			if column > 1 then
				frame:Point("BOTTOMRIGHT", ContainerFrame1.bags[(index - bagsPerColumn) - 1], "BOTTOMLEFT", -CONTAINER_SPACING, 0)
			else
				frame:Point("BOTTOMRIGHT", ContainerFrame1.bags[index - bagsPerColumn], "BOTTOMLEFT", -CONTAINER_SPACING, 0)
			end
			bagsPerColumn = 0
		else
			-- Anchor to the previous bag
			frame:Point("BOTTOMRIGHT", ContainerFrame1.bags[index - 1], "TOPRIGHT", 0, CONTAINER_SPACING)
			bagsPerColumn = bagsPerColumn + 1
		end

		freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING
	end
end

function B:PostBagMove()
	if not E.private.bags.enable then return end

	-- self refers to the mover (bag or bank)
	local x, y = self:GetCenter()
	local screenHeight = E.UIParent:GetTop()
	local screenWidth = E.UIParent:GetRight()

	if y > (screenHeight / 2) then
		self:SetText(self.textGrowDown)
		self.POINT = ((x > (screenWidth / 2)) and "TOPRIGHT" or "TOPLEFT")
	else
		self:SetText(self.textGrowUp)
		self.POINT = ((x > (screenWidth / 2)) and "BOTTOMRIGHT" or "BOTTOMLEFT")
	end

	local bagFrame
	if self.name == "ElvUIBankMover" then
		bagFrame = B.BankFrame
	else
		bagFrame = B.BagFrame
	end

	if bagFrame then
		bagFrame:ClearAllPoints()
		bagFrame:Point(self.POINT, self)
	end
end

function B:CHAT_MSG_LOOT(event, arg)
if InCombatLockdown() and B.db.autosort then return E:Print("Notice: Auto sort disabled while in Combat.") end

if B.db.autosort then
local lootrecievedmsg = strmatch(arg, "You receive loot:")
if lootrecievedmsg == nil then return end

if B.SortUpdateTimer:IsShown() then return end

local sName, sLink, iRarity, iLevel, iMinLevel, sType, sSubType, iStackCount = GetItemInfo(arg)
local iName = sName
local iType = sType
local iSubType = sSubType
local StackCount = iStackCount

if iType == nil then
iType = "|CFFD9655DNii"
end

if iSubType == nil then
iSubType = "|CFFD9655DNii"
end

if StackCount == nil then
StackCount = "|CFFD9655DNii"
end

if iName == nil then
iName = "|CFFD9655DNii"
end
local scanTooltip

	local itemID = B:ConvertLinkToID(sLink)
	if itemID then	
	
		if not scanTooltip then
		scanTooltip = CreateFrame("GameTooltip", "soulboundScanTooltip", UIParent, "GameTooltipTemplate")
		scanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
		end
		
		scanTooltip:ClearLines()
		scanTooltip:SetHyperlink("item:"..itemID)
		
		
			if iType == "Weapon" or iType == "Armor" then 
					for id=1, scanTooltip:NumLines() do
						local text = _G["soulboundScanTooltipTextLeft" .. id]
			
						if text then
							if id == 2 then
								if (text:GetText() == ITEM_SOULBOUND) or (text:GetText() == ITEM_BIND_ON_PICKUP) then 
									return 
								end
							end
						end
					end
				elseif iSubType == "Questitem" or iSubType == "Gem" or iSubType == "Key" or iSubType == "Container" or iSubType == "Enchanting" then 
						return
				else
						SkulySort_Timer=myAceTimer:ScheduleTimer(SkulySort, 0.2)
				end
		end
	end
end

function B:LOOT_CLOSED()
	if not B.db.autosort then
		if (E.db.bags.deleteGrays.enable or E.db.bags.deleteGrays.junkList) then
			GrayDelete_Timer=myAceTimer:ScheduleTimer(DeleteGrays, 0.6)
		end
	end
end

function B:MERCHANT_CLOSED()
	B.SellFrame:Hide()

	twipe(B.SellFrame.Info.itemList)
	B.SellFrame.Info.delete = false
	B.SellFrame.Info.ProgressTimer = 0
	B.SellFrame.Info.SellInterval = E.db.bags.vendorGrays.interval
	B.SellFrame.Info.GreensSellInterval = E.db.bags.vendorGreens.interval
	B.SellFrame.Info.ProgressMax = 0
	B.SellFrame.Info.goldGained = 0
	B.SellFrame.Info.itemsSold = 0
	
	B.SellFrameGreens:Hide()

	twipe(B.SellFrameGreens.Info.itemList)
	B.SellFrameGreens.Info.delete = false
	B.SellFrameGreens.Info.ProgressTimer = 0
	B.SellFrameGreens.Info.SellInterval = E.db.bags.vendorGrays.interval
	B.SellFrameGreens.Info.GreensSellInterval = E.db.bags.vendorGreens.interval
	B.SellFrameGreens.Info.ProgressMax = 0
	B.SellFrameGreens.Info.goldGained = 0
	B.SellFrameGreens.Info.itemsSold = 0
	
end

function B:ProgressQuickVendor()
	local item = B.SellFrame.Info.itemList[1]
	if not item then return nil, true end --No more to sell
	local bag, slot, itemPrice, link = unpack(item)

	local stackPrice = 0
	if B.SellFrame.Info.delete then
		PickupContainerItem(bag, slot)
		DeleteCursorItem()
	else
		local stackCount = select(2, GetContainerItemInfo(bag, slot)) or 1
		stackPrice = (itemPrice or 0) * stackCount
		if E.db.bags.vendorGrays.details and link then
			E:Print(format("%s|cFF00DDDDx%d|r %s", link, stackCount, E:FormatMoney(stackPrice, E.db.bags.moneyFormat, not E.db.bags.moneyCoins)))
		end
		UseContainerItem(bag, slot)
	end

	tremove(B.SellFrame.Info.itemList, 1)

	return stackPrice
end

function B:ProgressQuickVendorGreens()
	local item = B.SellFrameGreens.Info.itemList[1]
	if not item then return nil, true end --No more to sell
	local bag, slot, itemPrice, link = unpack(item)

	local stackPrice = 0
	local stackCount = select(2, GetContainerItemInfo(bag, slot)) or 1
		stackPrice = (itemPrice or 0) * stackCount
		 if E.db.bags.vendorGreens.details and link then
			 E:Print(format("%s|cFF00DDDDx%d|r %s", link, stackCount, E:FormatMoney(stackPrice, E.db.bags.moneyFormat, not E.db.bags.moneyCoins)))
		 end
		UseContainerItem(bag, slot)

	tremove(B.SellFrameGreens.Info.itemList, 1)

	return stackPrice
end

function B:VendorGreys_OnUpdate(elapsed)
	B.SellFrame.Info.ProgressTimer = B.SellFrame.Info.ProgressTimer - elapsed
	if B.SellFrame.Info.ProgressTimer > 0 then return end
	B.SellFrame.Info.ProgressTimer = B.SellFrame.Info.SellInterval

	local goldGained, lastItem = B:ProgressQuickVendor()
	if goldGained then
		B.SellFrame.Info.goldGained = B.SellFrame.Info.goldGained + goldGained
		B.SellFrame.Info.itemsSold = B.SellFrame.Info.itemsSold + 1
		B.SellFrame.statusbar:SetValue(B.SellFrame.Info.itemsSold)
		local timeLeft = (B.SellFrame.Info.ProgressMax - B.SellFrame.Info.itemsSold)*B.SellFrame.Info.SellInterval
		B.SellFrame.statusbar.ValueText:SetText(B.SellFrame.Info.itemsSold.." / "..B.SellFrame.Info.ProgressMax.." ( "..timeLeft.."s )")
	elseif lastItem then
		B.SellFrame:Hide()
		if B.SellFrame.Info.goldGained > 0 then
			E:Print((L["Vendored items for: %s"]):format(E:FormatMoney(B.SellFrame.Info.goldGained, E.db.bags.moneyFormat, not E.db.bags.moneyCoins)))
		end
	end
end

function B:VendorGreens_OnUpdate(elapsed)
	B.SellFrameGreens.Info.ProgressTimer = B.SellFrameGreens.Info.ProgressTimer - elapsed
	if B.SellFrameGreens.Info.ProgressTimer > 0 then return end
	B.SellFrameGreens.Info.ProgressTimer = B.SellFrameGreens.Info.SellInterval

	local goldGained, lastItem = B:ProgressQuickVendorGreens()
	if goldGained then
		B.SellFrameGreens.Info.goldGained = B.SellFrameGreens.Info.goldGained + goldGained
		B.SellFrameGreens.Info.itemsSold = B.SellFrameGreens.Info.itemsSold + 1
		B.SellFrameGreens.statusbar:SetValue(B.SellFrameGreens.Info.itemsSold)
		local timeLeft = (B.SellFrameGreens.Info.ProgressMax - B.SellFrameGreens.Info.itemsSold)*B.SellFrameGreens.Info.SellInterval
		B.SellFrameGreens.statusbar.ValueText:SetText(B.SellFrameGreens.Info.itemsSold.." / "..B.SellFrameGreens.Info.ProgressMax.." ( "..timeLeft.."s )")
	elseif lastItem then
		B.SellFrameGreens:Hide()
		if B.SellFrameGreens.Info.goldGained > 0 then
			E:Print((L["Vendored items for: %s"]):format(E:FormatMoney(B.SellFrameGreens.Info.goldGained, E.db.bags.moneyFormat, not E.db.bags.moneyCoins)))
		end
	end
end


function B:CreateSellFrame()
	B.SellFrame = CreateFrame("Frame", "ElvUIVendorGraysFrame", E.UIParent)
	B.SellFrame:Size(200, 40)
	B.SellFrame:Point("CENTER", E.UIParent)
	B.SellFrame:CreateBackdrop("Transparent")
	B.SellFrame:SetAlpha(E.db.bags.vendorGrays.progressBar and 1 or 0)

	B.SellFrame.title = B.SellFrame:CreateFontString(nil, "OVERLAY")
	B.SellFrame.title:FontTemplate(nil, 12, "OUTLINE")
	B.SellFrame.title:Point("TOP", B.SellFrame, "TOP", 0, -2)
	B.SellFrame.title:SetText(L["Vendoring Grays"])

	B.SellFrame.statusbar = CreateFrame("StatusBar", "ElvUIVendorGraysFrameStatusbar", B.SellFrame)
	B.SellFrame.statusbar:Size(180, 16)
	B.SellFrame.statusbar:Point("BOTTOM", B.SellFrame, "BOTTOM", 0, 4)
	B.SellFrame.statusbar:SetStatusBarTexture(E.media.normTex)
	B.SellFrame.statusbar:SetStatusBarColor(1, 0, 0)
	B.SellFrame.statusbar:CreateBackdrop("Transparent")

	B.SellFrame.statusbar.anim = CreateAnimationGroup(B.SellFrame.statusbar)
	B.SellFrame.statusbar.anim.progress = B.SellFrame.statusbar.anim:CreateAnimation("Progress")
	B.SellFrame.statusbar.anim.progress:SetEasing("Out")
	B.SellFrame.statusbar.anim.progress:SetDuration(0.3)

	B.SellFrame.statusbar.ValueText = B.SellFrame.statusbar:CreateFontString(nil, "OVERLAY")
	B.SellFrame.statusbar.ValueText:FontTemplate(nil, 12, "OUTLINE")
	B.SellFrame.statusbar.ValueText:Point("CENTER", B.SellFrame.statusbar)
	B.SellFrame.statusbar.ValueText:SetText("0 / 0 ( 0s )")

	B.SellFrame.Info = {
		delete = false,
		ProgressTimer = 0,
		SellInterval = E.db.bags.vendorGrays.interval,
		ProgressMax = 0,
		goldGained = 0,
		itemsSold = 0,
		itemList = {}
	}

	B.SellFrame:SetScript("OnUpdate", B.VendorGreys_OnUpdate)

	B.SellFrame:Hide()
end

function B:CreateSellFrameGreens()
	B.SellFrameGreens = CreateFrame("Frame", "ElvUIVendorGraysFrame", E.UIParent)
	B.SellFrameGreens:Size(200, 40)
	B.SellFrameGreens:Point("CENTER", E.UIParent)
	B.SellFrameGreens:CreateBackdrop("Transparent")
	B.SellFrameGreens:SetAlpha(E.db.bags.vendorGrays.progressBar and 1 or 0)

	B.SellFrameGreens.title = B.SellFrameGreens:CreateFontString(nil, "OVERLAY")
	B.SellFrameGreens.title:FontTemplate(nil, 12, "OUTLINE")
	B.SellFrameGreens.title:Point("TOP", B.SellFrameGreens, "TOP", 0, -2)
	B.SellFrameGreens.title:SetText(L["Vendoring Grays"])

	B.SellFrameGreens.statusbar = CreateFrame("StatusBar", "ElvUIVendorGraysFrameStatusbar", B.SellFrameGreens)
	B.SellFrameGreens.statusbar:Size(180, 16)
	B.SellFrameGreens.statusbar:Point("BOTTOM", B.SellFrameGreens, "BOTTOM", 0, 4)
	B.SellFrameGreens.statusbar:SetStatusBarTexture(E.media.normTex)
	B.SellFrameGreens.statusbar:SetStatusBarColor(1, 0, 0)
	B.SellFrameGreens.statusbar:CreateBackdrop("Transparent")

	B.SellFrameGreens.statusbar.anim = CreateAnimationGroup(B.SellFrameGreens.statusbar)
	B.SellFrameGreens.statusbar.anim.progress = B.SellFrameGreens.statusbar.anim:CreateAnimation("Progress")
	B.SellFrameGreens.statusbar.anim.progress:SetEasing("Out")
	B.SellFrameGreens.statusbar.anim.progress:SetDuration(0.3)

	B.SellFrameGreens.statusbar.ValueText = B.SellFrameGreens.statusbar:CreateFontString(nil, "OVERLAY")
	B.SellFrameGreens.statusbar.ValueText:FontTemplate(nil, 12, "OUTLINE")
	B.SellFrameGreens.statusbar.ValueText:Point("CENTER", B.SellFrameGreens.statusbar)
	B.SellFrameGreens.statusbar.ValueText:SetText("0 / 0 ( 0s )")

	B.SellFrameGreens.Info = {
		delete = false,
		ProgressTimer = 0,
		SellInterval = E.db.bags.vendorGreens.interval,
		ProgressMax = 0,
		goldGained = 0,
		itemsSold = 0,
		itemList = {}
	}

	B.SellFrameGreens:SetScript("OnUpdate", B.VendorGreens_OnUpdate)

	B.SellFrameGreens:Hide()
end


function B:UpdateSellFrameSettings()
	if not B.SellFrame or not B.SellFrame.Info then return end

	B.SellFrame.Info.SellInterval = E.db.bags.vendorGrays.interval
	B.SellFrame:SetAlpha(E.db.bags.vendorGrays.progressBar and 1 or 0)
end

function B:UpdateGreensSellFrameSettings()
	if not B.SellFrameGreens or not B.SellFrameGreens.Info then return end
	
	includesoulbound = E.db.bags.vendorGreens.sellsoubound
	sellvalueNum = E.db.bags.vendorGreens.sellvalue
	B.SellFrameGreens.Info.GreensSellInterval = E.db.bags.vendorGreens.interval
	B.SellFrameGreens:SetAlpha(E.db.bags.vendorGreens.progressBar and 1 or 0)
end

StaticPopupDialogs["SKULYOUTPUT"] = {
	text = "%s",
	button1 = "OK",
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

function B:Skulychatoutput()
	deletevalueNum = E.db.bags.deleteGrays.deletevalue
	local testvalue = deletevalueNum * 100
	local sendtopopup = GetCoinTextureString(testvalue)
	StaticPopup_Show ("SKULYOUTPUT", sendtopopup)
end

function SkulySort()
if InCombatLockdown() then return end
if B.SortUpdateTimer:IsShown() then return end
B.BagFrame.sortButton:Click()
end

function DeleteGrays()
B:DeleteGrays()
end

function B:DeleteGrays(delete)
if B.SortUpdateTimer:IsShown() then return end

deleteList = E.db.bags.deleteItems
local totalsum = B:deleteListCount()

	if E.db.bags.deleteGrays.enable then
		for bag = 0, 5, 1 do
			for slot = 1, GetContainerNumSlots(bag), 1 do
				local itemID = GetContainerItemID(bag, slot)
				if itemID then
					local _, name, rarity, _, _, iType, _, itemStackCount, _, _, itemPrice = GetItemInfo(itemID)
					local stackCount = select(2, GetContainerItemInfo(bag, slot)) or 1
					local totalwithfullstack = itemPrice * stackCount
					deletevalueNum = E.db.bags.deleteGrays.deletevalue
						if (rarity and rarity == 0) and (iType and iType ~= "Quest") and (itemPrice < (deletevalueNum * 100)) then
							PickupContainerItem(bag, slot)
							DeleteCursorItem()
							if E.db.bags.deleteGrays.details then
							DEFAULT_CHAT_FRAME:AddMessage("|cFF00DDDD Deleted |r"..stackCount.."x "..name.." "..GetCoinTextureString(totalwithfullstack))
							end
						end	
				end
			end
		end
	end
	
	if E.db.bags.deleteGrays.junkList then
		if totalsum > 0 then
			for k,v in pairs(deleteList) do
				for bag = 0, 5, 1 do
					for slot = 1, GetContainerNumSlots(bag), 1 do
						local itemID = GetContainerItemID(bag, slot)
						if itemID then
								if  itemID == k then
									local stackCount = select(2, GetContainerItemInfo(bag, slot)) or 1
									local itemPrice = select(11, GetItemInfo(itemID))
									local iname, link = GetItemInfo(itemID)
									PickupContainerItem(bag, slot)
									DeleteCursorItem()
									if E.db.bags.deleteGrays.details then
									local itemtotalvalue = stackCount * itemPrice
										DEFAULT_CHAT_FRAME:AddMessage("|cFF00DDDD Deleted |r"..stackCount.."x "..link.." "..GetCoinTextureString(itemtotalvalue))
									end
								end
						end
					end
				end
			end
		end
	end
end

function B:UpdateDeleteGraySettings()
	deletevalueNum = E.db.bags.deleteGrays.deletevalue
end

function B:deleteListCount()
deleteList = E.db.bags.deleteItems
local sum = 0
for entry in pairs(deleteList) do
	sum = sum+1
end
return sum
end

function B:UpdateListAdd(value)
	deleteList = E.db.bags.deleteItems
end

function B:UpdateListRemove(value)
local item = select(2, GetItemInfo(value))
E:Print(item.." |CFFD4B961removed from your delete list.|r")
deleteList = E.db.bags.deleteItems
end

B.BagIndice = {
	leatherworking = 0x0008,
	inscription = 0x0010,
	herbs = 0x0020,
	enchanting = 0x0040,
	engineering = 0x0080,
	gems = 0x0200,
	mining = 0x0400,
	fishing = 0x8000,
}

B.QuestKeys = {
	questStarter = "questStarter",
	questItem = "questItem",
}

B.AutoToggleEvents = {
	guildBank = {GUILDBANKFRAME_OPENED = "OpenBags", GUILDBANKFRAME_CLOSED = "CloseBags"},
	auctionHouse = {AUCTION_HOUSE_SHOW = "OpenBags", AUCTION_HOUSE_CLOSED = "CloseBags"},
	professions = {TRADE_SKILL_SHOW = "OpenBags", TRADE_SKILL_CLOSE = "CloseBags"},
	trade = {TRADE_SHOW = "OpenBags", TRADE_CLOSED = "CloseBags"},
	voidStorage = {VOID_STORAGE_OPEN = "OpenBags", VOID_STORAGE_CLOSE = "CloseBags"}
}

function B:AutoToggle()
	for option, eventTable in next, B.AutoToggleEvents do
		for event, func in next, eventTable do
			if B.db.autoToggle[option] then
				B:RegisterEvent(event, func)
			else
				B:UnregisterEvent(event)
			end
		end
	end
end

function B:UpdateBagColors(table, indice, r, g, b)
	B[table][B.BagIndice[indice]] = {r, g, b}
end

function B:UpdateQuestColors(table, indice, r, g, b)
	B[table][B.QuestKeys[indice]] = {r, g, b}
end

function B:Initialize()
	B:LoadBagBar()

	--Creating vendor grays and greens frame
	B:CreateSellFrame()
	B:CreateSellFrameGreens()
	B:RegisterEvent("MERCHANT_CLOSED")
	
	--Delete Greys
	B:RegisterEvent("LOOT_CLOSED")
	--Auto Sort
	B:RegisterEvent("CHAT_MSG_LOOT")
	
	--Bag Mover (We want it created even if Bags module is disabled, so we can use it for default bags too)
	local BagFrameHolder = CreateFrame("Frame", nil, E.UIParent)
	BagFrameHolder:Width(200)
	BagFrameHolder:Height(22)
	BagFrameHolder:SetFrameLevel(BagFrameHolder:GetFrameLevel() + 400)

	if not E.private.bags.enable then
		-- Set a different default anchor
		BagFrameHolder:Point("BOTTOMRIGHT", RightChatPanel, "BOTTOMRIGHT", -(E.Border * 2), 22 + E.Border * 4 - E.Spacing * 2)
		E:CreateMover(BagFrameHolder, "ElvUIBagMover", L["Bag Mover"], nil, nil, B.PostBagMove, nil, nil, "bags,general")
		CONTAINER_SPACING = E.private.skins.blizzard.enable and E.private.skins.blizzard.bags and (E.Border * 2) or 0
		B:SecureHook("updateContainerFrameAnchors")
		return
	end

	B.Initialized = true
	
	B.db = E.db.bags

	B.BagFrames = {}
	B.ProfessionColors = {
		[0x0008] = {B.db.colors.profession.leatherworking.r, B.db.colors.profession.leatherworking.g, B.db.colors.profession.leatherworking.b},
		[0x0010] = {B.db.colors.profession.inscription.r, B.db.colors.profession.inscription.g, B.db.colors.profession.inscription.b},
		[0x0020] = {B.db.colors.profession.herbs.r, B.db.colors.profession.herbs.g, B.db.colors.profession.herbs.b},
		[0x0040] = {B.db.colors.profession.enchanting.r, B.db.colors.profession.enchanting.g, B.db.colors.profession.enchanting.b},
		[0x0080] = {B.db.colors.profession.engineering.r, B.db.colors.profession.engineering.g, B.db.colors.profession.engineering.b},
		[0x0200] = {B.db.colors.profession.gems.r, B.db.colors.profession.gems.g, B.db.colors.profession.gems.b},
		[0x0400] = {B.db.colors.profession.mining.r, B.db.colors.profession.mining.g, B.db.colors.profession.mining.b},
		[0x8000] = {B.db.colors.profession.fishing.r, B.db.colors.profession.fishing.g, B.db.colors.profession.fishing.b}
	}

	B.QuestColors = {
		questStarter = {B.db.colors.items.questStarter.r, B.db.colors.items.questStarter.g, B.db.colors.items.questStarter.b},
		questItem = {B.db.colors.items.questItem.r, B.db.colors.items.questItem.g, B.db.colors.items.questItem.b}
	}

	--Bag Mover: Set default anchor point and create mover
	BagFrameHolder:Point("BOTTOMRIGHT", RightChatPanel, "BOTTOMRIGHT", 0, 22 + E.Border * 4 - E.Spacing * 2)
	E:CreateMover(BagFrameHolder, "ElvUIBagMover", L["Bag Mover (Grow Up)"], nil, nil, B.PostBagMove, nil, nil, "bags,general")

	--Bank Mover
	local BankFrameHolder = CreateFrame("Frame", nil, E.UIParent)
	BankFrameHolder:Width(200)
	BankFrameHolder:Height(22)
	BankFrameHolder:Point("BOTTOMLEFT", LeftChatPanel, "BOTTOMLEFT", 0, 22 + E.Border * 4 - E.Spacing * 2)
	BankFrameHolder:SetFrameLevel(BankFrameHolder:GetFrameLevel() + 400)
	E:CreateMover(BankFrameHolder, "ElvUIBankMover", L["Bank Mover (Grow Up)"], nil, nil, B.PostBagMove, nil, nil, "bags,general")

	--Set some variables on movers
	ElvUIBagMover.textGrowUp = L["Bag Mover (Grow Up)"]
	ElvUIBagMover.textGrowDown = L["Bag Mover (Grow Down)"]
	ElvUIBagMover.POINT = "BOTTOM"
	ElvUIBankMover.textGrowUp = L["Bank Mover (Grow Up)"]
	ElvUIBankMover.textGrowDown = L["Bank Mover (Grow Down)"]
	ElvUIBankMover.POINT = "BOTTOM"

	--Create Containers
	B.BagFrame = B:ConstructContainerFrame("ElvUI_ContainerFrame")

	--Hook onto Blizzard Functions
	B:SecureHook("ToggleBackpack")
	B:SecureHook("OpenAllBags")
	B:SecureHook("CloseAllBags", "CloseBags")
	B:SecureHook("ToggleBag", "ToggleBags")
	B:SecureHook("ToggleAllBags", "ToggleBackpack")
	B:SecureHook("BackpackTokenFrame_Update", "UpdateTokens")
	B:Layout()

	B:DisableBlizzard()
	B:RegisterEvent("PLAYER_ENTERING_WORLD")
	B:RegisterEvent("PLAYER_MONEY", "UpdateGoldText")
	B:RegisterEvent("PLAYER_TRADE_MONEY", "UpdateGoldText")
	B:RegisterEvent("TRADE_MONEY_CHANGED", "UpdateGoldText")
	B:RegisterEvent("BANKFRAME_OPENED", "OpenBank")
	B:RegisterEvent("BANKFRAME_CLOSED", "CloseBank")
	B:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED")
	B:RegisterEvent("GUILDBANKFRAME_OPENED")
	
	deleteList = E.db.bags.deleteItems

	B:AutoToggle()
end

local function InitializeCallback()
	B:Initialize()
end

E:RegisterModule(B:GetName(), InitializeCallback)