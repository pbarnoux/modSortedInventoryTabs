/*
Sort logic adapted when dealing with a merchant.
Inherits some behavior from the default SitSorter class.
Delegates sorting of non-sellable items to a wrapped SitSorter instance.
*/
class SitShopSorter extends SitDualCellsContainerSorter
{
	protected var _sellables: array < SitSortable >;
	protected var _delegate : SitSorter;

	/*
	Overrides Initialize from potionSorter.ws
	Inserts a sellable category first and push other categories from base class
	*/
	public function Initialize( optional delegate: SitSorter ): void
	{
		_delegate = delegate;
		_categories.PushBack( _sellables );
		LogChannel( 'MOD_SIT', "SitShopSorter initialized ; number of categories : " + _categories.Size() );
	}

	/*
	Overrides GetCategoryIndex from bookSorter.ws
	Put sellable items in the first available category.
	Other items will be handled by the delegated sorter.
	*/
	protected function GetCategoryIndex( element: SitSortable ): int
	{
		return 0;
	}

	/*
	*/
	protected function AddToCategory( element: SitSortable ): void
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
	Flattens the two-dimensional array of items into a single dimension array of items.
	*/
	protected function FlattenCategories( out entriesArray: CScriptedFlashArray ): void
	{
		super.FlattenCategories( entriesArray );
		_delegate._free_slot = _free_slot;
		_delegate._reserved_slots = _reserved_slots;
		_delegate.FlattenCategories( entriesArray );
	}
}
