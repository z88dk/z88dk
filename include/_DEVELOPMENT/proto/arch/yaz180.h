include(__link__.m4)

#ifndef __ARCH_YAZ180_H__
#define __ARCH_YAZ180_H__

#include <arch.h>

// provide the asci1 input and output stream instantiation
// note that asci0 is attached to stdin and stdout

extern FILE *linein;
extern FILE *lineout;

// provide the simple mutex locks for hardware resources

extern uint8_t shadowLock;      //  mutex for alternate registers
extern uint8_t prt0Lock;        //  mutex for PRT0 
extern uint8_t prt1Lock;        //  mutex for PRT1
extern uint8_t dmac0Lock;       //  mutex for DMAC0
extern uint8_t dmac1Lock;       //  mutex for DMAC1
extern uint8_t csioLock;        //  mutex for CSI/O

extern uint8_t asci0RxLock;     //  mutex for Rx0
extern uint8_t asci0TxLock;     //  mutex for Tx0
extern uint8_t asci1RxLock;     //  mutex for Rx1
extern uint8_t asci1TxLock;     //  mutex for Tx1

extern uint8_t APULock;         //  mutex for APU

// provide the simple mutex locks for the BANK (for system usage)

extern uint8_t bankLockBase[];  // base address for 16 BANK locks

// provide methods to get, try, and give the simple mutex locks

__DPROTO(`a,b,c,d,e,iyh,iyl',`a,b,c,d,e,iyh,iyl',void,,lockGet,uint8_t * mutex)
__DPROTO(`a,b,c,d,e,iyh,iyl',`a,b,c,d,e,iyh,iyl',uint8_t,,lockTry,uint8_t * mutex)
__DPROTO(`a,b,c,d,e,iyh,iyl',`a,b,c,d,e,iyh,iyl',void,,lockGive,uint8_t * mutex)

// memcpy_far & memset_far functions

__OPROTO(`iyh,iyl',`iyh,iyl',void,*,memcpy_far,void *str1, int8_t bank1, const void *str2, const int8_t bank2, size_t n)
__OPROTO(`b,c,iyh,iyl',`b,c,iyh,iyl',void,*,memset_far,void *str, int8_t bank, const int16_t c, size_t n)

// halt the YAZ180 with single step hardware.

#define __BREAK  __BREAK_HELPER()
__OPROTO(`a,d,e,h,l,iyl,iyh',`a,d,e,h,l,iyl,iyh',void,,__BREAK_HELPER,void)

#endif
