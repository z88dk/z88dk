/*
 * How to build for S-OS:
 * zcc +sos -lndos -create-app -lm mandel.c
 * 
 * $Id: mandel.c,v 1.1 2013-12-05 09:36:03 stefano Exp $
 */


#include <stdio.h>
#include <math.h>
#include <sos.h>

float a,b,c,d,e,g,h,i,j;
int x,y;
int xmax,ymax;
int k;
int color;
float l,m,n,o,p;

void main()
{

 	fputc_cons(12);

	xmax=SOS_WIDTH-1;
	ymax=SOS_MXLIN-1;
	
	a=-2.0; b=2.0;
	c=a; d=b;
	e=4.0;

	g=(b-a)/(float)xmax;
	h=(d-c)/(float)ymax;
	
	for(y=0; y<ymax; y++)
	{
	  j=(float)y*h+c;
	  for(x=xmax; x>=0; x--)
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
		color=k&3;
		setcursorpos(y,x);
		switch (color) {
			case 1:
				fputc_cons('+');
				break;
			case 2:
				fputc_cons('*');
				break;
			case 3:
				fputc_cons('#');
				break;
		}

	     }
	  }
	}
	while (getk() != 13) {};
}

