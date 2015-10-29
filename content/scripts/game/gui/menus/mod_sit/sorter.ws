/*
Base logic of the sorting mechanism.
Specific features are found in methods overriden by subclasses.
*/
abstract class SitSorter
{
	/* The list of categories */
	protected var _categories    : array < array < SitSortable > >;
	/* A list of grid slots indexes used by items spanning on two cells (axes, swords ...). */
	protected var _reserved_slots: array < int >;
	/* Contains the nearest index of a free slot on the grid */
	protected var _free_slot     : int; default _free_slot = 0;

	public function Initialize( optional delegate: SitSorter ): void
	{
		// Nothing to do at this level
	}

	/*
	Sorts the given element. First, each element is assigned to a category.
	Then elements are reordered based on the category priority.
	*/
	public function Sort( sortables: array < SitSortable >, out entriesArray: CScriptedFlashArray ): void
	{
		var length, index, categoryIndex: int;
		var element: SitSortable;

		length = entriesArray.GetLength();

		for( index = 0; index < length; index += 1 )
		{
			element = sortables[ index ];
			AddToCategory( element );
		}
		entriesArray.ClearElements();
		FlattenCategories( entriesArray );
		length = entriesArray.GetLength();
	}

	/*
	Assigns a category to the given element.
	*/
	protected function GetCategoryIndex( element: SitSortable ): int
	{
		// Make sure to always override this method, unfortunately, cannot put it abstract.
		// Returning -1 should crash the game immediately and warn modder than something was missed.
		return -1;
	}

	/*
	Compares two sortable elements between them
	Returns a negative integer if the left element should be sorted before the right one,
	0 if both elements cannot be distinguished, a positive integer otherwise.
	The optional index is always provided by this Sorter, enabling category based rules in subclasses.
	By default, compares on localized name in natural order (case insensitive).
	*/
	protected function Compare( left: SitSortable, right: SitSortable, optional categoryIndex: int ): int
	{
		var l_localizedName, r_localizedName: string;
		var strLen: int;

		l_localizedName = left.GetLocalizedName();
		r_localizedName = right.GetLocalizedName();
		strLen = Min( StrLen( l_localizedName ), StrLen( r_localizedName ) );
		return StrCmp( l_localizedName, r_localizedName, strLen, true );
	}

	/*
	Inserts the element inside a category at the best position.
	*/
	protected function AddToCategory( element: SitSortable ): void
	{
		var length, index, categoryIndex: int;

		// Find the best category for this element
		categoryIndex = GetCategoryIndex( element );
		length = _categories[ categoryIndex ].Size();

		for( index = 0; index < length; index += 1 )
		{
			if ( Compare( element, _categories[ categoryIndex ][ index ], categoryIndex ) < 0 )
			{
				// Insert this element at 'index' because it precedes the next one
				_categories[ categoryIndex ].Insert( index, element );
				return;
			}
		}
		// This element precedes no one else, insert it at the end
		_categories[ categoryIndex ].PushBack( element );
	}

	/*
	Flattens the two-dimensional array of items into a single dimension array of items.
	*/
	protected function FlattenCategories( out entriesArray: CScriptedFlashArray ): void
	{
		var length, index: int;

		length = _categories.Size();

		for( index = 0; index < length; index += 1 )
		{
			AppendTo( entriesArray, index );
		}
	}

	/*
	Appends all items of a given category into a mutated array.
	For each element, the gridPosition value is altered to ensure items are effectively sorted on the grid.
	*/
	private function AppendTo( out entriesArray: CScriptedFlashArray, categoryIndex: int ): void
	{
		var length, index, offset, position: int;
		var flashObj: CScriptedFlashObject;
		var element : SitSortable;

		length = _categories[ categoryIndex ].Size();
		offset = entriesArray.GetLength();

		for( index = 0; index < length; index += 1 )
		{
			element = _categories[ categoryIndex ][ index ];
			flashObj = element.GetFlashObject();
			position = PlaceAt( element, offset, index );
			flashObj.SetMemberFlashInt( "gridPosition", position );
			entriesArray.PushBackFlashObject( flashObj );
		}
	}

	/*
	Computes the gridPosition of an item on the grid.
	The offset is the number of elements from other categories already processed.
	The index is the number of elements from the same category already processed.
	*/
	protected function PlaceAt( element: SitSortable, offset: int, index: int): int
	{
		// Most tabs have only items covering a unique cell.
		// The gridPosition is equal to the number of items already processed.
		// Other tabs are handled by dualCellsContainerSorter.ws
		return offset + index;
	}
}
