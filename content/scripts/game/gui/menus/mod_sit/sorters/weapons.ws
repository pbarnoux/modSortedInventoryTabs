/*
Sort logic adapted to the 'weapon tab' of the inventory.
*/
class SitWeaponsSorter extends SitDualCellsContainerSorter
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
	public /*override*/ function Initialize( playerInv: W3GuiPlayerInventoryComponent,
		optional delegate: SitSorter ): void
	{
		var index, max: int;

		super.Initialize( playerInv, delegate );
		max = EnumGetMax( 'SitWeaponsCategory' );

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

		flashObject = element.GetFlashObject();
		categoryName = flashObject.GetMemberFlashString( "category" );
		result = SITWC_other;

		if( categoryName == "upgrade" )
		{
			result = SITWC_glyph;

			if( StrBeginsWith( element.GetName(), "Rune " ) )
			{
				result = SITWC_rune;
			}
		}
		else if( categoryName == "tool" )
		{
			result = SITWC_armor_tool;

			if( StrBeginsWith( element.GetName(), "weapon_" ) )
			{
				result = SITWC_weapon_tool;
			}
		}
		else if( categoryName == "steelsword" )
		{
			result = SITWC_steel_sword;
		}
		else if( categoryName == "silversword" )
		{
			result = SITWC_silver_sword;
		}
		else if( categoryName == "crossbow" )
		{
			result = SITWC_crossbow;
		}
		else if( categoryName == "bolt" )
		{
			result = SITWC_bolt;
		}
		else if( categoryName == "armor" )
		{
			result = SITWC_armor;
		}
		else if( categoryName == "gloves" )
		{
			result = SITWC_gloves;
		}
		else if( categoryName == "pants" )
		{
			result = SITWC_pants;
		}
		else if( categoryName == "boots" )
		{
			result = SITWC_boots;
		}
		return result;
		// Not proud of this complexity, especially after the switch in Initialize...
	}

	/*
	Compares two items of the weapon tab.
	Compares by quality first, then by localized name.
	*/
	protected /*override*/ function Compare( left: SitSortable,
		right: SitSortable,
		optional categoryIndex: int ): int
	{
		var result: int;

		switch( categoryIndex )
		{
			case SITWC_rune:
			case SITWC_glyph:
				result = CompareUpgrades( left, right );
				break;
			case SITWC_weapon_tool:
			case SITWC_armor_tool:
				result = CompareTools( left, right );
				break;
			default:
				result = CompareByQualityOrName( left, right );
		}
		return result;
	}

	private function CompareUpgrades( left: SitSortable, right: SitSortable ): int
	{
		var l_quality, r_quality, result: int;

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
		result = r_quality - l_quality;

		if( result == 0 )
		{
			result = super.Compare( left, right );
		}
		return result;
	}

	private function CompareTools( left: SitSortable, right: SitSortable ): int
	{
		var l_quality, r_quality, result: int;

		// Obtain quality from name (last char is a digit, smaller is lesser)
		l_quality = StringToInt( StrRight( left.GetName(), 1 ) );
		r_quality = StringToInt( StrRight( right.GetName(), 1 ) );
		result = r_quality - l_quality;

		if( result == 0 )
		{
			result = super.Compare( left, right );
		}
		return result;
	}

	private function CompareByQualityOrName( left: SitSortable, right: SitSortable ): int
	{
		var l_quality, r_quality, result: int;

		l_quality = left.GetFlashObject().GetMemberFlashInt( "quality" );
		r_quality = right.GetFlashObject().GetMemberFlashInt( "quality" );
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
		return 'SitWeaponsSorter';
	}
}
