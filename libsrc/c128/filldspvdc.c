/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: filldspvdc.c,v 1.2 2008-07-08 13:10:24 stefano Exp $

*/

#include <c128/vdc.h>

extern uchar  vdcScrHorz;
//extern ushort vdcDispMem;

/* fill disp mem given x and y offset in current page */

void filldspvdc(uchar X, uchar Y, uchar CLen, uchar Ch)
{
  fillmemvdc(Y*vdcScrHorz+vdcDispMem+X,CLen,Ch);
}

