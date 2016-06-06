/*
Mod entry point when not dealing with a NPC.
Notified when some methods are triggered in base scripts.
*/
class SitListener
{
	protected var _playerInv: W3GuiPlayerInventoryComponent;

	public function Initialize( playerInv: W3GuiPlayerInventoryComponent, optional shopInv: W3GuiShopInventoryComponent ): void
	{
		LogChannel( this.ToName(), "Initializing" );
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
				LogChannel( this.ToName(), "Best tab to open on: quests" );
				return IFT_QuestItems;
			}
		}
		LogChannel( this.ToName(), "Best tab to open on: potions" );
		return IFT_AlchemyItems;
	}

	/*
	Entry point called from PopulateTabData in inventoryMenu.ws.
	*/
	public function OnPopulateTabData( tabIndex: int, sortables: array < SitSortable >, out entriesArray: CScriptedFlashArray ): void
	{
		var sorter, delegate: SitSorter;
		sorter = GetSorter( tabIndex );
		Trace();
		LogChannel( this.ToName(), "OnPopulateTabData( " + tabIndex + ")" );

		if( sorter )
		{
			delegate = GetDelegate( tabIndex );

			if ( delegate )
			{
				LogChannel( this.ToName(), "Main sorter: " + sorter.ToString() + ", delegate: " + delegate.ToString() );
			}
			else
			{
				LogChannel( this.ToName(), "Main sorter: " + sorter.ToString() + ", delegate: none" );
			}
			sorter.Initialize( _playerInv, delegate );
			sorter.Sort( sortables, entriesArray );

			if( delegate )
			{
				delegate.CleanUp();
				delete delegate;
			}
			sorter.CleanUp();
			delete sorter;
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
				return new SitPotionsSorter in this;
			case InventoryMenuTab_QuestItems:
				return new SitQuestSorter in this;
			case InventoryMenuTab_Ingredients:
				return new SitAlchemySorter in this;
			case InventoryMenuTab_Default:
				return new SitMiscSorter in this;
			case InventoryMenuTab_Weapons:
				return new SitWeaponsSorter in this;
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

	/*
	Returns this sorter name, useful for debugging messages
	*/
	public function ToName(): name
	{
		return 'SitListener';
	}
}
