include(__link__.m4)

#ifndef __COPPER_H__
#define __COPPER_H__

// copper instruction macros
// all 16-bit

#define CU_WAIT(ver,hor)  ((unsigned int)(0x8000 + ((hor & 0x3f) << 9) + (ver & 0x1ff)))
#define CU_MOVE(reg,val)  ((unsigned int)(((reg & 0x7f) << 8) + (val & 0xff))) 
#define CU_NOP            ((unsigned int)0xffff)
#define CU_STOP           ((unsigned int)0x0000)

#endif
