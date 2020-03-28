/* z88dk Maths and graphics demo */
/* Bifurcation diagram of the logistic map */

/* (see http://en.wikipedia.org/wiki/Bifurcation_diagram#Logistic_map) */

#include <stdio.h>
#include <math.h>
#include <graphics.h>

float r,p;
int x,y,b;
int xmax,ymax,bcount;

#define precision 90
#define plot_trigger 60

void main()
{

 	clg();

	xmax=getmaxx();
	ymax=getmaxy();
	
	r=2.72;
	
	for (x=0; x<xmax; x++) {
	
		p=r/4.0;

		for (b=0; b<precision; b++) {
			p=r*p*(1.0-p);
			if (plot_trigger < b) {
				y=ymax-(int)(p*(float)ymax);
				plot (x,y);
			}
		}
		
		r=r+.005;
	}
}
