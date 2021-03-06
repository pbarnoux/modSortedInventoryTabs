/*
Sort logic adapted to the 'ingredients tab' of the inventory.
*/
class SitAlchemySorter extends SitSorter
{
	protected var _alcohols           : array < SitSortable >;
	protected var _mutagens           : array < SitSortable >;
	protected var _monsterMutagens    : array < SitSortable >;
	protected var _alchemyIngredients : array < SitSortable >;
	protected var _craftingIngredients: array < SitSortable >;
	protected var _others             : array < SitSortable >;

	/*
	Create containers for each category.
	Containers are sorted accorded to the SitAlchemyCategory enumeration.
	*/
	public /*override*/ function Initialize( playerInv: W3GuiPlayerInventoryComponent,
		optional delegate: SitSorter ): void
	{
		var index, max: int;

		super.Initialize( playerInv, delegate );
		max = EnumGetMax( 'SitAlchemyCategory' );

		for( index = 0; index <= max; index += 1 )
		{
			_categories.PushBack( new SitCategory in this );
		}
	}

	/*
	Returns the index of the category assigned to the given element.
	*/
	protected /*override*/ function GetCategoryIndex( element: SitSortable ): int
	{
		var categoryName: string;
		var elementName : string;
		var flashObject : CScriptedFlashObject;
		var result      : int;

		if( element.IsConsumable() )
		{
			result = SITAC_alcohol;
		}
		else
		{
			result = SITAC_other;
			flashObject = element.GetFlashObject();
			categoryName = flashObject.GetMemberFlashString( "category" );

			if( categoryName == "alchemy_ingredient" )
			{
				result = SITAC_alchemy_ingredient;
				elementName = element.GetName();

				if( StrContains( elementName, "utagen " ) )
				{
					result = SITAC_common_mutagen;
				}
				else if( StrContains( elementName, " mutagen" ) )
				{
					result = SITAC_monster_mutagen;
				}
			}
		}
		return result;
	}

	/*
	Compares two items from the ingredient tab.
	Use specific comparison algirithms for some categories. Other stuff is sorted by localized name.
	*/
	protected /*override*/ function Compare( left: SitSortable,
		right: SitSortable,
		optional categoryIndex: int ): int
	{
		var result: int;

		switch( categoryIndex )
		{
			case SITAC_alcohol:
				result = CompareAlcohols( left, right );
				break;
			case SITAC_common_mutagen:
				result = CompareMutagens( left, right );
				break;
			default:
				result = super.Compare( left, right );
		}
		return result;
	}

	/*
	Compares two alcohols.
	Alcohols are sorted by priority: the firt one in the list is the next one consumed when entering meditation.
	*/
	protected function CompareAlcohols( left: SitSortable, right: SitSortable ): int
	{
		var l_free, r_free: bool;
		var result        : int;

		if( l_free )
		{
			result = -1;
		}
		else if( r_free )
		{
			result = 1;
		}
		else
		{
			// Game will consume cheapest alcohol first
			result = left.GetUnitPrice() - right.GetUnitPrice();
		}
		return result;
	}

	/*
	Compares two mutagens.
	Mutagens are sorted by quality (greater > normal > lesser) and localized name in case they tie.
	*/
	protected function CompareMutagens( left: SitSortable, right: SitSortable ): int
	{
		var l_quality, r_quality, result: int;
		var l_name, r_name              : string;

		l_name = left.GetName();
		r_name = right.GetName();
		// Default: normal mutagens
		l_quality = 2;
		r_quality = 2;

		if( StrBeginsWith( l_name, "Greater " ) )
		{
			l_quality = 3;
		}
		else if( StrBeginsWith( l_name, "Lesser " ) )
		{
			l_quality = 1;
		}

		if( StrBeginsWith( r_name, "Greater " ) )
		{
			r_quality = 3;
		}
		else if( StrBeginsWith( r_name, "Lesser " ) )
		{
			r_quality = 1;
		}
		result = r_quality - l_quality;

		if( result == 0 )
		{
			result = super.Compare( left, right );
		}
		return result;
	}

	/*
	Returns this sorter name, useful for debugging messages
	*/
	public function ToName(): name
	{
		return 'SitAlchemySorter';
	}
}
