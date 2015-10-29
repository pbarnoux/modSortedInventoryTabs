/*
Mod entry point when not dealing with a NPC.
Notified when some methods are triggered in base scripts.
*/
class SitListener
{
	protected var _playerInv: W3GuiPlayerInventoryComponent;

	public function Initialize( playerInv: W3GuiPlayerInventoryComponent, optional shopInv: W3GuiShopInventoryComponent ): void
	{
		_playerInv = playerInv;
	}

	/*
	Entry point called from OnConfigUI in inventoryMenu.ws
	*/
	public function GuessTabIndex( optional hasNewQuestItem: bool ): int
	{
		if( hasNewQuestItem )
		{
			if( IsNewQuestItemAnUnreadDocument() )
			{
				return IFT_QuestItems;
			}
		}
		// playerInv.SetFilterType( IFT_AlchemyItems );
		return IFT_AlchemyItems;
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
	Returns true if the newly acquired item in the quest tab contains at least one unread document
	*/
	protected function IsNewQuestItemAnUnreadDocument(): bool
	{
		var index    : int;
		var inv      : CInventoryComponent;
		var uiData   : SInventoryItemUIData;
		var rawItems : array< SItemUniqueId >;
		var item     : SItemUniqueId;
		var result   : bool;

		result = false;
		_playerInv.SetFilterType( IFT_QuestItems );
		inv = _playerInv.GetInventoryComponent();
		inv.GetAllItems( rawItems );

		for( index = 0; index < rawItems.Size(); index += 1 )
		{
			item = rawItems[ index ];

			if( ( (W3GuiBaseInventoryComponent) _playerInv ).ShouldShowItem( item ) )
			{
				uiData = inv.GetInventoryItemUIData( item );

				if ( uiData.isNew )
				{
					if( inv.ItemHasTag( item, 'ReadableItem' ) )
					{
						if( !inv.IsBookRead( item ) )
						{
							result = true;
						}
					}
				}
			}
		}
		return result;
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
