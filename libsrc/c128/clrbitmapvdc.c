/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: clrbitmapvdc.c,v 1.3 2016-06-16 21:13:07 dom Exp $

*/

#include <c128/vdc.h>

//extern vdcDispMem;
extern vdcBitMapMemSize;

/* clear bit map */

void clrbitmapvdc(ushort Filler)
{
  fillmemvdc(vdcDispMem,vdcBitMapMemSize,Filler);
}
