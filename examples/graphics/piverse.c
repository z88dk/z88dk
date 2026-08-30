/* ========================================================================== */
/*                                                                            */
/*   piverse.c                                                                */
/*   From a program by Ardi Ardi                                              */
/*                                                                            */
/*   Yet another minimalistic 10 liner graphics example for z88dk             */
/*                                                                            */
/* ========================================================================== */

#include <graphics.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

int hh,hw;
int n,i,j;
float r,t,u,v,x,tt;

void main()
{
  hw = getmaxx()/2;
  hh = getmaxy()/2;
  n  = 120;
  tt = M_PI*2.0;
  r  = tt/235.0;
  x  = t=0.0;
  
  while (getk() != '\n') {
      clg();
      
      for (i=0; i<n;i++) {
        for (j=0; j<n;j++) {
            
            u = sin((float)i+v)+sin(r*(float)i+x);
            v = cos((float)i+v)+cos(r*(float)i+x);
            x = u+t;
            plot (hw+u*(float)hw*.4,hh+v*(float)hh*.4);
        }
      }
      t+=.04;
  }

}
