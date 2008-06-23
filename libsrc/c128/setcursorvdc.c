/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: setcursorvdc.c,v 1.1 2008-06-23 17:34:35 stefano Exp $

*/

#include <c128/vdc.h>

/* set cursor's top and bottom scan lines and mode */

void setcursorvdc(uchar Top, uchar Bottom, uchar Mode)
{
  outvdc(vdcCurStScanLine,(Top | (Mode << 5)));
  outvdc(vdcCurEndScanLine,Bottom);
}
