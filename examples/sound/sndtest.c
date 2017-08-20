/*	$Id: sndtest.c,v 1.1 2001-10-16 18:22:27 dom Exp $	
	Messed up code samples to hack with
*/

#include <sound.h>

//#include <stdio.h>
//#include <float.h>


main()
{

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

//bit_play("C--C-CC+C++C+++C++++");

//bit_play("Bb-B-CC#DD#EFF#GG#AA#BC+");

// Fra Martino
bit_play("C4DECCDECEFG8E4FG8G2AGFE4CG2AGFE4CDG-CCDG-CC");

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
