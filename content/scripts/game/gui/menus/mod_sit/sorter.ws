/*
Base logic of the sorting mechanism. Specific features are found in methods overriden by subclasses.
*/
abstract class SitSorter
{
	protected var _categories : array < array < SitSortable > >;

	public function Initialize(): void
	{
		LogChannel( 'MOD_SIT', "SitSorter initialized" );
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
		LogChannel( 'MOD_SIT', "SitSorter.Sort sorting " + length + " elements" );

		for( index = 0; index < length; index += 1 )
		{
			element = sortables[ index ];
			categoryIndex = GetCategoryIndex( element );
			AddToCategory( categoryIndex, element );
		}
		entriesArray.ClearElements();
		FlattenCategories( entriesArray );
		length = entriesArray.GetLength();
		LogChannel( 'MOD_SIT', "SitSorter.Sort sorted " + length + " elements" );
	}

	/*
	Assign a category to the given element.
	*/
	protected function GetCategoryIndex( element: SitSortable ): int
	{
		// Make sure to always override this method, unfortunately, cannot put it abstract
		return 0;
	}

	/*
	Compares two sortable elements between them
	Returns a negative integer if the left element should be sorted before the right one,
	0 if both elements cannot be distinguished, a positive integer otherwise
	*/
	protected function Compare( left: SitSortable, right: SitSortable ): int
	{
		// Make sure to always override this method, unfortunately, cannot put it abstract
		return 0;
	}

	/*
	Inserts the element inside a category at the best position according to item status.
	*/
	private function AddToCategory( categoryIndex: int, element: SitSortable ): void
	{
		var length, index: int;

		LogChannel( 'MOD_SIT', "SitSorter.AddToCategory " + categoryIndex + ", " + element.ToString() );
		length = _categories[ categoryIndex ].Size();

		for( index = 0; index < length; index += 1 )
		{
			if ( Compare( element, _categories[ categoryIndex ][ index ] ) < 0 )
			{
				_categories[ categoryIndex ].Insert( index, element );
				return;
			}
		}
		_categories[ categoryIndex ].PushBack( element );
	}

	/*
	Flattens the two-dimensional array of items into a single dimension array of items.
	*/
	private function FlattenCategories( out entriesArray: CScriptedFlashArray ): void
	{
		var length, index: int;

		length = _categories.Size();
		LogChannel( 'MOD_SIT', "SitSorter.FlattenCategories processing " + length + " categories" );

		for( index = 0; index < length; index += 1 )
		{
			AppendTo( entriesArray, index );
		}
	}

	/*
	Adds all elements of a given category.
	Elements gridPosition is altered by this method.
	*/
	private function AppendTo( out entriesArray: CScriptedFlashArray, categoryIndex: int ): void
	{
		var length, index, offset: int;
		var element: CScriptedFlashObject;

		length = _categories[ categoryIndex ].Size();
		offset = entriesArray.GetLength();
		LogChannel( 'MOD_SIT', "SitSorter.AppendTo " + length + " elements, offset: " + offset );

		for( index = 0; index < length; index += 1 )
		{
			element = _categories[ categoryIndex ][ index ].GetFlashObject();
			element.SetMemberFlashInt( "gridPosition", index + offset );
			entriesArray.PushBackFlashObject( element );
		}
	}
}