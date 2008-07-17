/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: clg.c,v 1.1 2008-07-17 15:39:56 stefano Exp $

*/

#include <graphics.h>
#include <c128/vdc.h>

//extern ushort    vdcBitMapMemSize;
extern ushort    vdcAttrMem;

/* Clear Graphics */

int clg()
{
  //vdcBitMapMemSize = 16000;
  mapvdc();
  //setcursorvdc(0,0,vdcCurNone);    /* turn cursor off */
  outvdc(vdcFgBgColor,vdcWhite);   /* white screen */
  attrsoffvdc();                   /* disable attrs to work on 16k vdc */
  setbitmapvdc(vdcDispMem,vdcAttrMem,vdcBlack,vdcWhite);
  clrbitmapvdc(0);                 /* clear bit map */
}
