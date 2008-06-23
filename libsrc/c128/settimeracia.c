/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: settimeracia.c,v 1.1 2008-06-23 17:34:35 stefano Exp $

*/

#include <stdlib.h>
#include <c128/cia.h>

/* set cia timer a and control reg a */

void settimeracia (ushort C, ushort Latch, uchar CtrlReg)
{
  outp(C+ciaTimerALo,(uchar) Latch);        /* timer latch lo */
  outp(C+ciaTimerAHi,(uchar) (Latch >> 8)); /* timer latch hi */
  outp(C+ciaControlA,CtrlReg);              /* set timer controls */
}
