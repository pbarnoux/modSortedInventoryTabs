/*
Mod entry point.
Notified when some methods are triggered in base scripts.
*/
class SitListener
{
	private var _potionSorter : SitSorter;

	public function Initialize(): void
	{
		_potionSorter = new SitPotionSorter in this;
		_potionSorter.Initialize();
		LogChannel( 'MOD_SIT', "SitListener initialized");
	}

	/*
	Entry point called from PopulateTabData in inventoryMenu.ws.
	*/
	public function OnPopulateTabData( tabIndex: int, sortables: array < SitSortable >, out entriesArray: CScriptedFlashArray ): void
	{
		LogChannel( 'MOD_SIT', "SitListener.OnPopulateTabData" );

		if( tabIndex == InventoryMenuTab_Potions )
		{
			// Sorts the items when bringing up the 'usable tab'
			_potionSorter.Sort( sortables, entriesArray );
		}
	}
}
