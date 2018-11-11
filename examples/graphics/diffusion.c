
#include <stdio.h>
#include <math.h>
#include <graphics.h>

float b,c,d;
float x,y, x1,y1;
float xmax,ymax;
unsigned int f;

void main()
{

 	clg();
	xmax=(float)getmaxx();
	ymax=(float)getmaxy()+((float)getmaxx()/4.0);
	
	b=3.8; c=0.9; d=3.18;
	x=0.4; y=0.2;

	for (f=1; f<15000; f++) {
		plot ((int)(x*xmax),(int)(y*ymax));
		x1=x; y1=y;
		x=b*x1*(1.0-c*x1-y1);
		y=d*x1*y1;
	}
}
