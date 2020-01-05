/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: set80x50textvdc.c,v 1.1 2008-06-23 17:34:34 stefano Exp $

*/

#include <stdlib.h>
#include <c128/vdc.h>

/* set 80 x 50 interlaced text mode with 8 x 8 chars */

void set80x50textvdc(void)
{
  outvdc(vdcHzTotal,128);
  outvdc(vdcVtTotal,64);
  outvdc(vdcVtDisp,50);
  outvdc(vdcVtSyncPos,58);
  outvdc(vdcIlaceMode,3);
  outvdc(vdcChTotalVt,7);
}

