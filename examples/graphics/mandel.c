
#include <stdio.h>
#include <math.h>
#include <graphics.h>

float a,b,c,d,e,g,h,i,j;
int x,y;
int xmax,ymax;
int k;
float l,m,n,o,p;

void main()
{

 	clg();

	xmax=getmaxx();
	ymax=getmaxy()-1;
	
	a=-2.0; b=2.0;
	c=a; d=b;
	e=4.0;

	g=(b-a)/(float)xmax;
	h=(d-c)/(float)ymax;
	
	for(y=ymax/2; y>0; y--)
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
		if (k&1){
		  plot (x,y);
		  plot (x,ymax-y);
		}

	     }
	  }
	}
	while (getk() != 13) {};
}

