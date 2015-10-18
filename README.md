A Witcher 3 mod sorting inventory tabs by usage.

This branch tracks changes in
[FriendlyHUD](http://www.nexusmods.com/witcher3/mods/365/?) mod to ensure both
mods are compatible by removing the sorting logic of FriendlyHUD.

There are no release for this branch, it always matches the latest release on
master.

#Alterations to the vanilla game

##Default tab selection

When opening the player inventory, the default tab is either the quest or the
usable tab instead of being always the weapon tab (vanilla).

Having at least one new (starred) unread document will prompt the quest tab
when opening the inventory. Otherwise, the inventory opens on the usable tab.

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
- other tab: currencies > other > junk.

By default, inside each category, items are sorted by their localized name in
natural order (case insensitive). Following categories overrides this behavior:

- all categories in usable tab: by quality first (superior > enhanced >
  normal), in case of tie by the localized name;
- all categories in quest and book tabs: new (starred) items first, in case of
  tie by the the localized name;
- alcohols consumed by mutagen (alchemy tab): by priority (first displayed will
  be first consumed);
- common mutagens (alchemy tab): by quality first (greater > normal > lesser),
  in case of tie by the localized name.

#Manual installation
Locate the `game install folder` (for instance `C:\GoG\The Witcher3`) on the
hard drive. This folder should contain a `bin` and `content` directories
amongst others.  Create a `mods` directory if it does not exist already.

Download a release archive and unpack it in your `game install folder/mods`
directory. The game engine will compile scripts when started (one time only).

#Compatibility

##The Witcher 3: The Wild Hunt

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

[nexus]: http://www.nexusmods.com/witcher3/mods/770/?
[issue_2]: https://github.com/pbarnoux/modSortedInventoryTabs/issues/2
