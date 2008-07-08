/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: clrscrvdc.c,v 1.2 2008-07-08 13:10:24 stefano Exp $

*/

#include <c128/vdc.h>

extern ushort vdcScrSize;
//extern ushort vdcDispMem;

/* fast disp page clear with any byte */

void clrscrvdc(uchar Ch)
{
  fillmemvdc(vdcDispMem,vdcScrSize,Ch);
}
