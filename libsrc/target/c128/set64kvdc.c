/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: set64kvdc.c,v 1.1 2008-06-23 17:34:34 stefano Exp $

*/

#include <stdlib.h>
#include <c128/vdc.h>


/* set vdc to 64k mode */

void set64kvdc(void)
{
  outvdc (vdcChSetStAddr,invdc(vdcChSetStAddr) | 0x10);
}

