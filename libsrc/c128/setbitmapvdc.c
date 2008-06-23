/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: setbitmapvdc.c,v 1.1 2008-06-23 17:34:35 stefano Exp $

*/

#include <stdlib.h>
#include <c128/vdc.h>

/* set bit map mode, background and foreground colors */

void setbitmapvdc(ushort DispMem, ushort AttrMem, uchar F, uchar B)
{
  outvdc(vdcFgBgColor,(F << 4) | B);
  setdsppagevdc(DispMem,AttrMem);
  outvdc(vdcHzSmScroll,invdc(vdcHzSmScroll) | 0x80);
}
