/*
Mod entry point.
Notified when some methods are triggered in base scripts.
*/
class SitShopListener extends SitListener
{
	private var _delegate: SitSorter;
	private var _shopInv : W3GuiShopInventoryComponent;

	public function Initialize( playerInv: W3GuiPlayerInventoryComponent, optional shopInv: W3GuiShopInventoryComponent ): void
	{
		super.Initialize( playerInv, shopInv );
		_shopInv = shopInv;
		LogChannel( 'MOD_SIT', "SitShopListener initialized" );
	}

	/*
	Entry point called from OnConfigUI in inventoryMenu.ws
	*/
	public function GuessTabIndex( optional hasNewQuestItem: bool ): int
	{
		var shop: CInventoryComponent;

		// Guess the kind of shop (from the most likely to the less likely)
		shop = _shopInv.GetInventoryComponent();

		if( shop.HasTag( 'type_blacksmith' ) || shop.HasTag( 'type_armorer' ) )
		{
			return IFT_Weapons;
		}

		if( shop.HasTag( 'type_herbalist' ) || shop.HasTag( 'type_alchemist' ) )
		{
			return IFT_Ingredients;
		}

		if( shop.HasTag( 'type_inn' ) )
		{
			return IFT_AlchemyItems;
		}

		if( shop.HasTag( 'type_general' ) )
		{
			return IFT_Default;
		}

		if( shop.HasTag( 'type_book' ) )
		{
			return IFT_Books;
		}

		// Should I forgot a type of shop, make sure to fallback on default tab: weapon one
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

			if( tabIndex == InventoryMenuTab_Weapons )
			{
				return new SitShopWeaponSorter in this;
			}
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
