/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: clrwinattrvdc.c,v 1.2 2016-06-16 21:13:07 dom Exp $

*/

#include <c128/vdc.h>


extern uchar  vdcScrHorz;
extern ushort vdcAttrMem;

/* clear attr window given x1, y1, x2, y2 rectangle in current page */

void clrwinattrvdc(ushort X1, ushort Y1, ushort X2, ushort Y2, ushort Ch)
{
  uchar XLen;
  ushort AttrOfs;

  AttrOfs = Y1*vdcScrHorz+vdcAttrMem+X1;
  XLen = X2-X1+1;
  for(; Y1 <= Y2; Y1++)
  {
    fillmemvdc(AttrOfs,XLen,Ch);
    AttrOfs += vdcScrHorz;
  }
}

