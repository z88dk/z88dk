/*
 *	Generic sleep() function, relies on an implemented clock()
 *	function
 *
 *	djm 15/10/2001
 *
 *	$Id: sleep.c,v 1.1 2001-10-15 15:20:05 dom Exp $
 */

#include <stdlib.h>
#include <time.h>


int sleep(int secs)
{
        long start = clock();  
	long per   = secs * CLOCKS_PER_SEC;
        
        while ( (clock() - start) < per )
                ;
        return 0;
}

