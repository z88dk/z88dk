/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: clrwinattrvdc.c,v 1.1 2008-06-23 17:34:32 stefano Exp $

*/

#include <c128/vdc.h>


extern uchar  vdcScrHorz;
extern ushort vdcAttrMem;

/* clear attr window given x1, y1, x2, y2 rectangle in current page */

void clrwinattrvdc(uchar X1, uchar Y1, uchar X2, uchar Y2, uchar Ch)
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

