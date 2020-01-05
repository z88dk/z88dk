/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: attrsonvdc.c,v 1.1 2008-06-23 17:34:31 stefano Exp $

*/

#include <stdlib.h>
#include <c128/vdc.h>

/* turn attributes on */

void attrsonvdc(void)
{
  outvdc(vdcHzSmScroll,invdc(vdcHzSmScroll) | 0x40);
}
