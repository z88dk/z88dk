/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: decodelinepcx.c,v 1.2 2008-07-08 13:10:24 stefano Exp $

*/

#include <stdio.h>
#include <c128/vdc.h>
#include <c128/pcx.h>

extern uchar   vdcScrHorz;
//extern ushort  vdcDispMem;
extern FILE    *pcxFile;
extern pcxHead pcxHeader;
extern ushort  pcxYSize;

/* decode 2 bit .pcx line to vdc. */

void decodelinepcx(ushort X, ushort Y)
{
  register uchar KeyByte, RunCnt;
  register ushort DecodeCnt = 0;
  register ushort DispOfs;

  DispOfs = Y*vdcScrHorz+vdcDispMem+X;
  outvdc(vdcUpdAddrHi,(uchar) (DispOfs >> 8));
  outvdc(vdcUpdAddrLo,(uchar) DispOfs);
  do
  {
    KeyByte = fgetc(pcxFile) & 0xFF;
    if ((KeyByte & 0xC0) == 0xC0)
    {
      RunCnt = KeyByte & 0x3F;
      KeyByte = fgetc(pcxFile);
      outvdc(vdcVtSmScroll,(invdc(vdcVtSmScroll) & 0x7F));
      outvdc(vdcCPUData,KeyByte);
      if (RunCnt > 1)
        outvdc(vdcWordCnt,RunCnt-1);
      DispOfs += RunCnt;
      DecodeCnt += RunCnt;
    }
    else
    {
      outvdc(vdcCPUData,KeyByte);
      DispOfs++;
      DecodeCnt++;
    }
  }
  while(DecodeCnt < pcxHeader.BytesPerLine);
}

