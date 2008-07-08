/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: clrbitmapvdc.c,v 1.2 2008-07-08 13:10:24 stefano Exp $

*/

#include <c128/vdc.h>

//extern vdcDispMem;
extern vdcBitMapMemSize;

/* clear bit map */

void clrbitmapvdc(uchar Filler)
{
  fillmemvdc(vdcDispMem,vdcBitMapMemSize,Filler);
}
