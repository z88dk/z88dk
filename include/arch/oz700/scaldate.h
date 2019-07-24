/* 
	HTC Compatibility Library and OZ extras 


 * +++Date last modified: 05-Jul-1997 *
 
** scalar date routines    --    public domain by Ray Gardner
** Numerically, these will work over the range 1/01/01 thru 14699/12/31.
** Practically, these only work from the beginning of the Gregorian
** calendar thru 14699/12/31.  The Gregorian calendar took effect in
** much of Europe in about 1582, some parts of Germany in about 1700, in
** England and the colonies in about 1752ff, and in Russia in 1918.

Ported to Z88DK by Stefano Bodrato - Oct. 2003

	$Id: scaldate.h,v 1.1 2003-10-21 17:15:19 stefano Exp $
*/


#ifndef SCALDATE__H
#define SCALDATE__H

typedef enum {Error_ = -1, Success_, False_ = 0, True_} Boolean_T;

/*
**  Define ISO_CAL to be 1 for ISO (Mon-Sun) calendars
**
**  ISO defines the first week with 4 or more days in it to be week #1.
*/

#ifndef ISO_CAL
#define ISO_CAL 0
#endif

#if (ISO_CAL != 0 && ISO_CAL != 1)
 #error ISO_CAL must be set to either 0 or 1
#endif

#if ISO_CAL
 enum DOW_T {DOW_IGNORE = -1,
       MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY};
#else
 enum DOW_T {DOW_IGNORE = -1,
       SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY};
#endif

/*
**  Daylight savings time rules.
**
**  Rules include a month, date, and day. If the day is DOW_IGNORE, DST will
**  start on the month and date specified. If a day is specified (the
**  interpretation of the day parameter is subject to the value of ISO_CAL),
**  DST will start on the first such day following (or equal to) the specified
**  date, or stop on the first such day preceding (or equal to) the specified
**  date.
**
**  The defaults defined for the U.S. mean that DST will begin on the first
**  Sunday after (or on) April 1 and end on the last Sunday preceding (or on)
**  October 31.
*/

extern unsigned   DST_start_mo;
extern unsigned   DST_start_dt;
extern enum DOW_T DST_start_dy;

extern unsigned   DST_stop_mo;
extern unsigned   DST_stop_dt;
extern enum DOW_T DST_stop_dy;

int  isleap (unsigned yr);
long ymd_to_scalar (unsigned yr, unsigned mo, unsigned day);
void scalar_to_ymd (long scalar, unsigned *yr, unsigned *mo, unsigned *day);
int  daynum(int year, int month, int day);
int  weeknum(int year, int month, int day);

Boolean_T valiDate(unsigned yr, unsigned mo, unsigned day);

unsigned dow(unsigned yr, unsigned mo, unsigned day);
unsigned DOW(unsigned y, unsigned m, unsigned d);

long today(void);

extern char *MoonPhaseText[8];

unsigned moonphase(unsigned yr, unsigned mo, unsigned dy);

int getfdate (int handle, long *date);
int getdatef (char *fname, long *date);


#endif /* SCALDATE__H */
