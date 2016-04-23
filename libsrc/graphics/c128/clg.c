/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: clg.c,v 1.2 2016-04-23 08:20:39 dom Exp $

*/

#include <graphics.h>
#include <c128/vdc.h>

//extern ushort    vdcBitMapMemSize;
extern ushort    vdcAttrMem;

/* Clear Graphics */

void clg()
{
  //vdcBitMapMemSize = 16000;
  mapvdc();
  //setcursorvdc(0,0,vdcCurNone);    /* turn cursor off */
  outvdc(vdcFgBgColor,vdcWhite);   /* white screen */
  attrsoffvdc();                   /* disable attrs to work on 16k vdc */
  setbitmapvdc(vdcDispMem,vdcAttrMem,vdcBlack,vdcWhite);
  clrbitmapvdc(0);                 /* clear bit map */
}
