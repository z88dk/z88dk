/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: filldspvdc.c,v 1.3 2016-06-16 21:13:07 dom Exp $

*/

#include <c128/vdc.h>

extern uchar  vdcScrHorz;
//extern ushort vdcDispMem;

/* fill disp mem given x and y offset in current page */

void filldspvdc(ushort X, ushort Y, ushort CLen, ushort Ch)
{
  fillmemvdc(Y*vdcScrHorz+vdcDispMem+X,CLen,Ch);
}

