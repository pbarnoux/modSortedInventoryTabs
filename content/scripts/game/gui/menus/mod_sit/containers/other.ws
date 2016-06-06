/*
Change order of elements in the tab by modifying the indexes
Make sure to use unique continuous positive integers starting at 0
Categories are sorted by these index (first, items of the category 0, then items of the category 1, and so on...)
*/
enum SitMiscCategory
{
	SITMC_currency     = 0,
	SITMC_not_read_yet = 1,
	SITMC_already_read = 2,
	SITMC_other        = 3,
	SITMC_junk         = 4,
}
