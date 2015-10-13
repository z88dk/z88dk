
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

char palette[]={2,5,8,12,17,22,32,45,67,134,178,210,220,240,245,248};

void main()
{

	//	Initialize the 16 color video mode and its palette
	gr_defmod(3);
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

			//printf ("%f ",e);
			
			if ((n+o)<e) goto l110;

				if (k&0)
					plot(x*4,y);
				if (k&1)
					plot(x*4+1,y);
				if (k&2)
					plot(x*4+2,y);
				if (k&4)
					plot(x*4+3,y);

	     }
	  }
	}

	/* color cycling until RETURN is pressed */
	while (getk()!=13) {
		x=palette[0];
		for (k=0; k<15; k++)
			palette[k]=palette[k+1];
		palette[15]=x;
		gr_setpalette(16,palette);
	}

}

