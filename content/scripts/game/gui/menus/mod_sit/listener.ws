/*
Mod entry point.
Notified when some methods are triggered in base scripts.
*/
class SitListener
{
	public function Initialize(): void
	{
		LogChannel( 'MOD_SIT', "SitListener initialized");
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
			LogChannel( 'MOD_SIT', "SitListener.OnPopulateTabData" );
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
	private function GetSorter( tabIndex: int ): SitSorter
	{
		switch( tabIndex )
		{
			case InventoryMenuTab_Potions:
				return new SitPotionSorter in this;
			case InventoryMenuTab_QuestItems:
			case InventoryMenuTab_Books:
				return new SitBookSorter in this;
			default:
				return NULL;
		}
	}

	/*
	Returns a delegate sorter handling items not managed by the primary sorter.
	Returns NULL if in this case and for this tab a delegate is not necessary.
	*/
	protected function GetDelegate( tabIndex: int ): SitSorter
	{
		// First class sorters does not delegate anything to anyone.
		return NULL;
	}
}
