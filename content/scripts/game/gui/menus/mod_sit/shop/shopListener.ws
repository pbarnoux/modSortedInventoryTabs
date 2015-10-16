/*
Mod entry point.
Notified when some methods are triggered in base scripts.
*/
class SitShopListener extends SitListener
{
	private var _delegate: SitSorter;

	public function Initialize(): void
	{
		LogChannel( 'MOD_SIT', "SitShopListener initialized" );
	}

	/*
	Entry point called from OnConfigUI in inventoryMenu.ws
	*/
	public function GuessTabIndex( playerInv: W3GuiPlayerInventoryComponent, hasNewQuestItem: bool ): int
	{
		return IFT_Weapons;
	}

	/*
	Returns the main sorter instance.
	*/
	protected function GetSorter( tabIndex: int ): SitSorter
	{
		_delegate = super.GetSorter( tabIndex );

		if( _delegate )
		{
			_delegate.Initialize();
			return new SitShopSorter in this;
		}
		return NULL;
	}

	/*
	Returns a delegate sorter handling non sellable items.
	This way, non sellable items should have a consistent order between shop HUD and player HUD menus.
	*/
	protected function GetDelegate( tabIndex: int ): SitSorter
	{
		return _delegate;
	}
}
