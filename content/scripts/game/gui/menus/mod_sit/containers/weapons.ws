/*
Change order of elements in the tab by modifying the indexes
Make sure to use unique continuous positive integers starting at 0
Categories are sorted by these index (first, items of the category 0, then items of the category 1, and so on...)
For best results, put items covering a single cell before items spanning on two cells.
*/
enum SitWeaponsCategory
{
	// Categories containing items covering a single cell
	SITWC_rune         = 0,
	SITWC_weapon_tool  = 1,
	// Categories containing items spanning on two cells
	SITWC_steel_sword  = 2,
	SITWC_silver_sword = 3,
	SITWC_crossbow     = 4,
	SITWC_bolt         = 5,
	SITWC_other        = 6,
}
