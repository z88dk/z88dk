
#include <stdio.h>
#include <math.h>
#include <gray.h>

#pragma string name GrayMandelbrot

float a,b,c,d,e,g,h,i,j;
int x,y;
int xmax,ymax;
int k;
float l,m,n,o,p;

void main()
{

 	g_clg(G_WHITE);

	xmax=70;
	ymax=63;
	
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

		g_plot (15+x,y,k&3);

	     }
	  }
	}
}

