/* Hello world. See Makefile for building commands */

#include <stdio.h>
/* Description string for Ti calcs.  In apps this should be 8 or less characters or it can not be sent.*/
#pragma string name WORLD

/* Icon for Ti calcs ('waving' hand). This is not used in asm( or apps */
#pragma data icon 0x18,0x3C,0x3C,0xBC,0x7C,0x7C,0x3C,0x38;



main()
{

	puts("Hello World");




#ifdef __TI83p__

/* call a system routine */
#define bcall(__LABEL__) __asm__("rst $28 \nDEFW "__LABEL__"\n")

	bcall("0x4972"); /* Press Any Key to continue */

#endif
}
