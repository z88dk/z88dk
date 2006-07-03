/*

	ZX Spectrum and the Currah uSpeech lib demo
	
	$Id: zxcurrah.c,v 1.1 2006-07-03 15:04:15 stefano Exp $

*/
#include <spectrum.h>
#include <zxcurrah.h>
#include <stdio.h>
#include <stdlib.h>

/* 'Hello" word for direct mode */
char hello[] = {PH_H, PH_E | PH_PITCH, PH_LL, PH_O, PH___, PH_END};

int main()
{
	if ( !currah_detect() )  
	{
		printf ("CURRAH uSpeech is present\n");
	}
	else
	{
	printf ("Hello (from the direct engine)\n");
	currah_direct (hello);
	sleep (1);
	printf ("\nHello (internal conversion functions)\n");
	currah_speech ("hE(ll)o");
	sleep (1);

	printf ("\n\nI am a ZX Spectrum talking\n");
	currah_speech ("aY em a zed eks spEctrum tokin");

	}

	printf ("\n\n\n(Program end).\n");

}

