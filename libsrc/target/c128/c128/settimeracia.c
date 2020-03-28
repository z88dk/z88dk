/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: settimeracia.c,v 1.2 2016-06-16 21:13:07 dom Exp $

*/

#include <stdlib.h>
#include <c128/cia.h>

/* set cia timer a and control reg a */

void settimeracia (ushort C, ushort Latch, ushort CtrlReg)
{
  outp(C+ciaTimerALo,(uchar) Latch);        /* timer latch lo */
  outp(C+ciaTimerAHi,(uchar) (Latch >> 8)); /* timer latch hi */
  outp(C+ciaControlA,CtrlReg);              /* set timer controls */
}
