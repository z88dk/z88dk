/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: scrollupvdc.c,v 1.2 2008-07-08 13:10:25 stefano Exp $

*/

#include <string.h>
#include <c128/vdc.h>

extern uchar  vdcScrHorz;
//extern ushort vdcDispMem;
extern ushort vdcAttrMem;

/* scroll window up given x1, y1, x2, y2 rectangle in current page */

void scrollupvdc(uchar X1, uchar Y1, uchar X2, uchar Y2)
{
  uchar XLen;
  ushort DispOfs, AttrOfs;

  XLen = X2-X1+1;
  DispOfs = Y1*vdcScrHorz+vdcDispMem+X1;
  AttrOfs = Y1*vdcScrHorz+vdcAttrMem+X1;
  for(; Y1 <= Y2; Y1++)
  {
    copymemvdc(DispOfs,DispOfs-vdcScrHorz,XLen);
    copymemvdc(AttrOfs,AttrOfs-vdcScrHorz,XLen);
    DispOfs += vdcScrHorz;
    AttrOfs += vdcScrHorz;
  }
}

