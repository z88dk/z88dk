/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: winvdc.c,v 1.2 2016-06-16 21:13:07 dom Exp $

*/

#include <string.h>
#include <c128/vdc.h>


uchar vdcWinChars[] = {32,32,244,231,204,239,250};
uchar vdcShadow = vdcAltChrSet+vdcDarkGray;


/* draw window given x1, y1, x2, y2 rectangle in current page */

void winvdc(ushort X1, ushort Y1, ushort X2, ushort Y2, ushort Attr, char *Title)
{
  char  ChSave;
  uchar InsideLen, TitleLen;
  register uchar Y;

  InsideLen = X2-X1-1;
  clrwinvdc(X1,Y1,X2,Y2,vdcWinChars[0]);
  clrwinattrvdc(X1,Y1,X2,Y2,Attr);
  filldspvdc(X1,Y1,InsideLen+2,vdcWinChars[1]);
  if (Title != "")
  {
    TitleLen = strlen(Title);
    if (TitleLen > InsideLen)
    {
      ChSave = Title[InsideLen];
      Title[InsideLen] = 0;
      printstrvdc(X1+1,Y1,Attr,Title);
      Title[InsideLen] = ChSave;
    }
    else
      printstrvdc(((InsideLen-TitleLen) >> 1)+X1+1,Y1,Attr,Title);
  }
  fillattrvdc(X1,Y1,InsideLen+2,Attr | vdcRvsVid);
  filldspvdc(X1,Y2,1,vdcWinChars[4]);
  filldspvdc(X1+1,Y2,InsideLen,vdcWinChars[5]);
  filldspvdc(X2,Y2,1,vdcWinChars[6]);
  fillattrvdc(X1+1,Y2+1,InsideLen+2,vdcShadow);
  fillattrvdc(X2+1,Y2,1,vdcShadow);
  for(Y1++, Y2--, Y = Y1; Y <= Y2; Y++)
  {
    filldspvdc(X1,Y,1,vdcWinChars[2]);
    filldspvdc(X2,Y,1,vdcWinChars[3]);
    fillattrvdc(X2+1,Y,1,vdcShadow);
  }
}

