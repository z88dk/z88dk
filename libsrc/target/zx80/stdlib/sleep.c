/*
 *	Generic sleep() function, relies on an implemented clock()
 *	function
 *
 *	djm 15/10/2001
 *
 *	$Id: sleep.c,v 1.5 2016-07-02 14:44:33 dom Exp $
 */

#include <stdlib.h>
#include <time.h>

#include <zx81.h>

int sleep(int secs)
{
    clock_t start = clock();  
    clock_t per   = (clock_t) secs * CLOCKS_PER_SEC;
    gen_tv_field_init(0);

    while ((clock() - start) < per) {        
       gen_tv_field();
       FRAMES++;
    }
    return 0;
}
