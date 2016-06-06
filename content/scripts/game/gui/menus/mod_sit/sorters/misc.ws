/*
Sort logic adapted to the 'other tab' of the inventory.
*/
class SitMiscSorter extends SitSorter
{
	protected var _currencies: array < SitSortable >;
	protected var _junks     : array < SitSortable >;
	protected var _others    : array < SitSortable >;

	/*
	Create containers for each category.
	Containers are sorted accorded to the SitOtherCategory enumeration.
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
		var categoryName: string;
		var elementName : string;
		var flashObject : CScriptedFlashObject;
		var result      : int;

		result = SITMC_other;
		flashObject = element.GetFlashObject();
		categoryName = flashObject.GetMemberFlashString( "category" );
		elementName = element.GetName();

		if( element.IsReadable() )
		{
			if( element.GetFlashObject().GetMemberFlashBool( "isReaded" ) )
			{
				result = SITMC_already_read;
			}
			else
			{
				result = SITMC_not_read_yet;
			}
		}
		else if( elementName == "Orens" || elementName == "Florens" )
		{
			result = SITMC_currency;
		}
		else if( categoryName == "junk" )
		{
			result = SITMC_junk;
		}
		return result;
	}

	/*
	Returns this sorter name, useful for debugging messages
	*/
	public function ToName(): name
	{
		return 'SitMiscSorter';
	}
}
