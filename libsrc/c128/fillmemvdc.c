/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: fillmemvdc.c,v 1.2 2016-06-16 21:13:07 dom Exp $

*/

#include <c128/vdc.h>

/* fast fill using block writes */

void fillmemvdc(ushort FillMem, ushort FillLen, ushort Filler)
{
  uchar Blocks, Remain;
  register uchar I;

  outvdc(vdcUpdAddrHi,(uchar) (FillMem >> 8));
  outvdc(vdcUpdAddrLo,(uchar) FillMem);
  outvdc(vdcVtSmScroll,(invdc(vdcVtSmScroll) & 0x7F));
  outvdc(vdcCPUData,Filler);
  if (FillLen > vdcMaxBlock)
  {
    Blocks = FillLen/vdcMaxBlock;
    Remain = FillLen%vdcMaxBlock;
    for(I = 1; I <= Blocks; I++)
      outvdc(vdcWordCnt,vdcMaxBlock);
    if (Remain > 1)
      outvdc(vdcWordCnt,--Remain);
  }
  else
    if (FillLen > 1)
      outvdc(vdcWordCnt,--FillLen);
}

