/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: setdsppagevdc.c,v 1.1 2008-06-23 17:34:35 stefano Exp $

*/

#include <c128/vdc.h>

/* sets which disp and attr page is showing */

void setdsppagevdc(ushort DPage, ushort APage)
{
  outvdc(vdcDspStAddrHi,(uchar) (DPage >> 8));
  outvdc(vdcDspStAddrLo,(uchar) DPage);
  outvdc(vdcAttrStAddrHi,(uchar) (APage >> 8));
  outvdc(vdcAttrStAddrLo,(uchar) APage);
}

