/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: copydspvdc.c,v 1.1 2008-06-23 17:34:32 stefano Exp $

*/

#include <c128/vdc.h>

extern ushort vdcScrSize;

/* copies disp and attr page to new pages */

void copydspvdc(ushort SDPage, ushort SAPage, ushort DDPage, ushort DAPage)
{
  copymemvdc(SDPage,DDPage,vdcScrSize);
  copymemvdc(SAPage,DAPage,vdcScrSize);
}
