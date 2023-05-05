/*

	Interfacing to the ZX Spectrum BASIC
	demonstration on:
	 - diagnostics
	 - parameter passing
	 - code execution
	 
	Try adding BASIC commands in line 100 and 150, like
	100 LET a$="Test": STOP
	
	Then, after run, try to PRINT b$
	
	$Id: zxbasic.c $

*/

#ifdef SPECTRUM
#include <spectrum.h>
#else
#include <zx81.h>
#endif

#include <arch/zx/currah.h>
#include <arch/zx/zxinterface1.h>
#include <arch/zx/betadisk.h>
#include <stdio.h>
#include <math.h>

char	value[100];


void main()
{

#ifdef SPECTRUM

	if ( zx_betadisk() )
	{
		printf ("Beta Disk interface is active\n");
		if ( trdos_installed() )
		{
			printf ("TR DOS installed\n");
		}
		else
		{
			printf ("TR DOS not installed\n");
		}
	}

	if ( if1_installed() )  printf ("Interface 1 is active\n");
	else
	   if ( zx_interface1() )  printf ("Interface 1 is present (now activated)\n");

	if ( if1_from_mdv() )  printf ("Program loaded from microdrive\n");

	if ( currah_detect() )  printf ("CURRAH uSpeech is present\n");

	if ( zx_issue3() )
	{
		printf ("This is a Spectrum issue 3 or more\n");
	}
	else
	{
		printf ("This Spectrum is issue 1 or 2 !\n");
	}

/*
	if ( zx_128() )
	{
		printf ("This is a Spectrum 128K\n");
	}
	else
	{
		printf ("This is a Spectrum 16 or 48K\n");
	}
*/

	if ( zx_128mode() )
	{
		printf ("This Spectrum is working in 128K mode\n");
	}
	else
	{
		printf ("This Spectrum is working in non-128K mode\n");
	}
#endif

	printf ("Basic length: %u\n",zx_basic_length() );
	printf ("Variables area length: %u\n",zx_var_length() );
	//printf ("Basic exec line 100 result: %u\n",zx_goto(100) );
	//printf ("Basic exec line 150 result: %u\n",zx_goto(150) );


	zx_getstr ('a',value);
	printf ("Got string value in 'a' :  %s\n",value);

	zx_setint ("n",100);
	zx_setint ("num",1234);

	printf ("Got numeric value in 'num' :  %u\n", zx_getint ("num") );
	printf ("Got numeric value in 'n' :  %u\n", zx_getint ("n") );
	
	zx_setstr ('b',"This is the b$ string, which nobody can deny...");

	zx_setfloat ("flt",-1400.101);
	zx_setfloat ("f",1400);

	printf ("Got float number in 'flt' :  %f\n", zx_getfloat("flt") );
	printf ("Got float number in 'f' :  %f\n", zx_getfloat("f") );

	printf ("\n\nProgram end\n");

}

