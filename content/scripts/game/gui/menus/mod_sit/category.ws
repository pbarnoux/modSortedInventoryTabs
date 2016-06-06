/*
Mod entry point when not dealing with a NPC.
Notified when some methods are triggered in base scripts.
*/
class SitCategory
{
	protected var _elements : array < SitSortable >;

	/*
	Push back the given element at the end of the wrapped array.
	*/
	public function PushBack( element: SitSortable ): void
	{
		_elements.PushBack( element );
	}

	/*
	Insert the given element at the given index in the wrapped array.
	*/
	public function Insert( index: int, element: SitSortable ): void
	{
		_elements.Insert( index, element );
	}

	/*
	Returns the size of the wrapped array.
	*/
	public function Size(): int
	{
		return _elements.Size();
	}

	/*
	Returns the element at the given index in the wrapped array.
	*/
	public function At( index: int ): SitSortable
	{
		if ( index >= 0 && index < _elements.Size() )
		{
			return _elements[ index ];
		}
		return NULL;
	}
}
