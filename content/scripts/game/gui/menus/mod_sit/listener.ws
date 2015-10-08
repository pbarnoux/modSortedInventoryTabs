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
		var sorter: SitSorter;
		sorter = GetSorter( tabIndex );

		if( sorter )
		{
			LogChannel( 'MOD_SIT', "SitListener.OnPopulateTabData" );
			sorter.Initialize();
			sorter.Sort( sortables, entriesArray );
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
			default:
				return NULL;
		}
	}
}
