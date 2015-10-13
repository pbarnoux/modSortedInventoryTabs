A Witcher 3 mod sorting inventory tabs by usage.

#Alterations to the vanilla game

##Default tab selection

When opening the player inventory, the default tab is either the quest or the
usable tab instead of being always the weapon tab (vanilla).

Having at least one new (starred) unread document will prompt the quest tab
when opening the inventory. Otherwise, the inventory opens on the usable tab.

##Sorting items inside inventory tabs

The vanilla game allows to sort items according to some parameters including
the type, but the result is not often user friendly.

SIT splits items into categories, and sort categories. Default sort order is:

- usable tab: steel oil > silver oil > potion > decoction > bomb > other (food)
  > quest item (single use item);
- quest and book tabs: unread document > already read document > other.

Inside each category, items are sorted according to some simple algorithm:

- usable tab: by quality first (superior > enhanced > normal), in case of tie
  by the localized name;
- quest and book tabs: new (starred) items first, in case of tie by the the
  localized name.

### Limitations

- Using the quick sort or the filter ingame functions will bypass SIT logic;
- Playing with a gamepad always trigger the quick sort function before showing
  items which means that SIT logic is always bypassed when playing with a
  gamepad.

#Manual installation
Locate the `game install folder` (for instance `C:\GoG\The Witcher3`) on the
hard drive. This folder should contain a `bin` and `content` directories
amongst others.  Create a `mods` directory if it does not exist already.

Download a release archive and unpack it in your `game install folder/mods`
directory. The game engine will compile scripts when started (one time only).

#Compatibility

##The Witcher 3: The Wild Hunt

### Version 1.10

- [release 1.2.1][1.2.1] sorts the content of the usable, quest and book tabs.
  Menu opens on quest or usable tab as explained in the [default tab
  selection][tab_select] section:
- [release 1.1.1][1.1.1] sorts the content of the usable, quest and book tabs.

###Version 1.08.4

- [release 1.0.1][1.0.1] sorts the content of the usable tab.

I have not enough time to test bug fixes and new features both on the version
1.10 and version 1.08 of the game. I made it simple to do it through
cherry-picking should a new release would be needed.

##Other mods

Refer to the documentation on the [Nexus site][nexus].

[1.2.1]: https://github.com/pbarnoux/modSortedInventoryTabs/releases/tag/1.2.1
[1.1.1]: https://github.com/pbarnoux/modSortedInventoryTabs/releases/tag/1.1.1
[1.0.1]: https://github.com/pbarnoux/modSortedInventoryTabs/releases/tag/1.0.1
[nexus]: http://www.nexusmods.com/witcher3/mods/770/?
