/* Nicely hacked mktime.c - assumes a valid struct tp */

#include <time.h>
#include <stdio.h>

#define EPOCH_YEAR 1970
#define SECS_PER_DAY  86400UL
#define SECS_PER_HOUR  3600UL
#define SECS_PER_MIN     60UL

const int _ytab[24] = {
    31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31,
    31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

static int is_leap( int year )
{
    
    if( year % 100 == 0 ) {
	return year % 400 == 0;
    }

    return year % 4 == 0;
}

#ifdef TEST
time_t mktime2(struct tm *tp)
#else
time_t mktime(struct tm *tp)
#endif
{
    unsigned long days = 0UL;
    int           i,j,year;

    if ( tp->tm_year  < EPOCH_YEAR - 1900 ) 
	return -1L;

    for ( i = EPOCH_YEAR; i < ( tp->tm_year + 1900  ); i++ ) {
	for ( j = 0; j < 12; j++ ) {
	    days += _ytab[(is_leap(i) * 12) + j ];

	}
    }

    for ( i = 0; i < tp->tm_mon  ; i++ ) 
	days += _ytab[(is_leap(i) * 12) + i ];


    days += (tp->tm_mday-1);



    /* So days has the number of days since the epoch */
    days *= SECS_PER_DAY;
    

    days += ( tp->tm_hour * SECS_PER_HOUR ) + ( tp->tm_min * SECS_PER_MIN ) + tp->tm_sec;

    return days;
}

#ifdef TEST
int main()
{
    time_t tim = time(NULL);
    time_t tim2;
    struct tm *tp;

    tp = gmtime(&tim);

    printf("unix gives %ld\n",tim);

    tim2 = mktime2(tp);

    printf("routines gives %ld\n",tim);

    printf("%d\n",(tim2-tim)/86400);
}
#endif
