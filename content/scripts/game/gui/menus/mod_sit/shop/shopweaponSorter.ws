/*
Sort logic adapted when dealing with a merchant.
Offers items spanning two cells which are of low quality and are less expensive first to sell them quickly.
Delegates sorting of non-sellable items to a wrapped SitSorter instance.
*/
class SitShopWeaponSorter extends SitDualCellsContainerSorter
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

	protected function Compare( left: SitSortable, right: SitSortable, optional categoryIndex: int ): int
	{
		var l_grid_size, r_grid_size, l_quality, r_quality, l_price, r_price: int;

		l_grid_size = left.GetGridSize();
		r_grid_size = right.GetGridSize();

		if( l_grid_size == r_grid_size )
		{
			l_quality = left.GetFlashObject().GetMemberFlashInt( "quality" );
			r_quality = right.GetFlashObject().GetMemberFlashInt( "quality" );

			if( l_quality == r_quality )
			{
				l_price = left.GetUnitPrice();
				r_price = right.GetUnitPrice();

				if( l_price == r_price )
				{
					return super.Compare( left, right );
				}
				return l_price - r_price;
			}
			return l_quality - r_quality;
		}
		return r_grid_size - l_grid_size;
	}
}
