/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: restorevdc.c,v 1.1 2008-06-23 17:34:34 stefano Exp $

*/

#include <c128/vdc.h>


/* save and restore key vdc registers */

extern uchar vdcRegsToSave[];
extern uchar vdcRegs[];

void restorevdc(void)
{
  uchar I;

//  for(I = 0; I < sizeof(vdcRegs); I++)  /* restore vdc regs saved with savevdc() */
  for(I = 0; I < 36; I++)  /* restore vdc regs saved with savevdc() */
    outvdc(vdcRegsToSave[I],vdcRegs[I]);
}
