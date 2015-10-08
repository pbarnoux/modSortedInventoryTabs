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

	public function Initialize( flashObject: CScriptedFlashObject, baseName: string, localizedName: string): void
	{
		_flashObject = flashObject;
		_name = baseName;
		_localizedName = localizedName;
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
	Returns a human readable string describing this object
	*/
	public function ToString(): string
	{
		return "{class: SitSortable, object : {_name: " + _name + ", _localizedName: " + _localizedName + " } }";
	}
}
