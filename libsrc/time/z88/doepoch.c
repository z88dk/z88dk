/*
 *	time_t doepochtime_t day, time_t sec)
 *
 *	Convert the z88 native time to UNIX style
 *
 *	Our epoch is the UNIX epoch of 00:00:00 1/1/1970
 *
 */


#include <time.h>

time_t doepoch(time_t days, time_t sec)
{

	days-=get1970();	/* Subtract the 1970 date */

	days*=86400L;		/* # of seconds */

	return (days+sec);
}




