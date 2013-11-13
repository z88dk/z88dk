/*
 *	time_t time(time_t *)
 *
 *	Return number of seconds since epoch
 *
 *	Our epoch is the UNIX epoch of 00:00:00 1/1/1970
 *
 * --------
 * $Id: time.c,v 1.2 2013-11-13 20:46:42 stefano Exp $
 */


#include <time.h>
#include <x1.h>

unsigned int unbcd(unsigned int value) {
	return ( (value >> 4) * 10 + (value & 15) );
}

time_t time(time_t *store)
{
	long    days;
	time_t	tim;


	struct tm t;

	subcpu_command(SUBCPU_GET_CALENDAR);
	t.tm_year  =  subcpu_get()-1900;
    t.tm_mon   =  subcpu_get()-1;
    t.tm_mday  =  subcpu_get();

	subcpu_command(SUBCPU_GET_CLOCK);
    t.tm_hour  =  unbcd(subcpu_get());
    t.tm_min   =  unbcd(subcpu_get());
    t.tm_sec   =  unbcd(subcpu_get());
    t.tm_isdst = -1;

    tim = mktime(&t);

	if (store) *store=tim;

	return (tim);
}

