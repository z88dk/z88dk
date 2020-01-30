/* ========================================================================== */
/*                                                                            */
/*   chaos.c                                                                  */
/*   Sierpinski Triangle fractal                                              */
/*                                                                            */
/*   Yet another minimalistic graphics example for z88dk                      */
/*                                                                            */
/* ========================================================================== */

#include <graphics.h>
#include <stdlib.h>

unsigned int x,y,a,b;
unsigned char k;

void main()
{
  x=getmaxx()/2;
  y=getmaxy();
  
  clg();
  
  while (1) {
    k=rand()%3;
	a=b=0;
	if (k) {
		a=getmaxx();
		if (--k) {
			a=getmaxx()/2;
			b=getmaxy();
		}
	}
	
	x=(x+a)/2;
	y=(y+b)/2;
	
	plot (x,y);
  }
}

