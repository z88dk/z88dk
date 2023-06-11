/*

	to build using sccz80/genmath:  zcc +<target> <stdio options> -lm -create-app savage.c
	or
	to build using sccz80/math48:  zcc +<target> <stdio options> -lmath48 -create-app -o savage savage.c
	or
	to build using sccz80/math32:  zcc +<target> <stdio options> --math32 -create-app -o savage savage.c
	or
	to build using sdcc/math48:  zcc +<target> -compiler=sdcc <stdio options> -lmath48 -create-app -o savage savage.c
	or
	to build using sdcc/math32:  zcc +<target> -compiler=sdcc <stdio options> --math32 -create-app -o savage savage.c
	
	Examples:
	  zcc +cpm -lm -lndos -create-app -o savage savage.c
	  zcc +zx -lm -lndos -create-app -o savage savage.c
	
	to build for the embedded target see the Makefile
	
	stefano
	
	
	Benchmark math performance using CP/M target and z88dk-ticks
	
	SCCZ80
	genmath -> 400944733 cycles (7 digits accuracy)  % zcc +cpm -lndos -lm -create-app savage.c -osavage // -DNOPRINT
	math48  -> 277174281 cycles (7 digits accuracy)  % zcc +cpm -lndos -lmath48 -create-app savage.c -osavage // -DNOPRINT
	math32  -> 127461377 cycles (5 digits accuracy)  % zcc +cpm -lndos --math32 -create-app savage.c -osavage // -DNOPRINT
	am9511  ->  33010850 cycles (5 digits accuracy)  % zcc +cpm -lndos --am9511 -create-app savage.c -osavage // -DNOPRINT
	
	SDCC
	math48  -> 278043533 cycles (5 digits accuracy)  % zcc +cpm -compiler=sdcc -lndos -lmath48 -create-app savage.c -osavage // -DNOPRINT
	math32  -> 127380163 cycles (5 digits accuracy)  % zcc +cpm -compiler=sdcc -lndos --math32 -create-app savage.c -osavage // -DNOPRINT
	am9511  ->  32929636 cycles (5 digits accuracy)  % zcc +cpm -compiler=sdcc -lndos --am9511 -create-app savage.c -osavage // -DNOPRINT
	
	Note the loss of accuracy moving from the (genmath or math48) 40 bit mantissa to (math32 or am9511) IEEE 23 bit mantissa,
	when EITHER sdcc OR math32 is used.
	
	feilipu

*/

/* Program Savage;
   see Byte, Oct '87, p. 277 */

#pragma printf = "%s %f"  /* enables %s, %f only */

#include <stdio.h>
#include <math.h>

#if defined(__EMBEDDED)
#include "ns16450.h"
#endif

#define ILOOP 500

int main(void)
{
	int i;
	float a, aprime;

#if defined(__EMBEDDED)
	init_uart(0,1);
#endif

	a = 1.0;

	for(i = 0; i < ILOOP; ++i)
	{
		aprime = tan(atan(exp(log(sqrt(a * a)))));
#ifndef NOPRINT
		printf("A = %f -> %f\n", a, aprime);
#endif
		a += 1.0;
	}

	return 0;
}
