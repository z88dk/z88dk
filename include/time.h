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
#include <stdint.h>

#ifdef __X1__
#define CLOCKS_PER_SEC 1
#endif

#ifdef __PC88__
#define CLOCKS_PER_SEC 60
#endif

#ifdef __PACMAN__
#define CLOCKS_PER_SEC 61
#endif

#ifdef __Z88__
#define CLOCKS_PER_SEC 100
#endif

#ifdef __GAL__
#define CLOCKS_PER_SEC 100
#endif
#ifdef __MTX__
#define CLOCKS_PER_SEC 125
#endif

#ifdef __CPC__
#define CLOCKS_PER_SEC 300
#endif

#ifdef __MC1000__
#define CLOCKS_PER_SEC 368
#endif

#ifdef __OSCA__
#define CLOCKS_PER_SEC 512
#endif

#ifdef __TESTTARGET__
#define CLOCKS_PER_SEC 1000
#endif

#ifdef __CPM__
#ifndef CLOCKS_PER_SEC
#define CLOCKS_PER_SEC 1
#endif
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

extern struct tm __LIB__ __SAVEFRAME__ *gmtime(const time_t *t);
extern struct tm __LIB__  __SAVEFRAME__*localtime(const time_t *t);
extern time_t __LIB__  __SAVEFRAME__ mktime(struct tm *tp);
extern char __LIB__  __SAVEFRAME__ *asctime(struct tm *tp);
extern char __LIB__  __SAVEFRAME__*ctime(const time_t *t);


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

// MSDOS Time for FAT

struct dos_tm
{
   uint16_t time;
   uint16_t date;
};

// dos time affects tm.tm_sec through tm.tm_year
// Not available on 8080 targets

extern void __LIB__ dostm_from_tm(struct dos_tm *,struct tm *) __smallc;
extern void __LIB__ dostm_from_tm_callee(struct dos_tm *,struct tm *) __smallc __z88dk_callee;
#define dostm_from_tm(a,b) dostm_from_tm_callee(a,b)


extern void __LIB__ tm_from_dostm(struct tm *,struct dos_tm *) __smallc;
extern void __LIB__ tm_from_dostm_callee(struct tm *,struct dos_tm *) __smallc __z88dk_callee;
#define tm_from_dostm(a,b) tm_from_dostm_callee(a,b)


#endif /* _TIME_H */
