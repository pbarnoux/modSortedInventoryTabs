/*
Sort logic adapted to the 'quest tab' of the inventory.
*/
class SitQuestSorter extends SitDualCellsContainerSorter
{
	protected var _unread: array < SitSortable >;
	protected var _read  : array < SitSortable >;
	protected var _others: array < SitSortable >;

	/*
	Create containers for each category.
	Containers are sorted accorded to the SitBookCategory enumeration.
	*/
	public /*override*/ function Initialize( playerInv: W3GuiPlayerInventoryComponent,
		optional delegate: SitSorter ): void
	{
		var index, max: int;

		super.Initialize( playerInv, delegate );
		max = EnumGetMax( 'SitMiscCategory' );

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
		var result : int;

		result = SITQC_other;

		if( element.IsReadable() )
		{
			if( element.GetFlashObject().GetMemberFlashBool( "isReaded" ) )
			{
				result = SITQC_already_read;
			}
			else
			{
				result = SITQC_not_read_yet;
			}
		}
		return result;
	}

	/*
	Compares two quest or book items.
	Newest item first, then in case of tie, sort by name.
	*/
	protected /*override*/ function Compare( left: SitSortable,
		right: SitSortable,
		optional categoryIndex: int ): int
	{
		var l_new, r_new: bool;
		var result      : int;

		l_new = left.GetFlashObject().GetMemberFlashBool( "isNew" );
		r_new = right.GetFlashObject().GetMemberFlashBool( "isNew" );

		if ( l_new == r_new )
		{
			// Same state, name wins
			result = super.Compare( left, right );
		}
		else if ( l_new )
		{
			result = -1;
		}
		else
		{
			result = 1;
		}
		return result;
	}

	/*
	Returns this sorter name, useful for debugging messages
	*/
	public function ToName(): name
	{
		return 'SitQuestSorter';
	}
}
