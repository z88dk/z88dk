/*
 *	time_t time(time_t *)
 *
 *	Return number of seconds since epoch
 *
 *	Our epoch is the UNIX epoch of 00:00:00 1/1/1970
 *
 */


#include <time.h>

time_t time(time_t *store)
{
	time_t	tim;

	tim=doepoch(gtoy(),clock());

	if (store) *store=tim;

	return (tim);
}




