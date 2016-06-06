/*
Sort logic adapted when dealing with a merchant.
Delegates sorting of non-sellable items to a wrapped SitSorter instance.
*/
class SitShopSorter extends SitDualCellsContainerSorter
{
	protected var _sellables: SitCategory;
	protected var _delegate : SitSorter;

	/*
	Inserts a sellable category first and push other categories from base class
	*/
	public /*override*/ function Initialize( playerInv: W3GuiPlayerInventoryComponent,
		optional delegate: SitSorter ): void
	{
		super.Initialize( playerInv, delegate );
		_delegate = delegate;
		_sellables = new SitCategory in this;
		_categories.PushBack( _sellables );
	}

	/*
	Puts sellable items in the first available category.
	Other items are handled by the delegated sorter.
	*/
	protected /*override*/ function GetCategoryIndex( element: SitSortable ): int
	{
		return 0;
	}

	/*
	Adds a sellable item to the unique category of this sorter or delegates to a secondary sorter.
	*/
	protected /*override*/ function AddToCategory( element: SitSortable ): void
	{
		if( element.IsSellable() )
		{
			super.AddToCategory( element );
		}
		else
		{
			_delegate.AddToCategory( element );
		}
	}

	/*
	Flush all sellable items before flattening the categories handled by the delegate.
	*/
	protected function FlattenCategories( out entriesArray: CScriptedFlashArray ): void
	{
		super.FlattenCategories( entriesArray );
		_delegate._free_slot = _free_slot;
		_delegate._reserved_slots = _reserved_slots;
		_delegate.FlattenCategories( entriesArray );
	}

	/*
	Returns this sorter name, useful for debugging messages
	*/
	public function ToString(): string
	{
		return "SitShopSorter";
	}
}
