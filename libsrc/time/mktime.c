
#include <time.h>

static int yday[] = { 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 };
time_t mktime(struct tm *tp)
{
    return tp->tm_sec + tp->tm_min*60 + tp->tm_hour*3600L + (yday[tp->tm_mon] + tp->tm_mday)*86400 +
    (tp->tm_year-70)*31536000 + ((tp->tm_year-69)/4)*86400 -
    ((tp->tm_year-1)/100)*86400 + ((tp->tm_year+299)/400)*86400;
}
