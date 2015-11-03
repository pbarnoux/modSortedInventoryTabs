/*
Mod entry point when dealing with a NPC.
Notified when some methods are triggered in base scripts.
*/
class SitShopListener extends SitListener
{
	private var _delegate: SitSorter;
	private var _shopInv : W3GuiShopInventoryComponent;

	public /*override*/ function Initialize( playerInv: W3GuiPlayerInventoryComponent,
		optional shopInv: W3GuiShopInventoryComponent ): void
	{
		super.Initialize( playerInv, shopInv );
		_shopInv = shopInv;
	}

	/*
	Entry point called from OnConfigUI in inventoryMenu.ws
	*/
	public /*override*/ function GuessTabIndex( optional hasNewQuestItem: bool ): int
	{
		var shop  : CInventoryComponent;
		var result: int;

		// Guess the kind of shop (from the most likely to the less likely)
		shop = _shopInv.GetInventoryComponent();

		// Should I forgot a type of shop, make sure to fallback on default tab: weapon one
		result = IFT_Weapons;

		if( shop.HasTag( 'type_blacksmith' ) || shop.HasTag( 'type_armorer' ) )
		{
			result = IFT_Weapons;
		}
		else if( shop.HasTag( 'type_herbalist' ) || shop.HasTag( 'type_alchemist' ) )
		{
			result = IFT_Ingredients;
		}
		else if( shop.HasTag( 'type_inn' ) )
		{
			result = IFT_AlchemyItems;
		}
		else if( shop.HasTag( 'type_general' ) )
		{
			result =  IFT_Default;
		}
		else if( shop.HasTag( 'type_book' ) )
		{
			result = IFT_Books;
		}
		return result;
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
