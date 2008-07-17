/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: clg.c,v 1.1 2008-07-17 15:39:56 stefano Exp $

*/

#include <graphics.h>
#include <c128/vdc.h>

/* 64k vdc locations */
#define appBitMapMem 0x4000
#define appAttrMem   0x0800


extern ushort    vdcBitMapMemSize;
extern ushort    vdcAttrMem;

/* Clear Graphics */

int clg()
{
  vdcBitMapMemSize = 49152;
  set64kvdc();          /* set 64k mode */
  //setcursorvdc(0,0,vdcCurNone);    /* turn cursor off */
  outvdc(vdcFgBgColor,vdcWhite);   /* white screen */
  attrsoffvdc();
  //setbitmapvdc(vdcDispMem,vdcAttrMem,vdcBlack,vdcWhite);
  setbitmapintvdc(appBitMapMem,appAttrMem,vdcBlack,vdcWhite);
  mapvdc();
  clrbitmapvdc(0);                 /* clear bit map */
}
