/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: printbmvdc.c,v 1.1 2008-06-23 17:34:34 stefano Exp $

*/

#include <string.h>
#include <stdlib.h>
#include <c128/vdc.h>

extern uchar  vdcScrHorz;
extern ushort vdcDispMem;
extern ushort vdcCharMem;
extern uchar  vdcCharBytes;
extern uchar  vdcCharVert;

/* bit map string print given x and y char offset in current page */

void printbmvdc(uchar X, uchar Y, uchar Attr, char *TextStr)
{
  register uchar I;
  uchar  TextLen;
  uchar  CharBuf[vdcMaxCharBytes];
  ushort DispOfsX, DispOfsY, CharSet, CharSetOfs;

  TextLen = strlen(TextStr);
  if(TextLen > 0) /* don't print null strings */
  {
    DispOfsX = ((Y*vdcScrHorz)*vdcCharVert)+vdcDispMem+X;
    CharSet = (vdcCharsPerSet*vdcCharBytes)+vdcCharMem; /* use alt set */
    fillattrvdc(X,Y,TextLen,Attr);
    for(I = 0; TextStr[I]; I++, DispOfsX++)
    {
      CharSetOfs = vdcCharBytes*TextStr[I]+CharSet;
      outvdc(vdcUpdAddrHi,(uchar) (CharSetOfs >> 8));
      outvdc(vdcUpdAddrLo,(uchar) CharSetOfs);
      for(Y = 0; Y < vdcCharVert; Y++)
        CharBuf[Y] = invdc(vdcCPUData);
      DispOfsY = DispOfsX;
      for(Y = 0; Y < vdcCharVert; Y++, DispOfsY += vdcScrHorz)
      {
        outvdc(vdcUpdAddrHi,(uchar) (DispOfsY >> 8));
        outvdc(vdcUpdAddrLo,(uchar) DispOfsY);
        outvdc(vdcCPUData,CharBuf[Y]);
      }
    }
  }
}
