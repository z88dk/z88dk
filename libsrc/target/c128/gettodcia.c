/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: gettodcia.c,v 1.1 2008-06-23 17:34:33 stefano Exp $

*/

#include <stdlib.h>
#include <c128/cia.h>

/* get cia time of day clock */

void gettodcia (ushort C, uchar *TOD)
{
  TOD[0] = inp(C+ciaTODHrs); /* c = cia chip addr */
  TOD[1] = inp(C+ciaTODMin);
  TOD[2] = inp(C+ciaTODSec);
  TOD[3] = inp(C+ciaTODTen);
}

