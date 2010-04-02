
/*
	Coloured mandelbrot demo - shows the zxlowgfx capabilities
	uses cclg, cplot, cpoint (for the color cycling), ccopybuffer.

	The "lr64x48" #define activates the alternate resolution.
	Comment out the "bufferedgfx" #define to see what happens behind the scenes.

	build with:   zcc +zx -lndos -lm -create-app cmandel.c
	              - or -
	              zcc +zx -lndos -lm -create-app -Dlr64x48 cmandel.c

	$Id: cmandel.c,v 1.3 2010-04-02 09:05:06 stefano Exp $
*/

//#define DALTLOWGFX  1

// This flag is not necessary if demo runs only in ULAPLUS mode
#define bufferedgfx 1

#include <stdio.h>
#include <zxlowgfx.h>
#include <spectrum.h>
#include <math.h>

void main()
{
float a,b,c,d,e,g,h,i,j;
int x,y;
int xmax,ymax;
int k;
float l,m,n,o,p;

	cclg(1);  // Blue background


#ifdef ALTLOWGFX
	xmax=64;
	ymax=24;
#else
	xmax=32;
	ymax=48;
#endif
	a=-2.0; b=2.0;
	c=a; d=b;
	
	
	//a=-0.765; b=-0.7651;
	//c=-0.095; d=-0.0951;

	e=4.0;

	g=(b-a)/(float)xmax;
	h=(d-c)/(float)ymax;



	for(y=ymax/2; y>=0; y--)
	{
	  j=(float)y*h+c;
	  for(x=xmax; x>=0; x--)
	  {
	     i=(float)x*g+a;
	     k=0;
	     l=0.0; m=0.0; n=0.0; o=0.0;
l110:	     k++;
	     if (k<50)  //Iterates
	     {
		p=n-o+i;
		m=2.0*l*m+j;
		l=p;
		n=l*l; o=m*m;

		if ((n+o)<e) goto l110;
		
		cplot (x,y,k & 7);
		cplot (x,ymax-y,k & 7);
	     }
	     	ccopybuffer();

	  }
	ccopybuffer();
	}


if (ula_plus_mode()) {
	// color cycling - ulaplus mode
	for(k=0; k<240; k++) {
		ula_sync();
		for (x=0; x<8; x++) {
			ulaplus_set(x,x+k);
			ulaplus_set(x+8,x+k);
		}
		for(y=0; y<1600; y++) {}
	}
} else {
	// color cycling - standard mode
	for(k=100; k>=0; k--) {
		for(y=ymax; y>=0; y--)
		{
		  for(x=xmax; x>=0; x--) cplot (x,y,cpoint(x,y)+1)
		}
		ccopybuffer();
	}
}


	ccopybuffer();
}
