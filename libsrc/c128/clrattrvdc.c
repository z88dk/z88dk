/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: clrattrvdc.c,v 1.1 2008-06-23 17:34:32 stefano Exp $

*/

#include <c128/vdc.h>

extern ushort vdcScrSize;
extern ushort vdcAttrMem;

/* fast attr page clear with any byte */

void clrattrvdc(uchar Attr)
{
  fillmemvdc(vdcAttrMem,vdcScrSize,Attr);
}
