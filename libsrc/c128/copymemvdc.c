/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: copymemvdc.c,v 1.1 2008-06-23 17:34:32 stefano Exp $

*/

#include <c128/vdc.h>

/* fast copy using block copy */

void copymemvdc(ushort SMem, ushort DMem, ushort CopyLen)
{
  uchar Blocks, Remain;
  register uchar I;

  outvdc(vdcUpdAddrHi,(uchar) (DMem >> 8));
  outvdc(vdcUpdAddrLo,(uchar) DMem);
  outvdc(vdcVtSmScroll,(invdc(vdcVtSmScroll) | 0x80));
  outvdc(vdcBlkCpySrcAddrHi,(uchar) (SMem >> 8));
  outvdc(vdcBlkCpySrcAddrLo,(uchar) SMem);
  if (CopyLen > vdcMaxBlock)
  {
    Blocks = CopyLen/vdcMaxBlock;
    Remain = CopyLen%vdcMaxBlock;
    for(I = 1; I <= Blocks; I++)
      outvdc(vdcWordCnt,vdcMaxBlock);
    if (Remain > 0)
      outvdc(vdcWordCnt,Remain);
  }
  else
    if (CopyLen > 0)
      outvdc(vdcWordCnt,CopyLen);
}
