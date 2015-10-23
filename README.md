A Witcher 3 mod sorting inventory tabs by usage.

#Alterations to the vanilla game

##Default tab selection

###When opening the menu

When opening the player inventory, the default tab is either the quest or the
usable tab instead of being always the weapon tab (vanilla).

Having at least one new (starred) unread document will prompt the quest tab
when opening the inventory. Otherwise, the inventory opens on the usable tab.

###When dealing with a merchant

Depending on the kind of merchant you deal, the inventory prompts the tab
containing items that are likely to be of some interest for the NPC:

- herbalist and alchemist: alchemy ingredient tab;
- innkeep: usable tab (food);
- bookseller: book tab;
- general: other tab (junk items);
- armorer, blacksmith and other unlisted kinds: weapon tab.

##Sorting items inside inventory tabs

The vanilla game allows to sort items according to some parameters including
the type, but the result is not often user friendly.

SIT splits items into categories, and sort these categories. Default sort order
is:

- usable tab: steel oil > silver oil > potion > decoction > bomb > other (food)
  > quest item (single use item);
- quest and book tabs: unread document > already read document > other;
- ingredient tab: alcohol (consumed by medidation) > alchemy ingredient >
  common mutagens > monster mutagen > crafting ingredient > other;
- other tab: currencies > other > junk;
- weapon tab: runes > glyphs > weapon tools > armor tools > steel swords >
  silver swords > crossbows > bolts for crossbows > armors (body part) > gloves
  > pants > boots > trophies > horse stuff > other items.

By default, inside each category, items are sorted by their localized name in
natural order (case insensitive). Following categories overrides this behavior:

- all categories in usable tab: by quality first (superior > enhanced >
  normal), in case of tie by the localized name;
- all categories in quest and book tabs: new (starred) items first, in case of
  tie by the the localized name;
- alcohols consumed by mutagen (alchemy tab): by priority (first displayed will
  be first consumed);
- common mutagens (alchemy tab): by quality first (greater > normal > lesser),
  in case of tie by the localized name;
- upgrades (runes and glyphs of the weapon tab): by quality first (greater >
  normal > lesser), in case of tie by the localized name;
- tools (weapons and armors repair kits of the weapon tab): by quality (master
  > journeyman > amateur);
- items spanning on 2 cells (weapon tab): by quality first (witcher > relic >
  magic > masteritem > normal), in case of tie by localized name.

When dealing with a merchant, items that can be sold are offered first sorted
by their localized name. On the weapon tabs, items spanning on two cells of low
quality and low price are offered first to enable to quickly unclutter the tab.

#Manual installation
Locate the `game install folder` (for instance `C:\GoG\The Witcher3`) on the
hard drive. This folder should contain a `bin` and `content` directories
amongst others.  Create a `mods` directory if it does not exist already.

Download a release archive and unpack it in your `game install folder/mods`
directory. The game engine will compile scripts when started (one time only).

#Compatibility

##The Witcher 3: The Wild Hunt

### Version 1.10 or 1.11

- [release 1.3.0][1.3.0] sorts all tabs. When dealing with a merchant prompt
  the tab that should contain items that are likely to interest that NPC;
- [release 1.2.2][1.2.2] sorts the content of all tabs but the weapon tab. When
  dealing with a merchant, items that can be sold have priority on other items
  (restores the vanilla game behavior);
- [release 1.2.1][1.2.1] sorts the content of the usable, quest and book tabs.
  Menu opens on quest or usable tab as explained in the [default tab
  selection](#default-tab-selection) section;
- [release 1.1.1][1.1.1] sorts the content of the usable, quest and book tabs.

###Version 1.08.4

- [release 1.0.1][1.0.1] sorts the content of the usable tab.

I have not enough time to test bug fixes and new features both on the version
1.10 and version 1.08 of the game. I made it simple to do it through
cherry-picking should a new release would be needed.

###Gamepad controller

As explained in [issue 2][issue_2], using a gamepad always trigger a quick sort
before showing the HUD content. Mod sort output is totally bypassed by the HUD
engine.

###Ingame quick sort and filter features

These features sorts the inventory using an algorithm coded inside action
scripts. At the moment, this mod cannot override the game logic set in action
scripts. Calling these features will always bypass this mod.

##Other mods

Refer to the documentation on the [Nexus site][nexus].

[1.3.0]: https://github.com/pbarnoux/modSortedInventoryTabs/releases/tag/1.3.0
[1.2.2]: https://github.com/pbarnoux/modSortedInventoryTabs/releases/tag/1.2.2
[1.2.1]: https://github.com/pbarnoux/modSortedInventoryTabs/releases/tag/1.2.1
[1.1.1]: https://github.com/pbarnoux/modSortedInventoryTabs/releases/tag/1.1.1
[1.0.1]: https://github.com/pbarnoux/modSortedInventoryTabs/releases/tag/1.0.1
[nexus]: http://www.nexusmods.com/witcher3/mods/770/?
[issue_2]: https://github.com/pbarnoux/modSortedInventoryTabs/issues/2
