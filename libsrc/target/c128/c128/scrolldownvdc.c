/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: scrolldownvdc.c,v 1.3 2016-06-16 21:13:07 dom Exp $

*/

#include <string.h>
#include <c128/vdc.h>

extern uchar  vdcScrHorz;
//extern ushort vdcDispMem;
extern ushort vdcAttrMem;

/* scroll window down given x1, y1, x2, y2 rectangle in current page */

void scrolldownvdc(ushort X1, ushort Y1, ushort X2, ushort Y2)
{
  uchar XLen;
  ushort DispOfs, AttrOfs;

  DispOfs = Y2*vdcScrHorz+vdcDispMem+X1;
  AttrOfs = Y2*vdcScrHorz+vdcAttrMem+X1;
  XLen = X2-X1+1;
  for(Y2++; Y2 > Y1; Y2--)
  {
    copymemvdc(DispOfs,DispOfs+vdcScrHorz,XLen);
    copymemvdc(AttrOfs,AttrOfs+vdcScrHorz,XLen);
    DispOfs -= vdcScrHorz;
    AttrOfs -= vdcScrHorz;
  }
}

