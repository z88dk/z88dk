
/* 
 * TIKI-100  Mandelbrot demo
 * 
 * Example on how to use the 16 color mode on the TIKI 100 with z88dk
 * 
 * To build:
 *   zcc +cpm -startup=2 -lm -ltiki100 -omandel.com mandel.c
 */

#include <stdio.h>
#include <math.h>
#include <tiki100.h>
#include <graphics.h>


float a,b,c,d,e,g,h,i,j;
int x,y;
int xmax,ymax;
int k;
float l,m,n,o,p;

char palette[]={0,0x25,0x4a,0x6f,0x24,0x48,0x6c,0x90,0xb4,0xd8,0xfc,3,0x1c,0xE0};

void main()
{
	//  The standard clg() will set to 1024 pixel mode and BW palette, but we can change it
	clg();
	//	Set the 16 color 256 pixel video mode
	gr_defmod(3);
	// The default palette is 4 colors only, but we can wait the cycling effect to show a full palette
	gr_setpalette(16,palette);

	xmax=255;
	ymax=255;

	
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
			
			if ((n+o)<e) goto l110;

				/* Trick to plot in color with the BW function */
				if (k&1)
					plot(x*4,y);
				if (k&2)
					plot(x*4+1,y);
				if (k&4)
					plot(x*4+2,y);
				if (k&8)
					plot(x*4+3,y);

	     }
	  }
	}
	  
	/* Color cycling until RETURN is pressed */
	k=0;
	while (getk()!=13) {
		x=palette[0];
		for (x=0; x<16; x++)
			palette[x]=x+k;
		for (y=0; y<20; y++)
			gr_setpalette(16,palette);
		k++;
	}

}

