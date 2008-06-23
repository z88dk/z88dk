/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: clrbitmapvdc.c,v 1.1 2008-06-23 17:34:32 stefano Exp $

*/

#include <c128/vdc.h>

extern vdcDispMem;
extern vdcBitMapMemSize;

/* clear bit map */

void clrbitmapvdc(uchar Filler)
{
  fillmemvdc(vdcDispMem,vdcBitMapMemSize,Filler);
}
