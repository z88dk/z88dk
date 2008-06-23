/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: setintctrlcia.c,v 1.1 2008-06-23 17:34:35 stefano Exp $

*/

#include <stdlib.h>
#include <c128/cia.h>

/* set cia interrupt control register */

void setintctrlcia (ushort C, uchar Icr)
{
  inp(C+ciaIntCtrl);      /* clear cia icr status */
  outp(C+ciaIntCtrl,Icr); /* set or clear icr irq enable bits */
}

