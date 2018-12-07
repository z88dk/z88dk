/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: setcursorvdc.c,v 1.2 2016-06-16 21:13:07 dom Exp $

*/

#include <c128/vdc.h>

/* set cursor's top and bottom scan lines and mode */

void setcursorvdc(ushort Top, ushort Bottom, ushort Mode)
{
  outvdc(vdcCurStScanLine,(Top | (Mode << 5)));
  outvdc(vdcCurEndScanLine,Bottom);
}
