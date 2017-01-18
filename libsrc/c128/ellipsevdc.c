/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: ellipsevdc.c,v 1.1 2008-06-23 17:34:33 stefano Exp $

*/

#include <c128/vdc.h>

/*
Draw ellipse using digital differential analyzer (DDA) method.
*/

void ellipsevdc(int XC, int YC, int A, int B)
{
  long AA = (long) A*A; /* a^2 */
  long BB = (long) B*B; /* b^2 */
  long AA2 = AA << 1;   /* 2(a^2) */
  long BB2 = BB << 1;   /* 2(b^2) */

  {
    long X = 0;
    long Y = B;
    long XBB2 = 0;
    long YAA2 = Y*AA2;
    long ErrVal = -Y*AA; /* b^2 x^2 + a^2 y^2 - a^2 b^2 -b^2x */

    while (XBB2 <= YAA2) /* draw octant from top to top right */
    {
      setpixvdc(XC+X,YC+Y);
      setpixvdc(XC+X,YC-Y);
      setpixvdc(XC-X,YC+Y);
      setpixvdc(XC-X,YC-Y);
      X += 1;
      XBB2 += BB2;
      ErrVal += XBB2-BB;
      if (ErrVal >= 0)
      {
        Y -= 1;
        YAA2 -= AA2;
        ErrVal -= YAA2;
      }
    }
  }
  {
    long X = A;
    long Y = 0;
    long XBB2 = X*BB2;
    long YAA2 = 0;
    long ErrVal = -X*BB;

    while (XBB2 > YAA2)  /* draw octant from right to top right */
    {
      setpixvdc(XC+X,YC+Y);
      setpixvdc(XC+X,YC-Y);
      setpixvdc(XC-X,YC+Y);
      setpixvdc(XC-X,YC-Y);
      Y += 1;
      YAA2 += AA2;
      ErrVal += YAA2-AA;
      if (ErrVal >= 0)
      {
        X -= 1;
        XBB2 -= BB2;
        ErrVal -= XBB2;
      }
    }
  }
}

