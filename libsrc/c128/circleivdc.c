/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: circleivdc.c,v 1.1 2008-06-23 17:34:32 stefano Exp $

*/

#include <stdlib.h>
#include <c128/vdc.h>

/* draw circle in 640 x 680 interlace bit map using bresenham's algorithm */

void circleivdc(int XC, int YC, int R)
{
  int P, X, Y;

  X = 0;          /* select first point as (x,y) = (0,r) */
  Y = R;
  P = 3-(R << 1);
  while(X < Y)
  {
    circlepointsvdc(XC,YC,X,Y);
    if(P < 0)
      P += (X << 2)+6;      /* next point (x+1,y) */
    else
    {
      P += ((X-Y) << 2)+10; /* next point (x+1,y-1) */
      Y--;
    }
    X++;
  }
  if(X == Y)
    circlepointsvdc(XC,YC,X,Y);
}
