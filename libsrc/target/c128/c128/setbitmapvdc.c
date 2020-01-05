/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: setbitmapvdc.c,v 1.2 2016-06-16 21:13:07 dom Exp $

*/

#include <stdlib.h>
#include <c128/vdc.h>

/* set bit map mode, background and foreground colors */

void setbitmapvdc(ushort DispMem, ushort AttrMem, ushort F, ushort B)
{
  outvdc(vdcFgBgColor,(F << 4) | B);
  setdsppagevdc(DispMem,AttrMem);
  outvdc(vdcHzSmScroll,invdc(vdcHzSmScroll) | 0x80);
}
