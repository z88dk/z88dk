/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: is64kvdc.c,v 1.1 2008-06-23 17:34:33 stefano Exp $

*/

#include <stdlib.h>
#include <c128/vdc.h>


/* is vdc in 64k mode? */

uchar is64kvdc(void)
{
  if((invdc(vdcChSetStAddr) & 0x10) == 0x10)
    return(1);
  else
    return(0);
}

