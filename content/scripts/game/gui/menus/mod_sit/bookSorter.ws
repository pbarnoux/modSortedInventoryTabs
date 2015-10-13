/*
Change order of elements in the tab by modifying the indexes
Make sure to use unique continuous positive integers starting at 0
Categories are sorted by these index (first, items of the category 0, then items of the category 1, and so on...)
*/
enum SitBookCategory
{
	SITQC_not_read_yet = 0,
	SITQC_already_read = 1,
	SITQC_other        = 2,
}

/*
Sort logic adapted to the 'quest tab' of the inventory.
*/
class SitBookSorter extends SitSorter
{
	private var _unread: array < SitSortable >;
	private var _read  : array < SitSortable >;
	private var _others: array < SitSortable >;

	/*
	Create containers for each category.
	Containers are sorted accorded to the SitBookCategory enumeration.
	*/
	public function Initialize(): void
	{
		var index: int;

		/*
		Currently still looking for a way to obtain the number of elements of an enum.
		Till then, the loop max index must be updated when literal is added/removed to SitBookCategory.
		*/
		for( index = 0; index < 3; index += 1 )
		{
			switch( index )
			{
				case SITQC_not_read_yet:
					_categories.PushBack( _unread );
					break;
				case SITQC_already_read:
					_categories.PushBack( _read );
					break;
				default:
					_categories.PushBack( _others );
			}
		}
		LogChannel( 'MOD_SIT', "SitBookSorter initialized ; number of categories : " + _categories.Size() );
	}

	/*
	Overrides GetCategoryIndex from sorter.ws
	Returns the index of the category assigned to the given element.
	*/
	protected function GetCategoryIndex( element: SitSortable ): int
	{
		if( element.IsReadable() )
		{
			if( element.GetFlashObject().GetMemberFlashBool( "isReaded" ) )
			{
				return SITQC_already_read;
			}
			return SITQC_not_read_yet;
		}
		return SITQC_other;
	}

	/*
	Overrides Compare from sorter.ws
	Compares two sortable elements between them
	Returns a negative integer if the left element should be sorted before the right one,
	0 if both elements cannot be distinguished, a positive integer otherwise
	*/
	protected function Compare( left: SitSortable, right: SitSortable ): int
	{
		// Newest items first, then sort by name
		var l_new, r_new: bool;
		var l_localizedName, r_localizedName: string;
		var strLen: int;

		l_new = left.GetFlashObject().GetMemberFlashBool( "isNew" );
		r_new = right.GetFlashObject().GetMemberFlashBool( "isNew" );
		l_localizedName = left.GetLocalizedName();
		r_localizedName = right.GetLocalizedName();

		if ( l_new == r_new )
		{
			// Same state, name wins
			strLen = Min( StrLen( l_localizedName ), StrLen( r_localizedName ) );
			return StrCmp( l_localizedName, r_localizedName, strLen, true );
		}

		if ( l_new )
		{
			return -1;
		}
		else
		{
			return 1;
		}
	}
}
