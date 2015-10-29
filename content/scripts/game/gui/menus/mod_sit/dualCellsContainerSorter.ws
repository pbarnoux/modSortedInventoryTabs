/*
Specialize SitSorter to handle tabs containing items spanning on two cells (axes, swords ...)
*/
abstract class SitDualCellsContainerSorter extends SitSorter
{
	/*
	Computes the gridPposition of an item on the grid taking care of size of items.
	*/
	protected /*override*/ function PlaceAt( element: SitSortable, offset: int, index: int): int
	{
		var gridSize, position: int;

		position = super.PlaceAt( element, offset, index );
		gridSize = Clamp( element.GetGridSize(), 1, 2 );

		if( position < _free_slot )
		{
			// Shift to the next slot
			// This slot is used by another item that had to be shifted (see while below for reason)
			position = _free_slot;
		}

		while( _reserved_slots.Contains( position ) )
		{
			// Shift to the next slot
			// This slot is used by the bottom cell of a dual cells item
			position += 1;
		}

		if( gridSize == 2 )
		{
			// Mark the bottom cell (+8 == next row, same column) as used
			_reserved_slots.PushBack( position + 8 );
		}
		// Since the cursor might have shifted, mark the next available slot as the next one
		_free_slot = position + 1;
		return position;
	}
}
