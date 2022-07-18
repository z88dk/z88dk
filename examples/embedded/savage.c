/*

	to build:  zcc +<target> <stdio options> -lm -create-app savage.c
	or
	to build using math48:  zcc +<target> <stdio options> -lm48 -create-app -o savage savage.c
	or
	to build using math32:  zcc +<target> <stdio options> --math32 -create-app -o savage savage.c
	
	Examples:
	  zcc +cpm -lm -lndos -create-app -o savage savage.c
	  zcc +zx -lm -lndos -create-app -o savage savage.c
	
	Benchmark math performance using CP/M target and z88dk-ticks
	
	genmath -lm       -> 538580541 cycles (7 digits accuracy)
	math48  -lm48     -> 394420240 cycles (7 digits accuracy)
	math32  --math32  -> 215189520 cycles (4 digits accuracy)
	
	to build for the embedded target see the Makefile
	
	$Id: savage.c,v 1.4 2011-04-01 06:50:45 stefano Exp $

*/

/* Program Savage;
   see Byte, Oct '87, p. 277 */

#include <stdio.h>
#include <math.h>
#include "ns16450.h"

#define ILOOP 500

int main(void)
{
	int i;
	float a;

#if !(defined(__CPM) | defined(__SPECTRUM))
	init_uart(0,1);
#endif

	a = 1.0;

	for(i = 0; i < ILOOP; ++i)
	{
		a = tan(atan(exp(log(sqrt(a * a)))));
		printf("A = %f\n", a);
		a += 1.0;
	}
}
