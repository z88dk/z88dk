/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: lineivdc.c,v 1.1 2008-06-23 17:34:34 stefano Exp $

*/

#include <stdlib.h>
#include <c128/vdc.h>

/* draw line in 640 X 480 bit map using modified bresenham's algorithm */

void lineivdc(int X1, int Y1, int X2, int Y2)
{
  int XInc, YInc, DX, DY, X, Y, C, R;

  DX = X2-X1;  /* delta x */
  if(DX < 0)   /* adjust for negative delta */
  {
    XInc = -1;
    DX = -DX;
  }
  else
    XInc = 1;
  DY = Y2-Y1;  /* delta y */
  if(DY < 0)   /* adjust for negative delta */
  {
    YInc = -1;
    DY = -DY;
  }
  else
    if(DY > 0)
      YInc = 1;
    else
      YInc = 0;

  X = X1;
  Y = Y1;
  setpixivdc(X,Y); /* set first point */
  if (DX > DY)    /* always draw with positive increment */
  {
    R = DX >> 1;
    for(C = 1; C <= DX; C++)
    {
      X += XInc;
      R += DY;
      if(R >= DX)
      {
        Y += YInc;
        R -= DX;
      }
      setpixivdc(X,Y);
    }
  }
  else
  {
    R = DY >> 1;
    for(C = 1; C <= DY; C++)
    {
      Y += YInc;
      R += DX;
      if(R >= DY)
      {
        X += XInc;
        R -= DY;
      }
      setpixivdc(X,Y);
    }
  }
}
