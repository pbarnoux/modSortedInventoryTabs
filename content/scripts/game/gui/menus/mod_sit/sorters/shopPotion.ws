/*
Sort logic adapted when dealing with a merchant on usable tab.
Delegates sorting of non-sellable items to a wrapped SitSorter instance.
*/
class SitShopPotionSorter extends SitShopSorter
{
	/*
	Puts sellable items in the first available category.
	Other items are handled by the delegated sorter.
	*/
	protected /*override*/ function GetCategoryIndex( element: SitSortable ): int
	{
		_playerInv.ExtractRegenEffect( element );
		return 0;
	}

	/*
	First by quality (non natural order, to avoid selling clearance potions by error)
	Then, by item duration (natural order)
	Then, by regen value (natural order)
	Then, by price (natural order)
	Then, by localized name
	*/
	protected /*override*/ function Compare( left: SitSortable,
		right: SitSortable,
		optional categoryIndex: int ): int
	{
		var l_quality, r_quality, l_price, r_price, result: int;
		var l_duration, r_duration, l_regen, r_regen      : float;

		l_quality = left.GetFlashObject().GetMemberFlashInt( "quality" );
		r_quality = right.GetFlashObject().GetMemberFlashInt( "quality" );
		result = l_quality - r_quality;

		if( result == 0 )
		{
			l_duration = left.GetDuration();
			r_duration = right.GetDuration();
			result = RoundF( l_duration - r_duration );

			if( result == 0 )
			{
				l_regen = left.GetVitalityRegen();
				r_regen = right.GetVitalityRegen();
				result = RoundF( l_regen - r_regen );

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
		}
		return result;
	}

	/*
	Returns this sorter name, useful for debugging messages
	*/
	public function ToName(): name
	{
		return 'SitShopPotionSorter';
	}
}
