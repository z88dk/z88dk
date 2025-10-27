/*
 *	asctime() — Convert Time to Character String
 *
 *	by Stefano Bodrato, Sep, 2019
 *
 *	
 * --------
 * $Id: asctime.c $
 */


#include <time.h>
#include <stdlib.h>
#include <string.h>

char    time_buf[26];
char	num_buf[5];

char *to_str(int datum)
{
	char *bufptr;
	
	bufptr=num_buf;
	bufptr[0]='0';
	if (datum < 10)
		bufptr++;
	itoa (datum, bufptr, 10);
	
	return (num_buf);
}

static char daynames[] = "SunMonTueWedThuFriSat";
static char monthnames[] = "JanFebMarAprMayJunJulAugSepOctNovDec";

dayofweek(int year, int month, int day)
/*
 * Return the day of the week on which this date falls: Sunday = 0.
 * Note, this routine is valid only for the Gregorian calender.
 *
 * This routine was in "today.c", by Martin Minow
 */
{
	unsigned int yearfactor;
	month++;

	yearfactor = year + (month - 14)/12;
	return (( (13 * (month + 10 - (month + 10)/13*12) - 1)/5
		+ day + 77 + 5 * (yearfactor % 100)/4
		+ yearfactor / 400
		- yearfactor / 100 * 2) % 7);
}


char *asctime(struct tm *time) 
{
    /* Output example: */
	/* Sat Jul 16 02:03:55 1994\n\0 */

	/* Init output buffer in a safe, direct way */
	memset(time_buf,' ',26);
	time_buf[24]='\n';
	time_buf[25]='\0';
	time_buf[13]=':';
	time_buf[16]=':';
	
	memcpy(time_buf,daynames+dayofweek(1900+time->tm_year,time->tm_mon,time->tm_mday)*3,3);
	memcpy(time_buf+4,monthnames+time->tm_mon*3,3);
	memcpy(time_buf+8,to_str(time->tm_mday),2);
	memcpy(time_buf+11,to_str(time->tm_hour),2);
	memcpy(time_buf+14,to_str(time->tm_min),2);
	memcpy(time_buf+17,to_str(time->tm_sec),2);
	memcpy(time_buf+20,to_str(1900+time->tm_year),4);
	
	return (time_buf);
}



#ifdef TESTING

#include <stdio.h>

main()
{
    struct tm *newtime;
    time_t ltime;
 
/* Get the time in seconds */
    time(&ltime);
/* Convert it to the structure tm */
    newtime = localtime(&ltime);
 
        /* Print the local time as a string */
    printf("The current date and time are %s",
             asctime(newtime));
}

#endif /* TESTING */
