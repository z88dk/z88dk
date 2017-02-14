/*
 *	Generic sleep() function, relies on an implemented clock()
 *	function
 *
 *	djm 15/10/2001
 *
 *	$Id: csleep.c,v 1.3 2016/07/02 14:44:33 dom Exp $
 */

#include <stdlib.h>
#include <time.h>
#ifdef __ZX80__
#include <zx81.h>
#endif


void  csleep(unsigned int centiseconds)
{
	long start = clock();  
	long per   = ((long) centiseconds * (long) CLOCKS_PER_SEC) / 100L;
#ifdef __ZX80__
	gen_tv_field_init(0);
#endif
        
        while ( (clock() - start) < per ) {
#ifdef __ZX80__
	    gen_tv_field();
            FRAMES++;
#else
	    ;
#endif
	}
}

