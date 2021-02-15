/*	$Id: sndtest.c $

	Messed up code samples to hack with
	The optional PSG extras are for tuning comparisons.
	
	Build example, running well on a Fuller box (or equivalent YM chip clock):
	zcc +zx -lndos -create-app -lm -DPSG sndtest.c
*/

#include <sound.h>

#ifdef PSG
#include <psg.h>
#endif

//#include <stdio.h>
//#include <float.h>


void main()
{

/*
double x;

for (x=0.0; x<6.0; x+=0.1)
	bit_noise(50,30*(sin(x)+2.0));
*/

/*
	261.625565290         C
	277.182631135         C#
	293.664768100         D
	311.126983881         D#
	329.627557039         E
	349.228231549         F
	369.994422674         F#
	391.995436072         G
	415.304697513         G#
	440.000000000         A
	466.163761616         A#
	493.883301378         B
*/


#ifdef PSG
	psg_init();
	psg_channels(chanAll, chanNone); // set all channels to tone generation
#endif

// Range extension for synth_play() on a 3.5 Mhz CPU:  A- .. B+++

		synth_phase(0x2200);
		synth_play("E++F++G++4E++4F++D++E++C++D++");
		synth_phase(0x1212);
		synth_play("E++F++G++4E++4F++D++E++C++D++");
		synth_phase(0);
		synth_play("G4CC4DECED");
		synth_phase(0x2200);
		synth_play("G4CC4DEC8B-");

#ifdef PSG
			psg_tone(0, psgT(65.4)); // produce a C tone on the first channel
			psg_tone(2, psgT(97.9)); // produce a G tone on the third channel
			psg_envelope(envUH, psgT(10), chanAll); // set a raising volume envelope on all channels
#endif

		synth_phase(0x1212);
		synth_play("E++F++G++4E++4F++D++E++C++D++");

		synth_phase(1);
		synth_play("E++F++G++4E++4F++D++E++C++D++");

		bit_play("G4---C--C--D--E--C--E--D--");
#ifdef PSG
			psg_envelope(envD, psgT(10), chanAll); // set a fading volume envelope on all channels
#endif
		synth_phase(0x3123);
		synth_play("G4CC4DEC8B-");

		synth_phase(0x1234);

#ifdef PSG
			// the following frequencies are based on the 440 Hz (central A tone) tunning
			psg_tone(0, psgT(130.8)); // produce a C tone on the first channel
			psg_tone(1, psgT(164.8)); // produce a E tone on the second channel
			psg_tone(2, psgT(195.9)); // produce a G tone on the third channel
			psg_envelope(envD, psgT(10), chanAll); // set a fading volume envelope on all channels
#endif
		bit_play("CDEFGFE4");
#ifdef PSG
			psg_envelope(envD, psgT(10), chanAll); // set a fading volume envelope on all channels
#endif
		synth_play("CDEFGFE4");

#ifdef PSG
			psg_envelope(envD, psgT(10), chanAll); // set a fading volume envelope on all channels
#endif
		buzzer_play(BUZZ_BASS,"CDEFGFE4");
#ifdef PSG
			psg_envelope(envD, psgT(10), chanAll); // set a fading volume envelope on all channels
#endif
		synth_play("CDEFGFE4");

#ifdef PSG
			psg_tone(1, psgT(174.6)); // produce a F tone on the second channel
			psg_tone(2, psgT(220.0)); // produce a A tone on the third channel
			psg_envelope(envD, psgT(10), chanAll); // set a fading volume envelope on all channels
#endif
		bit_play("FGABbC+BbA4");
#ifdef PSG
			psg_envelope(envD, psgT(10), chanAll); // set a fading volume envelope on all channels
#endif
		buzzer_play(BUZZ_BASS2,"FGABbCBbA4");

#ifdef PSG
			psg_tone(1, psgT(164.8)); // produce a E tone on the second channel
			psg_tone(2, psgT(195.9)); // produce a G tone on the third channel
			psg_envelope(envD, psgT(10), chanAll); // set a fading volume envelope on all channels
#endif
		buzzer_play(BUZZ_MID,"C--D--E--F--G--F--E--4");
#ifdef PSG
			psg_envelope(envD, psgT(10), chanAll); // set a fading volume envelope on all channels
#endif
		buzzer_play(BUZZ_JAMBASS,"C--D--E--F--G--F--E--4");

		bit_play("E++F++G++4E++4F++D++E++C++D++");
		synth_play("E++F++G++4E++4F++D++E++C++D++");

		synth_phase(0x1212);
		synth_play("C8");
		synth_phase(0x1234);
		synth_play("C8");
		buzzer_play(BUZZ_BASS2,"C8");
		buzzer_play(BUZZ_BASS,"C-8");		
		buzzer_play(BUZZ_BASS3,"C--8C--C--");

//bit_play("C--C-CC+C++C+++C++++");

//bit_play("Bb-B-CC#DD#EFF#GG#AA#BC+");

// Fra Martino
//bit_play("C4DECCDECEFG8E4FG8G2AGFE4CG2AGFE4CDG-CCDG-CC");

// ZX DEMO
/*
bit_play("C8DEb4DC8");
bit_play("C8DEb4DC8");
bit_play("Eb8FGG");
bit_play("Eb8FGG");
bit_play("G8Ab4G8FEb4DC");
bit_play("G8Ab4G8FEb4DC");
bit_play("C8G-C");
bit_play("C8G-C");
*/

/*
  char x[20];
  ftoa(261.625565290,9,x);
  printf ("%s ",x);
*/

/*
	bit_frequency (0.3,261.625565290);
	bit_frequency (0.3,293.664768100);
	bit_frequency (0.3,329.627557039);
	bit_frequency (0.3,349.228231549);
	bit_frequency (0.3,391.995436072);
	bit_frequency (0.3,440.000000000);
	bit_frequency (0.3,493.883301378);
	bit_frequency (0.3,261.625565290*2);

	bit_frequency (0.3,atof("261.625565290"));
	bit_frequency (0.3,atof("293.664768100"));
	bit_frequency (0.3,atof("329.627557039"));
	bit_frequency (0.3,atof("349.228231549"));
	bit_frequency (0.3,atof("391.995436072"));
	bit_frequency (0.3,atof("440.000000000"));
	bit_frequency (0.3,atof("493.883301378"));
	bit_frequency (0.3,atof("261.625565290")*2);

*/
}
