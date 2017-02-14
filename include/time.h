/*
 *      Small C+ Library
 *
 *      time.h - Time related functions
 *
 *      djm 9/1/2000
 *
 *	$Id: time.h,v 1.23 2016/03/08 10:13:15 dom Exp $
 */


#ifndef __TIME_H__
#define __TIME_H__

#include <sys/compiler.h>
#include <sys/types.h>

#ifdef __Z88__
#define CLOCKS_PER_SEC 100
#endif

#ifdef __X1__
#define CLOCKS_PER_SEC 1
#endif

#ifdef __CPM__
#define CLOCKS_PER_SEC 1
#endif

#ifdef __MC1000__
#define CLOCKS_PER_SEC 368
#endif

#ifdef __OSCA__
#define CLOCKS_PER_SEC 512
#endif

#ifdef __PACMAN__
#define CLOCKS_PER_SEC 61
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

extern struct tm __LIB__ __SAVEFRAME__ *gmtime(time_t *t);
extern struct tm __LIB__  __SAVEFRAME__*localtime(time_t *t);
extern time_t __LIB__  __SAVEFRAME__ mktime(struct tm *tp);



/* This is a really simple fn which will barf over midnight,.. */

#ifndef FAKECLOCK
extern clock_t __LIB__ clock(void);
#endif

extern int FRAMES;

/* This could make srand(time(NULL)) work, but do not expect much more.. */

#ifdef __ENTERPRISE__
#define time(NULL) clock()
#endif

#ifdef __NEWBRAIN__
#define time(NULL) clock()
#endif

#ifdef __RCMX000__
#define time(NULL) clock()
#endif

#ifdef __SPECTRUM__
#define time(NULL) clock()
#endif

#ifdef __ZX81__
#define time(NULL) clock()
#endif

#ifdef __ZX80__
#define time(NULL) clock()
#endif

#ifdef __MC1000__
#define time(NULL) clock()
#endif

#ifdef __OSCA__
#define time(NULL) clock()
#endif

#ifdef __PACMAN__
#define time(NULL) clock()
#endif


#endif /* _TIME_H */
