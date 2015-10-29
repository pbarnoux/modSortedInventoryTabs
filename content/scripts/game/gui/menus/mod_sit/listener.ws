/*
Mod entry point when not dealing with a NPC.
Notified when some methods are triggered in base scripts.
*/
class SitListener
{
	public function Initialize(): void
	{
	}

	/*
	Entry point called from PopulateTabData in inventoryMenu.ws.
	*/
	public function OnPopulateTabData( tabIndex: int, sortables: array < SitSortable >, out entriesArray: CScriptedFlashArray ): void
	{
		var sorter, delegate: SitSorter;
		sorter = GetSorter( tabIndex );

		if( sorter )
		{
			delegate = GetDelegate( tabIndex );
			sorter.Initialize( delegate );
			sorter.Sort( sortables, entriesArray );
			delete sorter;

			if( delegate )
			{
				delete delegate;
			}
		}
	}

	/*
	Returns the sorter instance matching the requested tab
	Returns NULL if the tab is not handled (yet) by this mod
	*/
	protected function GetSorter( tabIndex: int ): SitSorter
	{
		switch( tabIndex )
		{
			case InventoryMenuTab_Potions:
				return new SitPotionSorter in this;
			case InventoryMenuTab_QuestItems:
			case InventoryMenuTab_Books:
				return new SitBookSorter in this;
			case InventoryMenuTab_Ingredients:
				return new SitAlchemySorter in this;
			case InventoryMenuTab_Default:
				return new SitOtherSorter in this;
			case InventoryMenuTab_Weapons:
				return new SitWeaponSorter in this;
			default:
				return NULL;
		}
	}

	/*
	Returns a delegate sorter handling items not managed by the primary sorter.
	Returns NULL if a delegate is not necessary.
	*/
	protected function GetDelegate( tabIndex: int ): SitSorter
	{
		// First class sorters does not delegate anything to anyone.
		return NULL;
	}
}
