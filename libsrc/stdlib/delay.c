/*
 *	Generic sleep() function, relies on an implemented clock()
 *	function
 *
 *	djm 15/10/2001
 *
 *	$Id: delay.c,v 1.1 2012-05-16 16:59:56 stefano Exp $
 */

#include <stdlib.h>
#include <time.h>


void   delay (long msecs)
{
    long start = clock();  
	long per   = msecs * CLOCKS_PER_SEC / 1000;
        
        while ( (clock() - start) < per )
                ;
}

