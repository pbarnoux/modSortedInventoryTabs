/*
Sort logic adapted to the 'usable tab' of the inventory.
*/
class SitPotionsSorter extends SitSorter
{
	/*
	Create containers for each category.
	Containers are sorted accorded to the SitPotionCategory enumeration.
	*/
	public /*override*/ function Initialize( playerInv: W3GuiPlayerInventoryComponent,
		optional delegate: SitSorter ): void
	{
		var index, max: int;

		super.Initialize( playerInv, delegate );
		max = EnumGetMax( 'SitPotionsCategory' );

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
		result = SITPC_other;

		if( categoryName == "potion" )
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

	/*
	Returns this sorter name, useful for debugging messages
	*/
	public function ToName(): name
	{
		return 'SitPotionSorter';
	}
}
