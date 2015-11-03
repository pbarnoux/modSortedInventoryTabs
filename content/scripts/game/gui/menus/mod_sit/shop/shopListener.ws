/*
Mod entry point when dealing with a NPC.
Notified when some methods are triggered in base scripts.
*/
class SitShopListener extends SitListener
{
	private var _delegate: SitSorter;

	public /*override*/ function Initialize(): void
	{
		super.Initialize();
	}

	/*
	Returns the main sorter instance.
	*/
	protected /*override*/ function GetSorter( tabIndex: int ): SitSorter
	{
		_delegate = super.GetSorter( tabIndex );

		if( _delegate )
		{
			_delegate.Initialize( _playerInv );

			switch( tabIndex )
			{
				case InventoryMenuTab_Weapons:
					return new SitShopWeaponSorter in this;
				case InventoryMenuTab_Potions:
					return new SitShopPotionSorter in this;
				default:
					return new SitShopSorter in this;
			}
		}
		return NULL;
	}

	/*
	Returns a delegate sorter handling non sellable items.
	This way, non sellable items should have a consistent order between shop HUD and player HUD menus.
	*/
	protected /*override*/ function GetDelegate( tabIndex: int ): SitSorter
	{
		return _delegate;
	}
}
