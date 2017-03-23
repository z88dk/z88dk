/*
 *	Generic sleep() function, relies on an implemented clock()
 *	function
 *
 *	djm 15/10/2001
 *
 *	$Id: delay.c,v 1.3 2016-07-02 14:44:33 dom Exp $
 */

#include <stdlib.h>
#include <time.h>

#ifdef __ZX80__
#include <zx81.h>
#endif

#ifdef __C128__
#include <c128/cia.h>
#endif


void   delay (long msecs)
{

#ifdef __C128__
long x;

  setintctrlcia(cia2,ciaClearIcr); /* disable all cia 2 interrupts */
  settimerbcia(cia2,timervalcia(1000),ciaCountA);  /* timer b counts timer a underflows */
  settimeracia(cia2,timervalcia(1000),ciaCPUCont); /* set timer a 1/1000 sec */
  for (x=0; x<msecs; x++)
	while ((inp(cia2+ciaIntCtrl) & 0x02) == 0) {}      /* wait for count down */

#else

	long start = clock();  
	long per   = msecs * CLOCKS_PER_SEC / 1000;

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

