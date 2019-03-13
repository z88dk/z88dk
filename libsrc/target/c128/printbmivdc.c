/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: printbmivdc.c,v 1.3 2016-06-16 21:13:07 dom Exp $

*/

#include <string.h>
#include <stdlib.h>
#include <c128/vdc.h>

extern uchar  vdcScrHorz;
//extern ushort vdcDispMem;
extern ushort vdcCharMem;
extern uchar  vdcCharBytes;
extern uchar  vdcCharVert;

/* bit map string print given x and y char offset in current 640 X 480 page */

void printbmivdc(ushort X, ushort Y, char *TextStr)
{
  register uchar I;
  uchar  TextLen;
  uchar  CharBuf[vdcMaxCharBytes];
  ushort DispOfsX, DispOfsY, DispOfsYO, CharSet, CharSetOfs;

  TextLen = strlen(TextStr);
  if(TextLen > 0) /* don't print null strings */
  {
    DispOfsX = (((Y >> 1)*vdcScrHorz) << 4)+vdcDispMem+X;
    CharSet = (vdcCharsPerSet*vdcCharBytes)+vdcCharMem; /* use alt set */
    for(I = 0; TextStr[I]; I++, DispOfsX++)
    {
      CharSetOfs = vdcCharBytes*TextStr[I]+CharSet;
      outvdc(vdcUpdAddrHi,(uchar) (CharSetOfs >> 8));
      outvdc(vdcUpdAddrLo,(uchar) CharSetOfs);
      for(Y = 0; Y < 8; Y++)
        CharBuf[Y] = invdc(vdcCPUData);
      DispOfsY = DispOfsX;
      DispOfsYO = DispOfsY+vdcOddFldOfs;
      for(Y = 0; Y < 8; Y += 2, DispOfsY += vdcScrHorz, DispOfsYO += vdcScrHorz)
      {
        outvdc(vdcUpdAddrHi,(uchar) (DispOfsY >> 8));
        outvdc(vdcUpdAddrLo,(uchar) DispOfsY);
        outvdc(vdcCPUData,CharBuf[Y]);

        outvdc(vdcUpdAddrHi,(uchar) (DispOfsYO >> 8));
        outvdc(vdcUpdAddrLo,(uchar) DispOfsYO);
        outvdc(vdcCPUData,CharBuf[Y]);

        DispOfsY += vdcScrHorz;
        outvdc(vdcUpdAddrHi,(uchar) (DispOfsY >> 8));
        outvdc(vdcUpdAddrLo,(uchar) DispOfsY);
        outvdc(vdcCPUData,CharBuf[Y+1]);

        DispOfsYO += vdcScrHorz;
        outvdc(vdcUpdAddrHi,(uchar) (DispOfsYO >> 8));
        outvdc(vdcUpdAddrLo,(uchar) DispOfsYO);
        outvdc(vdcCPUData,CharBuf[Y+1]);
      }
    }
  }
}
