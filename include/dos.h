/*
 *      Small C+ Library
 *
 *      dos.h - Turbo C compatiblity stuff
 *      This file includes very dirty tricks, watch out !
 *
 *      stefano2012
 *
 *	$Id: dos.h,v 1.3 2012-05-22 19:54:36 stefano Exp $
 */


#ifndef __DOS_H__
#define __DOS_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <time.h>
#include <sound.h>

struct date {
	int da_day;
	int da_mon;
	int da_year;
};

struct time {
	int ti_sec;
	int ti_min;
	int ti_hour;
	int ti_hund;
};

/*
extern void __LIB__ getdate(struct date *);
extern void __LIB__ gettime(struct time *);
extern void __LIB__ setdate(struct date *);
extern void __LIB__ settime(struct time *);
*/

//#define delay(a) bit_beep(1+a/150,50000);

#endif /* __DOS_H__ */
