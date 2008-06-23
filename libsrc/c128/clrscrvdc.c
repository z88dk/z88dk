/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: clrscrvdc.c,v 1.1 2008-06-23 17:34:32 stefano Exp $

*/

#include <c128/vdc.h>

extern ushort vdcScrSize;
extern ushort vdcDispMem;

/* fast disp page clear with any byte */

void clrscrvdc(uchar Ch)
{
  fillmemvdc(vdcDispMem,vdcScrSize,Ch);
}
