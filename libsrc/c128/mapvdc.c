/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: mapvdc.c,v 1.2 2008-07-08 13:10:24 stefano Exp $

*/

#include <c128/vdc.h>

extern uchar  vdcScrHorz;
extern uchar  vdcScrVert;
extern ushort vdcScrSize;
extern ushort vdcAttrMem;
extern ushort vdcCharMem;
extern ushort vdcCharMemSize;
extern uchar  vdcCharBytes;
extern uchar  vdcCharVert;
extern ushort vdcBitMapMemSize;

#asm

._vdcScrHorz	defw	0
._vdcScrVert	defw	0
._vdcScrSize	defw	0
._vdcAttrMem	defw	0
._vdcCharMem	defw	$2000
._vdcCharMemSize	defw	0
._vdcCharBytes	defw	0
._vdcCharVert	defw	0
._vdcBitMapMemSize	defw	16000

#endasm

/*
uchar  vdcScrHorz;
uchar  vdcScrVert;
ushort vdcScrSize;
ushort vdcDispMem;
ushort vdcAttrMem;
ushort vdcCharMem       = 0x2000;
ushort vdcCharMemSize;
uchar  vdcCharBytes;
uchar  vdcCharVert;
ushort vdcBitMapMemSize = 16000;
*/

/*
set global 'vdc' prefixed vars from current vdc settings.  vdc register 28
bits 5-7 only return 0x2000, 0x6000, 0xa000 and 0xe000 on my c128d, so your
application is in charge of keeping track of the char mem address.  when
a program is first run it is set to 0x2000 which is the default cp/m value.
bit map mem size is also only set once at the start of a program.  your app
must keep track of this too.
*/

void mapvdc(void)
{
  vdcScrHorz = invdc(vdcHzDisp);
  vdcScrVert = invdc(vdcVtDisp);
  vdcScrSize = vdcScrHorz*vdcScrVert;
  vdcDispMem = (invdc(vdcDspStAddrHi) << 8)+invdc(vdcDspStAddrLo);
  vdcAttrMem = (invdc(vdcAttrStAddrHi) << 8)+invdc(vdcAttrStAddrLo);
  vdcCharVert = (invdc(vdcChTotalVt) & 0x1F)+1;
  if (vdcCharVert > 16)
  {
    vdcCharBytes = vdcMaxCharBytes;
    vdcCharMemSize = (vdcCharsPerSet*vdcCharBytes) << 1;
  }
  else
  {
    vdcCharBytes = vdcMaxCharBytes >> 1;
    vdcCharMemSize = (vdcCharsPerSet*vdcCharBytes) << 1;
  }
}
