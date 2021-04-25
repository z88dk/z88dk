
#include <time.h>

time_t mktime(struct tm *tp)
{
    return tp->tm_sec + tp->tm_min*60 + tp->tm_hour*3600 + tp->tm_yday*86400 +
    (tp->tm_year-70)*31536000 + ((tp->tm_year-69)/4)*86400 -
    ((tp->tm_year-1)/100)*86400 + ((tp->tm_year+299)/400)*86400;
}
