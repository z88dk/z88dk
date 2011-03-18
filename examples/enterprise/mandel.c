
/* 
 * Enterprise 128  Mandelbrot demo
 * 
 * Example on how to interface to EXOS with z88dk
 * this program initializes a video channel and 
 * communicates to it via the ESCape sequences.
 * 
 * To build:
 * zcc +enterprise -lm -create-app mandel.c
 */

#include <stdio.h>
#include <math.h>
#include <enterprise.h>

float a,b,c,d,e,g,h,i,j;
int x,y;
int xmax,ymax;
int k;
float l,m,n,o,p;

struct EXOS_ESCCMD esc_cmd;

void main()
{

	// Init the first charact for the ESC sequences
	esc_cmd.escape=27;

	//	Initialize a custom video mode
	exos_set_vmode(VM_HRG,CM_16,40,24);

	// CLRHOME
	exos_write_character(DEFAULT_VIDEO, 0x1A);

	// set beam on
	esc_cmd.esccmd='S';
	exos_write_block(DEFAULT_VIDEO, 2, esc_cmd);


	xmax=210;
	ymax=210;
	
	a=-2.0; b=2.0;
	c=a; d=b;
	e=4.0;

	g=(b-a)/(float)xmax;
	h=(d-c)/(float)ymax;
	
	for(y=ymax; y>0; y--)
	{
	  j=(float)y*h+c;
	  for(x=xmax; x>0; x--)
	  {
	     i=(float)x*g+a;
	     k=0;
	     l=0.0; m=0.0; n=0.0; o=0.0;
l110:	     k++;
	     if (k<100)  //Iterates
	     {
			p=n-o+i;
			m=2.0*l*m+j;
			l=p;
			n=l*l; o=m*m;

			//printf ("%f ",e);
			
			if ((n+o)<e) goto l110;

			esc_cmd.esccmd='I';	// INK colour
			esc_cmd.x=k;
			exos_write_block(DEFAULT_VIDEO, 3, esc_cmd);

			esc_cmd.esccmd='s'; // set beam off
			exos_write_block(DEFAULT_VIDEO, 2, esc_cmd);

			esc_cmd.esccmd='A'; // set beam position
			esc_cmd.x=x*4;
			esc_cmd.y=y*4;
			exos_write_block(DEFAULT_VIDEO, 6, esc_cmd);

			esc_cmd.esccmd='S'; // set beam on
			exos_write_block(DEFAULT_VIDEO, 2, esc_cmd);

	     }
	  }
	}
}

