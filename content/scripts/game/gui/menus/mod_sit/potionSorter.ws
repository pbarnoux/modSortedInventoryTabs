/*
Change order of elements in the tab by modifying the indexes
Make sure to use unique continuous positive integers starting at 0
Categories are sorted by these index (first, items of the category 0, then items of the category 1, and so on...)
*/
enum SitPotionCategory
{
	SITPC_steel_oil  = 0,
	SITPC_silver_oil = 1,
	SITPC_potion     = 2,
	SITPC_mutagen    = 3,
	SITPC_bomb       = 4,
	SITPC_other      = 5,
	SITPC_quest      = 6,
}

/*
Sort logic adapted to the 'usable tab' of the inventory.
*/
class SitPotionSorter extends SitSorter
{
	protected var _steel_oils : array < SitSortable >;
	protected var _silver_oils: array < SitSortable >;
	protected var _potions    : array < SitSortable >;
	protected var _mutagens   : array < SitSortable >;
	protected var _bombs      : array < SitSortable >;
	protected var _others     : array < SitSortable >;
	protected var _quests     : array < SitSortable >;

	/*
	Create containers for each category.
	Containers are sorted accorded to the SitPotionCategory enumeration.
	*/
	public function Initialize( optional delegate: SitSorter ): void
	{
		var index: int;
		super.Initialize( delegate );

		/*
		Currently still looking for a way to obtain the number of elements of an enum.
		Till then, the loop max index must be updated when literal is added/removed to SitPotionCategory.
		*/
		for( index = 0; index < 7; index += 1 )
		{
			switch( index )
			{
				case SITPC_steel_oil:
					_categories.PushBack( _steel_oils );
					break;
				case SITPC_silver_oil:
					_categories.PushBack( _silver_oils );
					break;
				case SITPC_potion:
					_categories.PushBack( _potions );
					break;
				case SITPC_mutagen:
					_categories.PushBack( _mutagens );
					break;
				case SITPC_bomb:
					_categories.PushBack( _bombs );
					break;
				case SITPC_other:
					_categories.PushBack( _others );
					break;
				default:
					_categories.PushBack( _quests );
			}
		}
		LogChannel( 'MOD_SIT', "SitPotionSorter initialized ; number of categories : " + _categories.Size());
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

		if( categoryName == "oil" )
		{
			if( flashObject.GetMemberFlashBool( "isSteelOil" ) )
			{
				return SITPC_steel_oil;
			}
			return SITPC_silver_oil;
		}

		if( categoryName == "potion" )
		{
			elementName = element.GetName();

			if( StrBeginsWith( elementName, "Mutagen" ) )
			{
				return SITPC_mutagen;
			}

			if ( StringToInt( StrRight ( elementName, 1 ), -1 ) < 0 )
			{
				// Puts the potion never used saved but for a given quest in a separate category
				// Anything that is not upgradable or not given a base rank
				// Pop mold ...
				return SITPC_quest;
			}
			return SITPC_potion;
		}

		if( categoryName == "petard" )
		{
			return SITPC_bomb;
		}
		return SITPC_other;
	}

	/*
	Overrides Compare from sorter.ws
	Compares two sortable elements between them
	Returns a negative integer if the left element should be sorted before the right one,
	0 if both elements cannot be distinguished, a positive integer otherwise
	*/
	protected function Compare( left: SitSortable, right: SitSortable ): int
	{
		var l_localizedName, r_localizedName: string;
		var l_quality, r_quality, strLen    : int;

		l_quality = left.GetFlashObject().GetMemberFlashInt( "quality" );
		r_quality = right.GetFlashObject().GetMemberFlashInt( "quality" );
		l_localizedName = left.GetLocalizedName();
		r_localizedName = right.GetLocalizedName();

		if ( l_quality == r_quality )
		{
			// Both items have same quality, sort by name then
			strLen = Min( StrLen( l_localizedName ), StrLen( r_localizedName ) );
			return StrCmp( l_localizedName, r_localizedName, strLen, true );
		}
		return r_quality - l_quality;
	}
}
