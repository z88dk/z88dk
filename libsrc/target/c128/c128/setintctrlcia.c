/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: setintctrlcia.c,v 1.2 2016-06-16 21:13:07 dom Exp $

*/

#include <stdlib.h>
#include <c128/cia.h>

/* set cia interrupt control register */

void setintctrlcia (ushort C, ushort Icr)
{
  inp(C+ciaIntCtrl);      /* clear cia icr status */
  outp(C+ciaIntCtrl,Icr); /* set or clear icr irq enable bits */
}

