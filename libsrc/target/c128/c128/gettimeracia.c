/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: gettimeracia.c,v 1.1 2008-06-23 17:34:33 stefano Exp $

*/

#include <stdlib.h>
#include <c128/cia.h>

/* get cia timer a */

ushort gettimeracia (ushort C)
{
  return(inp(C+ciaTimerALo) | (inp(C+ciaTimerAHi) << 8));
}

