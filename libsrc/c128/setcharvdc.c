/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: setcharvdc.c,v 1.1 2008-06-23 17:34:35 stefano Exp $

*/

#include <c128/vdc.h>

/* set char def mem addr */

void setcharvdc(ushort CharMem)
{
  outvdc(vdcChSetStAddr,
  (invdc(vdcChSetStAddr) & 0x10) | ((uchar) (CharMem >> 8) & 0xE0));
}

