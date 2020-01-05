/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: circlepointsvdc.c,v 1.1 2008-06-23 17:34:32 stefano Exp $

*/

#include <stdlib.h>
#include <c128/vdc.h>

/* plot circle points in eights */

void circlepointsvdc(int XC, int YC, int X, int Y)
{
  setpixivdc(XC+X,YC+Y);
  setpixivdc(XC-X,YC+Y);
  setpixivdc(XC+X,YC-Y);
  setpixivdc(XC-X,YC-Y);
  setpixivdc(XC+Y,YC+X);
  setpixivdc(XC-Y,YC+X);
  setpixivdc(XC+Y,YC-X);
  setpixivdc(XC-Y,YC-X);
}
