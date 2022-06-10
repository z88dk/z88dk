/*

	Z88DK base graphics libraries examples
	Thue Morse sequence used to draw a fractal path
	
	Demonstrates the use of bitwise operators in C and the 'turtle graphics' instructions
	
	
	to build:   zcc +<target> -lndos -create-app -llib3d thuemorse.c


	
	$Id: thuemorse.c $

*/

#include <graphics.h>
#include <stdio.h>
#include <lib3d.h>


char th[128];

int c,d,i;
int b;
int mask;

void byte_unroll(int num) {
    // 8 bit integer
    for (int i = 7; i >= 0; i--) {
        mask = (1 << i);
        if (num & mask) {
			// '1'
			//turn_right(60);
			fwd(-4);
			turn_right(60);
		}
        else { 
			// '0'
			//fwd(5);
			turn_right(180);
           //printf("0");
		}
    }
}

void main()
{
  clg();
  unplot(0,0);
  pen_up();
  move (5,5);
  pen_down();

  i=1;
  th[0]=105;  // First 8 bits of the Thue-Morse sequence

  // 7 iterations.  2^7 = we prepare a 128 values sequence
  for (d=0; d<7; d++) {
    for (c=0; c<i; c++)
	    th[c+i] = ~th[c];   // one's complement
	i*=2;
  }
  
  // Now use the sequence to plot a path
  // 100 values are Suitable for 256x192 resolutions
  for (c=0; c<100; c++) {
	byte_unroll(th[c]);
  }

}

