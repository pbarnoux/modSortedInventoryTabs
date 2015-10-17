/*
Sort logic adapted when dealing with a merchant.
Inherits some behavior from the default SitSorter class.
Delegates sorting of non-sellable items to a wrapped SitSorter instance.
*/
class SitShopSorter extends SitSorter
{
	protected var _sellables: array < SitSortable >;

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
		if ( element.IsSellable() )
		{
			return 0;
		}
		// Not in this sorter league
		return -1;
	}
}
