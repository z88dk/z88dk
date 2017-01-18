/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: clrattrvdc.c,v 1.2 2016-06-16 21:13:07 dom Exp $

*/

#include <c128/vdc.h>

extern ushort vdcScrSize;
extern ushort vdcAttrMem;

/* fast attr page clear with any byte */

void clrattrvdc(ushort Attr)
{
  fillmemvdc(vdcAttrMem,vdcScrSize,Attr);
}
