/*
Sort logic adapted when dealing with a merchant on weapon tab.
Delegates sorting of non-sellable items to a wrapped SitSorter instance.
*/
class SitShopWeaponSorter extends SitShopSorter
{
	/*
	Offers items spanning two cells which are of low quality and are less expensive first to sell them quickly.
	*/
	protected /*override*/ function Compare( left: SitSortable,
		right: SitSortable,
		optional categoryIndex: int ): int
	{
		var l_grid_size, r_grid_size, l_quality, r_quality, l_price, r_price, result: int;

		l_grid_size = left.GetGridSize();
		r_grid_size = right.GetGridSize();
		result = r_grid_size - l_grid_size;

		if( result == 0 )
		{
			l_quality = left.GetFlashObject().GetMemberFlashInt( "quality" );
			r_quality = right.GetFlashObject().GetMemberFlashInt( "quality" );
			result = l_quality - r_quality;

			if( result == 0 )
			{
				l_price = left.GetUnitPrice();
				r_price = right.GetUnitPrice();
				result = l_price - r_price;

				if( result == 0 )
				{
					result = super.Compare( left, right );
				}
			}
		}
		return result;
	}
	
		/*
	Returns this sorter name, useful for debugging messages
	*/
	public function ToName(): name
	{
		return 'SitShopweaponSorter';
	}
}
