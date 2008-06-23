/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: fillattrvdc.c,v 1.1 2008-06-23 17:34:33 stefano Exp $

*/

#include <c128/vdc.h>

extern uchar  vdcScrHorz;
extern ushort vdcAttrMem;

/* fill attr mem given x and y offset in current page */

void fillattrvdc(uchar X, uchar Y, uchar ALen, uchar Attr)
{
  fillmemvdc(Y*vdcScrHorz+vdcAttrMem+X,ALen,Attr);
}

