/*
Change order of elements in the tab by modifying the indexes
Make sure to use unique continuous positive integers starting at 0
Categories are sorted by these index (first, items of the category 0, then items of the category 1, and so on...)
*/
enum SitAlchemyCategory
{
	SITAC_alcohol             = 0,
	SITAC_alchemy_ingredient  = 1,
	SITAC_common_mutagen      = 2,
	SITAC_monster_mutagen     = 3,
	SITAC_crafting_ingredient = 4,
	SITAC_other               = 5,
}

/*
Sort logic adapted to the 'usable tab' of the inventory.
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
	public function Initialize( optional delegate: SitSorter ): void
	{
		var index: int;
		super.Initialize( delegate );

		/*
		Currently still looking for a way to obtain the number of elements of an enum.
		Till then, the loop max index must be updated when literal is added/removed to SitAlchemyCategory.
		*/
		for( index = 0; index < 6; index += 1 )
		{
			switch( index )
			{
				case SITAC_alcohol:
					_categories.PushBack( _alcohols );
					break;
				case SITAC_common_mutagen:
					_categories.PushBack( _mutagens );
					break;
				case SITAC_monster_mutagen:
					_categories.PushBack( _monsterMutagens );
					break;
				case SITAC_alchemy_ingredient:
					_categories.PushBack( _alchemyIngredients );
					break;
				case SITAC_crafting_ingredient:
					_categories.PushBack( _craftingIngredients );
					break;
				default:
					_categories.PushBack( _others );
			}
		}
		LogChannel( 'MOD_SIT', "SitAlchemySorter initialized ; number of categories : " + _categories.Size() );
	}

	/*
	Overrides GetCategoryIndex from sorter.ws
	Returns the index of the category assigned to the given element.
	*/
	protected function GetCategoryIndex( element: SitSortable ): int
	{
		var categoryName: string;
		var elementName : string;
		var flashObject : CScriptedFlashObject;

		flashObject = element.GetFlashObject();
		categoryName = flashObject.GetMemberFlashString( "category" );

		if( element.IsConsumable() )
		{
			return SITAC_alcohol;
		}

		if( categoryName == "alchemy_ingredient" )
		{
			if( StrContains( element.GetName(), "utagen " ) )
			{
				return SITAC_common_mutagen;
			}
			if( StrContains( element.GetName(), " mutagen" ) )
			{
				return SITAC_monster_mutagen;
			}
			return SITAC_alchemy_ingredient;
		}

		if( categoryName == "crafting_ingredient" )
		{
			return SITAC_crafting_ingredient;
		}
		return SITAC_other;
	}

	/*
	Compares two sortable elements between them
	Returns a negative integer if the left element should be sorted before the right one,
	0 if both elements cannot be distinguished, a positive integer otherwise.
	Use specific comparison algirithms for some categories. Other stuff is sorted by localized name.
	*/
	protected function Compare( left: SitSortable, right: SitSortable, optional categoryIndex: int ): int
	{
		if( categoryIndex == SITAC_alcohol )
		{
			return CompareAlcohols( left, right );
		}

		if( categoryIndex == SITAC_common_mutagen )
		{
			return CompareMutagens( left, right );
		}
		return super.Compare( left, right );
	}

	/*
	Compares two alcohols
	Returns a negative integer if the left element should be sorted before the right one,
	0 if both elements cannot be distinguished, a positive integer otherwise.
	Alcohols are sorted by priority: the firt one in the list is the next one consumed when entering meditation.
	*/
	protected function CompareAlcohols( left: SitSortable, right: SitSortable ): int
	{
		var l_free, r_free: bool;
		var l_price, r_price: int;

		l_free = left.IsFreeForUse();
		r_free = right.IsFreeForUse();

		if( l_free )
		{
			return -1;
		}

		if( r_free )
		{
			return 1;
		}
		// Game will consume cheapest alcohol first
		l_price = left.GetUnitPrice();
		r_price = right.GetUnitPrice();
		return l_price - r_price;
	}

	/*
	Compares two mutagens
	Returns a negative integer if the left element should be sorted before the right one,
	0 if both elements cannot be distinguished, a positive integer otherwise.
	Mutagens are sorted by quality (greater > normal > lesser) and localized name in case they tie.
	*/
	protected function CompareMutagens( left: SitSortable, right: SitSortable ): int
	{
		var l_quality, r_quality: int;
		var l_name, r_name: string;

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

		if( l_quality == r_quality )
		{
			return super.Compare( left, right );
		}
		return r_quality - l_quality;
	}
}
