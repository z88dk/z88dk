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

#ifdef __ZX80__
#include <zx81.h>
#endif

#ifdef __C128__
#include <c128/cia.h>
#endif

void sleep(int secs)
{
#ifdef __C128__

  unsigned char appTOD[4]; // = {0,0,0,0}; /* used to set tod clock to 12 am */
  int c,x;
  
  settodcia(cia2,appTOD);
  c=inp(cia2+ciaTODSec);
  
  for (x=0;x<secs;x++) {
	while (c==inp(cia2+ciaTODSec)) {}
	c=inp(cia2+ciaTODSec);
  }

#else
  
	long start = clock();  
	long per   = secs * CLOCKS_PER_SEC;
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

#endif
}

