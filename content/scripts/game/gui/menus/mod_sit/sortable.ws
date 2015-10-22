/*
Wrapper around the object created by the legacy code
Allows to store additional data relevant to the sort algorithm
without messing with the internal structure of the flash object.
*/
class SitSortable
{
	private var _flashObject  : CScriptedFlashObject;
	private var _name         : string;
	private var _localizedName: string;
	private var _unitPrice    : int;
	private var _gridSize     : int;
	private var _readable     : bool; default _readable   = false;
	private var _sellable     : bool; default _sellable   = false;
	private var _consumable   : bool; default _consumable = false;
	private var _freeForUse   : bool; default _freeForUse = false;

	public function Initialize( flashObject: CScriptedFlashObject,
		baseName: string,
		localizedName: string,
		unitPrice: int,
		gridSize: int ): void
	{
		_flashObject = flashObject;
		_name = baseName;
		_localizedName = localizedName;
		_unitPrice = unitPrice;
		_gridSize = gridSize;
	}

	/*
	Some setters to modify this object state.
	I like immutability, but too many fields now for a single initializer. KISS wins in this case.
	*/
	public function SetReadable( flag: bool ): void
	{
		_readable = flag;
	}

	public function SetSellable( flag: bool ): void
	{
		_sellable = flag;
	}

	public function SetConsumable( flag: bool ): void
	{
		_consumable = flag;
	}

	public function SetFreeForUse( flag: bool ): void
	{
		_freeForUse = flag;
	}

	/*
	Returns the wrapped FlashObject
	*/
	public function GetFlashObject(): CScriptedFlashObject
	{
		return _flashObject;
	}

	/*
	Returns the wrapped name
	*/
	public function GetName(): string
	{
		return _name;
	}

	/*
	Returns the wrapped localized name
	*/
	public function GetLocalizedName(): string
	{
		return _localizedName;
	}

	/*
	Returns the unit price
	*/
	public function GetUnitPrice(): int
	{
		return _unitPrice;
	}

	/*
	Returns the wrapped grid size
	*/
	public function GetGridSize(): int
	{
		return _gridSize;
	}
	/*
	Returns true if this item is readable
	*/
	public function IsReadable(): bool
	{
		return _readable;
	}

	/*
	Returns true if this item can be sold
	*/
	public function IsSellable(): bool
	{
		return _sellable;
	}

	/*
	Returns true if this item can be consumed
	*/
	public function IsConsumable(): bool
	{
		return _consumable;
	}

	/*
	Returns true if using this item cost nothing to the player (hey that is a fantasy world after all)
	*/
	public function IsFreeForUse(): bool
	{
		return _freeForUse;
	}

	/*
	Returns a human readable string describing this object
	*/
	public function ToString(): string
	{
		return "{class: SitSortable, object : {_name: " + _name + ", _localizedName: " + _localizedName + " } }";
	}
}
