/*
 * Taken from vbcc archive
 *
 * djm 13/3/2000
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
