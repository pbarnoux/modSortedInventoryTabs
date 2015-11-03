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
	public /*override*/ function Initialize( playerInv: W3GuiPlayerInventoryComponent,
		optional delegate: SitSorter ): void
	{
		var index, max: int;

		super.Initialize( playerInv, delegate );
		max = EnumGetMax( 'SitPotionCategory' );

		for( index = 0; index <= max; index += 1 )
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
		result = SITPC_other;

		if( categoryName == "oil" )
		{
			result = SITPC_silver_oil;

			if( flashObject.GetMemberFlashBool( "isSteelOil" ) )
			{
				result = SITPC_steel_oil;
			}
		}
		else if( categoryName == "potion" )
		{
			result = SITPC_potion;
			elementName = element.GetName();

			if( StrBeginsWith( elementName, "Mutagen" ) )
			{
				result = SITPC_mutagen;
			}
			else if ( StringToInt( StrRight ( elementName, 1 ), -1 ) < 0 )
			{
				// Puts the potion never used saved but for a given quest in a separate category
				// Anything that is not upgradable or not given a base rank
				// Pop mold ...
				result = SITPC_quest;
			}
		}
		else if( categoryName == "petard" )
		{
			result = SITPC_bomb;
		}
		else
		{
			// Fetch the duration value for edibles and drinks
			_playerInv.ExtractRegenEffect( element );
		}
		return result;
	}

	/*
	Compare by quality first, then by localized name.
	*/
	protected /*override*/ function Compare( left: SitSortable,
		right: SitSortable,
		optional categoryIndex: int ): int
	{
		var result: int;

		if( categoryIndex == SITPC_other )
		{
			result = CompareByDuration( left, right );
		}
		else
		{
			result = CompareByQuality( left, right );
		}

		if( result == 0 )
		{
			result = super.Compare( left, right );
		}
		return result;
	}

	/*
	Best quality first (superior > enhanced > normal)
	*/
	private function CompareByQuality( left: SitSortable, right: SitSortable ): int
	{
		var l_quality, r_quality: int;

		l_quality = left.GetFlashObject().GetMemberFlashInt( "quality" );
		r_quality = right.GetFlashObject().GetMemberFlashInt( "quality" );
		return r_quality - l_quality;
	}

	/*
	Longest effect first
	*/
	private function CompareByDuration( left: SitSortable, right: SitSortable ): int
	{
		var l_duration, r_duration: float;
		var result: int;

		l_duration = left.GetDuration();
		r_duration = right.GetDuration();
		result = RoundF( r_duration - l_duration );

		if( result == 0 )
		{
			result = CompareByVitalityRegen( left, right );
		}
		return result;
	}

	/*
	Highest regen effect first
	*/
	private function CompareByVitalityRegen( left: SitSortable, right: SitSortable ): int
	{
		var l_regen, r_regen: float;
		var result: int;

		l_regen = left.GetVitalityRegen();
		r_regen = right.GetVitalityRegen();
		return RoundF( r_regen - l_regen );
	}
}
