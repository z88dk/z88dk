/*	$Id: sndtest.c,v 1.1 2001-10-16 18:22:27 dom Exp $	
	Messed up code samples to hack with
*/

#include <sound.h>

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

// Range extension for synth_play() on a 3.5 Mhz CPU:  A- .. B+++

		synth_phase(0x2200);
		synth_play("E++F++G++4E++4F++D++E++C++D++");
		synth_phase(0x1212);
		synth_play("E++F++G++4E++4F++D++E++C++D++");
		synth_phase(0);
		synth_play("G4CC4DECED");
		synth_phase(0x2200);
		synth_play("G4CC4DEC8B-");

		synth_phase(0x1212);
		synth_play("E++F++G++4E++4F++D++E++C++D++");

		synth_phase(1);
		synth_play("E++F++G++4E++4F++D++E++C++D++");

		bit_play("G4---C--C--D--E--C--E--D--");
		synth_phase(0x3123);
		synth_play("G4CC4DEC8B-");

		synth_phase(0x1234);

		bit_play("CDEFGFE4");
		synth_play("CDEFGFE4");

		bit_play("CDEFGFE4");
		synth_play("CDEFGFE4");

		bit_play("FGABbC+BbA4");
		synth_play("FGABbC+BbA4");

		bit_play("C--D--E--F--G--F--E--4");
		synth_play("CDEFGFE4");

		bit_play("E++F++G++4E++4F++D++E++C++D++");
		synth_play("E++F++G++4E++4F++D++E++C++D++");

		synth_phase(0x1212);
		synth_play("C8");
		synth_phase(0x1234);
		synth_play("C8");
		synth_phase(0x1212);
		synth_play("C8");
		synth_phase(0x1234);
		synth_play("C8");
		bit_play("C--8C--C--");

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
