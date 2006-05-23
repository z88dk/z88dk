/* $Id: synthdemo.c,v 1.1 2006-05-23 20:42:51 stefano Exp $
The Synth library generates many waveforms basing on sound duration and 4 harmonics.
It is possible to simulate several instruments or even two voices 

Synth demo #1: By varying the dinstance between harmonics it is possible to emulate polyphonic ensembles.
In this case we almost neutralize the vibrations to get very low and clean sounds.
Higher frequencies are emphasized.

Synth demo #2 (second section): Now we play the same melody using the same trick,
but the phases have been chosen to get as much harmonics as possible.
The effect is very similar to what we can get with distortion.

Note: in both the samples the note duration isn't accurate.. I still haven't found a
formula for that, and obviously lower frequencies last longer.
I set the values experimentally.

Stefano Bodrato - 23/5/2006
*/

#include <sound.h>
#include <stdio.h>

int main()
{
	printf("\n\nLow tones \n");
	printf("1st theme \n");

        bit_synth (100,200,200,40,40);
        bit_synth (100,200,200,33,33);

        bit_synth (100,177,177,37,37);
        bit_synth (100,150,150,44,44);

        bit_synth (100,160,160,50,50);
        bit_synth (100,200,200,40,40);

        bit_synth (100,133,133,44,44);
        bit_synth (100,150,150,44,44);

        bit_synth (100,160,160,50,50);
        bit_synth (100,200,200,40,40);

        bit_synth (100,150,150,44,44);
        bit_synth (100,177,177,37,37);

        bit_synth (100,133,133,40,40);
        bit_synth (100,133,133,44,44);

        bit_synth (150,200,200,50,50);



	printf("2nd theme \n");

        bit_synth (100,133,133,53,53);
        bit_synth (100,133,133,50,50);

        bit_synth (100,150,150,44,44);
        bit_synth (100,150,150,53,53);

        bit_synth (100,160,160,50,50);
        bit_synth (100,177,177,44,44);

        bit_synth (100,200,200,40,40);
        bit_synth (100,160,160,40,40);

        bit_synth (100,150,150,60,60);
        bit_synth (100,150,150,44,44);

        bit_synth (100,133,133,53,53);
        bit_synth (100,160,160,50,50);

        bit_synth (100,150,150,44,44);
        bit_synth (100,133,133,53,53);

        bit_synth (150,200,200,50,50);


	printf("Variation on 1st theme \n");

        bit_synth (50,200,200,40,40);
        bit_synth (50,200,200,37,37);
        bit_synth (50,200,200,33,33);
        bit_synth (50,200,200,40,40);

        bit_synth (50,177,177,33,33);
        bit_synth (50,177,177,37,37);
        bit_synth (50,150,150,40,40);
        bit_synth (50,150,150,44,44);

        bit_synth (50,160,160,50,50);
        bit_synth (50,160,160,44,44);
        bit_synth (50,200,200,40,40);
        bit_synth (50,200,200,50,50);

        bit_synth (50,133,133,44,44);
        bit_synth (50,133,133,50,50);
        bit_synth (50,150,150,44,44);
        bit_synth (50,150,150,40,40);

        bit_synth (50,160,160,50,50);
        bit_synth (50,160,160,33,33);
        bit_synth (50,200,200,37,37);
        bit_synth (50,200,200,40,40);

        bit_synth (50,150,150,44,44);
        bit_synth (50,150,150,40,40);
        bit_synth (50,177,177,37,37);
        bit_synth (50,177,177,44,44);

        bit_synth (50,133,133,40,40);
        bit_synth (50,133,133,37,37);
        bit_synth (50,133,133,44,44);
        bit_synth (50,133,133,40,40);

        bit_synth (50,200,200,50,50);
        bit_synth (50,200,200,40,40);
        bit_synth (50,200,200,50,50);

	printf("Variation on 2nd theme \n");

        bit_synth (50,133,133,53,53);
        bit_synth (50,133,133,60,60);
        bit_synth (50,133,133,53,53);
        bit_synth (50,133,133,50,50);

        bit_synth (50,150,150,44,44);
        bit_synth (50,150,150,50,50);
        bit_synth (50,150,150,44,44);
        bit_synth (50,150,150,53,53);

        bit_synth (50,160,160,50,50);
        bit_synth (50,160,160,53,53);
        bit_synth (50,177,177,50,50);
        bit_synth (50,177,177,44,44);

        bit_synth (50,200,200,40,40);
        bit_synth (50,200,200,44,44);
        bit_synth (50,160,160,50,50);
        bit_synth (50,160,160,53,53);

        bit_synth (50,150,150,60,60);
        bit_synth (50,150,150,53,53);
        bit_synth (50,150,150,50,50);
        bit_synth (50,150,150,44,44);

        bit_synth (50,133,133,50,50);
        bit_synth (50,133,133,53,53);
        bit_synth (50,160,160,44,44);
        bit_synth (50,160,160,50,50);

        bit_synth (50,150,150,40,40);
        bit_synth (50,150,150,44,44);
        bit_synth (50,133,133,50,50);
        bit_synth (50,133,133,53,53);

        bit_synth (150,200,200,50,50);


	printf("\n\nDistortion \n");
	printf("1st theme \n");

        bit_synth (100,200,201,40,41);
        bit_synth (100,200,201,33,34);

        bit_synth (100,177,178,37,38);
        bit_synth (100,150,151,44,45);

        bit_synth (100,160,161,50,51);
        bit_synth (100,200,201,40,41);

        bit_synth (100,133,134,44,45);
        bit_synth (100,150,151,44,45);

        bit_synth (100,160,161,50,51);
        bit_synth (100,200,201,40,41);

        bit_synth (100,150,151,44,45);
        bit_synth (100,177,178,37,38);

        bit_synth (100,133,134,40,41);
        bit_synth (100,133,134,44,45);

        bit_synth (150,200,201,50,51);



	printf("2nd theme \n");

        bit_synth (100,133,134,53,54);
        bit_synth (100,133,134,50,51);

        bit_synth (100,150,151,44,45);
        bit_synth (100,150,151,53,54);

        bit_synth (100,160,161,50,51);
        bit_synth (100,177,178,44,45);

        bit_synth (100,200,201,40,41);
        bit_synth (100,160,161,40,41);

        bit_synth (100,150,151,60,61);
        bit_synth (100,150,151,44,45);

        bit_synth (100,133,134,53,54);
        bit_synth (100,160,161,50,51);

        bit_synth (100,150,151,44,45);
        bit_synth (100,133,134,53,54);

        bit_synth (150,200,201,50,51);


	printf("Variation on 1st theme \n");

        bit_synth (50,200,201,40,41);
        bit_synth (50,200,201,37,38);
        bit_synth (50,200,201,33,34);
        bit_synth (50,200,201,40,41);

        bit_synth (50,177,178,33,34);
        bit_synth (50,177,178,37,38);
        bit_synth (50,150,151,40,41);
        bit_synth (50,150,151,44,45);

        bit_synth (50,160,161,50,51);
        bit_synth (50,160,161,44,45);
        bit_synth (50,200,201,40,41);
        bit_synth (50,200,201,50,51);

        bit_synth (50,133,134,44,45);
        bit_synth (50,133,134,50,51);
        bit_synth (50,150,151,44,45);
        bit_synth (50,150,151,40,41);

        bit_synth (50,160,161,50,51);
        bit_synth (50,160,161,33,34);
        bit_synth (50,200,201,37,38);
        bit_synth (50,200,201,40,41);

        bit_synth (50,150,151,44,45);
        bit_synth (50,150,151,40,41);
        bit_synth (50,177,178,37,38);
        bit_synth (50,177,178,44,45);

        bit_synth (50,133,134,40,41);
        bit_synth (50,133,134,37,38);
        bit_synth (50,133,134,44,45);
        bit_synth (50,133,134,40,41);

        bit_synth (50,200,201,50,51);
        bit_synth (50,200,201,40,41);
        bit_synth (50,200,201,50,51);

	printf("Variation on 2nd theme \n");

        bit_synth (50,133,134,53,54);
        bit_synth (50,133,134,60,61);
        bit_synth (50,133,134,53,54);
        bit_synth (50,133,134,50,51);

        bit_synth (50,150,151,44,45);
        bit_synth (50,150,151,50,51);
        bit_synth (50,150,151,44,45);
        bit_synth (50,150,151,53,54);

        bit_synth (50,160,161,50,51);
        bit_synth (50,160,161,53,54);
        bit_synth (50,177,178,50,51);
        bit_synth (50,177,178,44,45);

        bit_synth (50,200,201,40,41);
        bit_synth (50,200,201,44,45);
        bit_synth (50,160,161,50,51);
        bit_synth (50,160,161,53,54);

        bit_synth (50,150,151,60,61);
        bit_synth (50,150,151,53,54);
        bit_synth (50,150,151,50,51);
        bit_synth (50,150,151,44,45);

        bit_synth (50,133,134,50,51);
        bit_synth (50,133,134,53,54);
        bit_synth (50,160,161,44,45);
        bit_synth (50,160,161,50,51);

        bit_synth (50,150,151,40,41);
        bit_synth (50,150,151,44,45);
        bit_synth (50,133,134,50,51);
        bit_synth (50,133,134,53,54);

        bit_synth (150,200,201,50,51);

}
