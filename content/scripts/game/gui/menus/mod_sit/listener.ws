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
		// playerInv.SetFilterType( IFT_AlchemyItems );
		return IFT_AlchemyItems;
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
			delete sorter;
		}
	}

	/*
	Returns true if the newly acquired item in the quest tab contains at least one unread document
	*/
	private function IsNewQuestItemAnUnreadDocument( playerInv: W3GuiPlayerInventoryComponent ): bool
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
}
