/*
Change order of elements in the tab by modifying the indexes
Make sure to use unique continuous positive integers starting at 0
Categories are sorted by these index (first, items of the category 0, then items of the category 1, and so on...)
*/
enum SitOtherCategory
{
	SITOC_currency = 0,
	SITOC_other    = 1,
	SITOC_junk     = 2,
}

/*
Sort logic adapted to the 'other tab' of the inventory.
*/
class SitOtherSorter extends SitSorter
{
	protected var _currencies: array < SitSortable >;
	protected var _junks     : array < SitSortable >;
	protected var _others    : array < SitSortable >;

	/*
	Create containers for each category.
	Containers are sorted accorded to the SitOtherCategory enumeration.
	*/
	public /*override*/ function Initialize( optional delegate: SitSorter ): void
	{
		var index, max: int;

		super.Initialize( delegate );
		max = EnumGetMax( 'SitOtherCategory' );

		for( index = 0; index <= max; index += 1 )
		{
			switch( index )
			{
				case SITOC_currency:
					_categories.PushBack( _currencies );
					break;
				case SITOC_junk:
					_categories.PushBack( _junks );
					break;
				default:
					_categories.PushBack( _others );
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

		result = SITOC_other;
		flashObject = element.GetFlashObject();
		categoryName = flashObject.GetMemberFlashString( "category" );
		elementName = element.GetName();

		if( elementName == "Orens" || elementName == "Florens" )
		{
			result = SITOC_currency;
		}
		else if( categoryName == "junk" )
		{
			result = SITOC_junk;
		}
		return result;
	}
}
