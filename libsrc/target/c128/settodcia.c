/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: settodcia.c,v 1.1 2008-06-23 17:34:35 stefano Exp $

*/

#include <stdlib.h>
#include <c128/cia.h>

/* set cia time of day clock */

void settodcia (ushort C, uchar *TOD)
{
  outp(C+ciaControlB,(inp(C+ciaControlB) & 0x7F)); /* bit 7 = 0 sets tod clock */
  outp(C+ciaTODHrs,TOD[0]);
  outp(C+ciaTODMin,TOD[1]);
  outp(C+ciaTODSec,TOD[2]);
  outp(C+ciaTODTen,TOD[3]);
}

