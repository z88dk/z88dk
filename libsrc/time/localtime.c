/*
 * Taken from vbcc archive
 *
 * djm 13/3/2000
 *	
 * --------
 * $Id: localtime.c,v 1.2 2001-04-18 12:40:07 stefano Exp $
 */


#include <time.h>

/* z88 doesn't hold timezone details :( 
 * Define this to hold number of minutess off GMT
 */
#define GMTOFFSET 0

struct tm *localtime(const time_t *t)
{ time_t ti=*t;
  ti-=GMTOFFSET*60;
  return gmtime(&ti);
}
