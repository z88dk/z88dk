/*
 *      Small C+ Library
 *
 *      time.h - Time related functions
 *
 *      djm 9/1/2000
 *
 *	$Id: time.h,v 1.13 2010-09-19 00:24:08 dom Exp $
 */


#ifndef __TIME_H__
#define __TIME_H__

#include <sys/compiler.h>
#include <sys/types.h>

#ifdef __Z88__
#define CLOCKS_PER_SEC 100
#endif

#ifndef CLOCKS_PER_SEC
#define CLOCKS_PER_SEC 50
#endif


extern time_t __LIB__ time(time_t *);


struct tm {
	int tm_sec;
	int tm_min;
	int tm_hour;
	int tm_mday;
	int tm_mon;
	int tm_year;
	int tm_wday;
	int tm_yday;
	int tm_isdst;
};

/*
 * These routines fill in the structure above using the value
 * supplied in t (usu obtained from time()
 *
 * These two really do the same since the z88 has no concept 
 * of timezones
 */

extern struct tm __LIB__ *gmtime(time_t *t);
extern struct tm __LIB__ *localtime(time_t *t);
extern time_t __LIB__ mktime(struct tm *tp);



/* This is a really simple fn which will barf over midnight,.. */

#ifndef FAKECLOCK
extern clock_t __LIB__ clock(void);
#endif




#endif /* _TIME_H */
