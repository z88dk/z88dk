/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: printstrvdc.c,v 1.3 2016-06-16 21:13:07 dom Exp $

*/

#include <string.h>
#include <c128/vdc.h>

extern uchar  vdcScrHorz;
//extern ushort vdcDispMem;

/* fast vdc string print given x and y offset in current page */

void printstrvdc(ushort X, ushort Y, ushort Attr, char *TextStr)
{
  register uchar I, TextLen;
  ushort DispOfs;

  TextLen = strlen(TextStr);
  if(TextLen > 0)
  {
  DispOfs = Y*vdcScrHorz+vdcDispMem+X; /* calc disp mem offset */
  fillattrvdc(X,Y,TextLen,Attr);       /* use block fill for attrs */
  outvdc(vdcUpdAddrHi,(uchar) (DispOfs >> 8));
  outvdc(vdcUpdAddrLo,(uchar) DispOfs); /* set addr of first char */
  for(I = 0; TextStr[I]; I++)          /* send str to vdc disp mem */
    outvdc(vdcCPUData,TextStr[I]);
  }
}

