/*
 *      time_t time(time_t *)
 *
 *      Return number of seconds since epoch
 *
 *      Our epoch is the UNIX epoch of 00:00:00 1/1/1970
 *
 * --------
 * $Id: time.c $
 */


#include <stdlib.h>
#include <time.h>

#define HDOS_DATE 0x20C8
#define HDOS_TIME 0x20CA

/*
    HDOS time, addresses 0x20C8 through 0x02CA:
    0x20C8 - hours in BCD
    0x02C9 - minutes in BCD
    0x02CA - seconds in BCD

    HDOS date, addresses $20C8, $20C9:
    YYYYYYYM MMMDDDDD
    DDDDD - day (1-31)
    MMM - month (1-12)
    YYYYYYY - Year (0-127, year offset is 1900)

    Note that the above is the Y2K encoding for years used by HDOS 3
    with Y2K patches. The older pre-Y2K encoding only used 6 bits and
    the value stored was the year minus 1970.

    Only works under HDOS 3, as HDOS 1 and 2 have no time and date
    support at the operating system level.

*/


// Convert packed BCD byte to integer
static unsigned char bcd_to_int(unsigned char bcd)
{
    return ((bcd >> 4) * 10) + (bcd & 0x0F);
}

time_t time(time_t *store)
{
        time_t tim;
        struct tm t;
        int w;

        t.tm_hour = bcd_to_int(bpeek(HDOS_TIME));
        t.tm_min = bcd_to_int(bpeek(HDOS_TIME+1));
        t.tm_sec = bcd_to_int(bpeek(HDOS_TIME+2));

        w = wpeek(HDOS_DATE);
        t.tm_year = ((w & 0b1111111000000000) >> 9) + 100;
        t.tm_mon = ((w & 0b0000000111100000) >> 5) - 1;
        t.tm_mday = w & 0b0000000000011111;

        t.tm_wday = -1; /* These get filled in by mktime() */
        t.tm_yday = -1;
        t.tm_isdst = -1;

        tim = mktime(&t);

        if (store) {
            *store = tim;
        }

        return (tim);
}
