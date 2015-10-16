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

	/*
	Overrides Compare from sorter.ws
	Compares two sellables elements between them
	Returns a negative integer if the left element should be sorted before the right one,
	0 if both elements cannot be distinguished, a positive integer otherwise
	*/
	protected function Compare( left: SitSortable, right: SitSortable ): int
	{
		var l_localizedName, r_localizedName: string;
		var strLen: int;

		l_localizedName = left.GetLocalizedName();
		r_localizedName = right.GetLocalizedName();
		strLen = Min( StrLen( l_localizedName ), StrLen( r_localizedName ) );
		return StrCmp( l_localizedName, r_localizedName, strLen, true );
	}
}
