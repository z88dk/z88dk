/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: setbitmapintvdc.c,v 1.1 2008-06-23 17:34:34 stefano Exp $

*/

#include <stdlib.h>
#include <c128/vdc.h>

/* set 640 x 480 interlace bit map mode, background and foreground colors */

void setbitmapintvdc(ushort DispMem, ushort AttrMem, uchar F, uchar B)
{
  outvdc(vdcFgBgColor,(F << 4) | B);
  setdsppagevdc(DispMem,AttrMem);
  outvdc(vdcHzTotal,126);
  outvdc(vdcHzDisp,80);
  outvdc(vdcHzSyncPos,102);
  outvdc(vdcVtTotal,76);
  outvdc(vdcVtTotalAdj,6);
  outvdc(vdcVtDisp,76);
  outvdc(vdcVtSyncPos,71);
  outvdc(vdcIlaceMode,3);
  outvdc(vdcChTotalVt,6);
  outvdc(vdcVtSmScroll,0);
  outvdc(vdcHzSmScroll,135);
  outvdc(vdcAddrIncPerRow,0);
}
