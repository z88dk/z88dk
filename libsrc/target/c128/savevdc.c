/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: savevdc.c,v 1.1 2008-06-23 17:34:34 stefano Exp $

*/

#include <c128/vdc.h>

extern uchar vdcRegsToSave[];
extern uchar vdcRegs[];

uchar vdcRegsToSave[] =      /* vdc registers to save and restore */
{
0,   1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13,
20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
34, 35, 36
};

//uchar vdcRegs[sizeof(vdcRegsToSave)-1]; /* saved vdc registers */
uchar vdcRegs[36]; /* saved vdc registers */

/* save and restore key vdc registers */

void savevdc(void)
{
  uchar I;

//  for(I = 0; I < sizeof(vdcRegs); I++)    /* save key vdc regs */
  for(I = 0; I < 36; I++)    /* save key vdc regs */
    vdcRegs[I] = invdc(vdcRegsToSave[I]);
}

