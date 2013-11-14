/*
 *	time_t time(time_t *)
 *
 *	Return number of seconds since epoch
 *
 *	Our epoch is the UNIX epoch of 00:00:00 1/1/1970
 *
 * --------
 * $Id: time.c,v 1.3 2013-11-14 06:57:05 stefano Exp $
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
	t.tm_year  =  unbcd(subcpu_get())+100;
    t.tm_mon   =  unbcd(subcpu_get()>>4)-1;
    t.tm_mday  =  unbcd(subcpu_get());

	subcpu_command(SUBCPU_GET_CLOCK);
    t.tm_hour  =  unbcd(subcpu_get());
    t.tm_min   =  unbcd(subcpu_get());
    t.tm_sec   =  unbcd(subcpu_get());
    t.tm_isdst = -1;

    tim = mktime(&t);

	if (store) *store=tim;

	return (tim);
}

