
#include <time.h>

// Number of days (-1) that have elapsed at the end of the month
static int yday[] = { -1, 30, 58, 89, 119, 150, 180, 211, 242, 272, 303, 333 };

time_t mktime(struct tm *tp)
{
    return tp->tm_sec + tp->tm_min*60 + tp->tm_hour*3600L + (yday[tp->tm_mon] + tp->tm_mday)*86400 +
    (tp->tm_year-70)*31536000 + ((tp->tm_year-69)/4)*86400 -
    ((tp->tm_year-1)/100)*86400 + ((tp->tm_year+299)/400)*86400;
}
