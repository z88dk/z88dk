/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: fillattrvdc.c,v 1.2 2016-06-16 21:13:07 dom Exp $

*/

#include <c128/vdc.h>

extern uchar  vdcScrHorz;
extern ushort vdcAttrMem;

/* fill attr mem given x and y offset in current page */

void fillattrvdc(ushort X, ushort Y, ushort ALen, ushort Attr)
{
  fillmemvdc(Y*vdcScrHorz+vdcAttrMem+X,ALen,Attr);
}

