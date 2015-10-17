/*
Mod entry point.
Notified when some methods are triggered in base scripts.
*/
class SitListener
{
	public function Initialize(): void
	{
		LogChannel( 'MOD_SIT', "SitListener initialized" );
	}

	/*
	Entry point called from OnConfigUI in inventoryMenu.ws
	*/
	public function GuessTabIndex( playerInv: W3GuiPlayerInventoryComponent, hasNewQuestItem: bool ): int
	{
		if( hasNewQuestItem )
		{
			if( IsNewQuestItemAnUnreadDocument( playerInv ) )
			{
				return IFT_QuestItems;
			}
		}
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
	Returns true if the newly acquired item in the quest tab contains at least one unread document
	*/
	protected function IsNewQuestItemAnUnreadDocument( playerInv: W3GuiPlayerInventoryComponent ): bool
	{
		var index   : int;
		var inv     : CInventoryComponent;
		var uiData  : SInventoryItemUIData;
		var rawItems: array< SItemUniqueId >;
		var item    : SItemUniqueId;

		playerInv.SetFilterType( IFT_QuestItems );
		inv = playerInv.GetInventoryComponent();
		inv.GetAllItems( rawItems );

		for( index = 0; index < rawItems.Size(); index += 1 )
		{
			item = rawItems[ index ];

			if( ( (W3GuiBaseInventoryComponent) playerInv).ShouldShowItem( item ) )
			{
				uiData = inv.GetInventoryItemUIData( item );

				if ( uiData.isNew )
				{
					if( inv.ItemHasTag( item, 'ReadableItem' ) )
					{
						if( !inv.IsBookRead( item ) )
						{
							return true;
						}
					}
				}
			}
		}
		return false;
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
