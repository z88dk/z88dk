/*
 *	ctime() — Convert Time to Character String
 *
 *	by Stefano Bodrato, Sep, 2019
 *
 *	
 * --------
 * $Id: ctime.c $
 */


#include <time.h>

char *ctime(time_t *t) 
{
	struct tm * timeinfo;
	
	timeinfo = localtime (t);
	return (asctime(timeinfo));
}

