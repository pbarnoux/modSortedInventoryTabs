/*
Change order of elements in the tab by modifying the indexes
Make sure to use unique continuous positive integers starting at 0
Categories are sorted by these index (first, items of the category 0, then items of the category 1, and so on...)
*/
enum SitOtherCategory
{
	SITOC_currencies = 0,
	SITOC_others     = 1,
	SITOC_junks      = 2,
}

/*
Sort logic adapted to the 'usable tab' of the inventory.
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
	public function Initialize( optional delegate: SitSorter ): void
	{
		var index: int;
		super.Initialize( delegate );

		/*
		Currently still looking for a way to obtain the number of elements of an enum.
		Till then, the loop max index must be updated when literal is added/removed to SitOtherCategory.
		*/
		for( index = 0; index < 3; index += 1 )
		{
			switch( index )
			{
				case SITOC_currencies:
					_categories.PushBack( _currencies );
					break;
				case SITOC_junks:
					_categories.PushBack( _junks );
					break;
				default:
					_categories.PushBack( _others );
			}
		}
		LogChannel( 'MOD_SIT', "SitOtherSorter initialized ; number of categories : " + _categories.Size() );
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
		elementName = element.GetName();

		if( elementName == "Orens" || elementName == "Florens" )
		{
			return SITOC_currencies;
		}

		if( categoryName == "junk" )
		{
			return SITOC_junks;
		}
		return SITOC_others;
	}
}
