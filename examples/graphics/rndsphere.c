/* ========================================================================== */
/*                                                                            */
/*   rndsphere.c                                                              */
/*   Algorithm by Erwin Ouwejan                                               */
/*                                                                            */
/*   Yet another minimalistic 10 liner graphics example for z88dk             */
/*                                                                            */
/* ========================================================================== */

#include <graphics.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

int x,y;
long x1,n;   // with very small resolutions the int type will suffice
int xc,yc;

void main()
{
  xc=getmaxy()/2;
  yc=getmaxy()/2;
  
  clg();
  
  for (y=-yc; y<=yc;y++) {
    x1=sqrt(xc*xc-y*y);
    for (x=-x1; x<=x1; x++) {
      n=(rand()*(x1*2)+1.0)/RAND_MAX;
      if (n<x1+x)
        plot (x+xc,y+yc);
    }    
  }  
	
  while (getk() != '\n') {};
}
