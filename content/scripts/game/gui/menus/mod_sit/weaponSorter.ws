/*
Change order of elements in the tab by modifying the indexes
Make sure to use unique continuous positive integers starting at 0
Categories are sorted by these index (first, items of the category 0, then items of the category 1, and so on...)
For best results, put items covering a single cell before items spanning on two cells.
*/
enum SitWeaponCategory
{
	// Categories containing items covering a single cell
	SITWC_rune         = 0,
	SITWC_glyph        = 1,
	SITWC_weapon_tool  = 2,
	SITWC_armor_tool   = 3,
	// Categories containing items spanning on two cells
	SITWC_steel_sword  = 4,
	SITWC_silver_sword = 5,
	SITWC_crossbow     = 6,
	SITWC_bolt         = 7,
	SITWC_armor        = 8,
	SITWC_gloves       = 9,
	SITWC_pants        = 10,
	SITWC_boots        = 11,
	SITWC_trophy       = 12,
	SITWC_horse        = 13,
	SITWC_other        = 14,
}

/*
Sort logic adapted to the 'weapon tab' of the inventory.
*/
class SitWeaponSorter extends SitDualCellsContainerSorter
{
	protected var _runes        : array < SitSortable >;
	protected var _glyphes      : array < SitSortable >;
	protected var _weapon_tools : array < SitSortable >;
	protected var _armor_tools  : array < SitSortable >;
	protected var _steel_swords : array < SitSortable >;
	protected var _silver_swords: array < SitSortable >;
	protected var _crossbows    : array < SitSortable >;
	protected var _bolts        : array < SitSortable >;
	protected var _armors       : array < SitSortable >;
	protected var _gloves       : array < SitSortable >;
	protected var _pants        : array < SitSortable >;
	protected var _boots        : array < SitSortable >;
	protected var _trophies     : array < SitSortable >;
	protected var _horse_stuff  : array < SitSortable >;
	protected var _others       : array < SitSortable >;

	/*
	Create containers for each category.
	Containers are sorted accorded to the SitWeaponCategory enumeration.
	*/
	public function Initialize( optional delegate: SitSorter ): void
	{
		var index: int;
		super.Initialize( delegate );

		/*
		Currently still looking for a way to obtain the number of elements of an enum.
		Till then, the loop max index must be updated when literal is added/removed to SitWeaponCategory.
		*/
		for( index = 0; index < 15; index += 1 )
		{
			switch( index )
			{
				case SITWC_rune:
					_categories.PushBack( _runes );
					break;
				case SITWC_glyph:
					_categories.PushBack( _glyphes );
					break;
				case SITWC_weapon_tool:
					_categories.PushBack( _weapon_tools );
					break;
				case SITWC_armor_tool:
					_categories.PushBack( _armor_tools );
					break;
				case SITWC_steel_sword:
					_categories.PushBack( _steel_swords );
					break;
				case SITWC_silver_sword:
					_categories.PushBack( _silver_swords );
					break;
				case SITWC_crossbow:
					_categories.PushBack( _crossbows );
					break;
				case SITWC_bolt:
					_categories.PushBack( _bolts );
					break;
				case SITWC_armor:
					_categories.PushBack( _armors );
					break;
				case SITWC_gloves:
					_categories.PushBack( _gloves );
					break;
				case SITWC_pants:
					_categories.PushBack( _pants );
					break;
				case SITWC_boots:
					_categories.PushBack( _boots );
					break;
				case SITWC_trophy:
					_categories.PushBack( _trophies );
					break;
				case SITWC_horse:
					_categories.PushBack( _horse_stuff );
					break;
				default:
					_categories.PushBack( _others );
			}
		}
		LogChannel( 'MOD_SIT', "SitWeaponSorter initialized ; number of categories : " + _categories.Size() );
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
		LogChannel( 'MOD_SIT', "AddToCategory " + element.ToString()  + ", cat name: " + categoryName );

		if( categoryName == "upgrade" )
		{
			if( StrBeginsWith( element.GetName(), "Rune " ) )
			{
				return SITWC_rune;
			}
			return SITWC_glyph;
		}

		if( categoryName == "tool" )
		{
			if( StrBeginsWith( element.GetName(), "weapon_" ) )
			{
				return SITWC_weapon_tool;
			}
			return SITWC_armor_tool;
		}

		if( categoryName == "steelsword" )
		{
			return SITWC_steel_sword;
		}

		if( categoryName == "silversword" )
		{
			return SITWC_silver_sword;
		}

		if( categoryName == "crossbow" )
		{
			return SITWC_crossbow;
		}

		if( categoryName == "bolt" )
		{
			return SITWC_bolt;
		}

		if( categoryName == "armor" )
		{
			return SITWC_armor;
		}

		if( categoryName == "gloves" )
		{
			return SITWC_gloves;
		}

		if( categoryName == "pants" )
		{
			return SITWC_pants;
		}

		if( categoryName == "boots" )
		{
			return SITWC_boots;
		}

		if( categoryName == "trophy" )
		{
			return SITWC_trophy;
		}

		if( StrBeginsWith( categoryName, "horse_" ) )
		{
			return SITWC_horse;
		}
		return SITWC_other;
		// Not proud of this cmplexity, especially after the switch in Initialize...
	}

	/*
	Overrides Compare from sorter.ws
	Compares two sortable elements between them
	Returns a negative integer if the left element should be sorted before the right one,
	0 if both elements cannot be distinguished, a positive integer otherwise.
	Compare by quality first, then by localized name.
	*/
	protected function Compare( left: SitSortable, right: SitSortable, optional categoryIndex: int ): int
	{
		var l_quality, r_quality: int;

		switch( categoryIndex )
		{
			case SITWC_rune:
			case SITWC_glyph:
				return CompareUpgrades( left, right );
			case SITWC_weapon_tool:
			case SITWC_armor_tool:
				return CompareTools( left, right );
			default:
				;
		}
		l_quality = left.GetFlashObject().GetMemberFlashInt( "quality" );
		r_quality = right.GetFlashObject().GetMemberFlashInt( "quality" );

		if( l_quality == r_quality )
		{
			return super.Compare( left, right );
		}
		return r_quality - l_quality;
	}

	private function CompareUpgrades( left: SitSortable, right: SitSortable ): int
	{
		var l_quality, r_quality: int;

		// default: assume normal (neither lesser nor greater)
		l_quality = 1;
		r_quality = 1;

		if( StrEndsWith( left.GetName(), " lesser" ) )
		{
			l_quality = 0;
		}
		else if( StrEndsWith( left.GetName(), " greater" ) )
		{
			l_quality = 2;
		}

		if( StrEndsWith( right.GetName(), " lesser" ) )
		{
			r_quality = 0;
		}
		else if( StrEndsWith( right.GetName(), " greater" ) )
		{
			r_quality = 2;
		}

		if( l_quality == r_quality )
		{
			return super.Compare( left, right );
		}
		return r_quality - l_quality;
	}

	private function CompareTools( left: SitSortable, right: SitSortable ): int
	{
		var l_quality, r_quality: int;

		// Obtain quality from name (last char is a digit, smaller is lesser
		l_quality = StringToInt( StrRight( left.GetName(), 1 ) );
		r_quality = StringToInt( StrRight( right.GetName(), 1 ) );

		if( l_quality == r_quality )
		{
			return super.Compare( left, right );
		}
		return r_quality - l_quality;
	}
}
