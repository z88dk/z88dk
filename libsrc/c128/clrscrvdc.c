/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: clrscrvdc.c,v 1.3 2016-06-16 21:13:07 dom Exp $

*/

#include <c128/vdc.h>

extern ushort vdcScrSize;
//extern ushort vdcDispMem;

/* fast disp page clear with any byte */

void clrscrvdc(ushort Ch)
{
  fillmemvdc(vdcDispMem,vdcScrSize,Ch);
}
