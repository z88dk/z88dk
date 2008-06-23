/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: settimerbcia.c,v 1.1 2008-06-23 17:34:35 stefano Exp $

*/

#include <stdlib.h>
#include <c128/cia.h>

/* set cia timer b and control reg b */

void settimerbcia (ushort C, ushort Latch, uchar CtrlReg)
{
  outp(C+ciaTimerBLo,(uchar) Latch);        /* timer latch lo */
  outp(C+ciaTimerBHi,(uchar) (Latch >> 8)); /* timer latch hi */
  outp(C+ciaControlB,CtrlReg);              /* set timer controls */
}
