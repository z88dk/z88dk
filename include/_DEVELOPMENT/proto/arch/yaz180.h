include(__link__.m4)

#ifndef __ARCH_YAZ180_H__
#define __ARCH_YAZ180_H__

#include <arch.h>

// provide the asci1 input and output stream instantiation
// note that asci0 is attached to stdin and stdout

extern FILE *linein;
extern FILE *lineout;

// provide the location for stack pointers to be stored

extern uint16_t *bios_sp;      // yabios SP here when other banks running
extern uint16_t *bank_sp;      // bank SP storage, in Page0 TCB 0x003B

// provide the location for important Page 0 bank addresses

extern uint8_t bank_cpm_iobyte;         // CP/M IOBYTE
extern uint8_t bank_cmp_default_drive;  // CP/M default drive
extern uint16_t *bank_cpm_bdos_addr;    // CPM/ BDOS entry address

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

__DPROTO(`b,c,d,e,iyh,iyl',`b,c,d,e,iyh,iyl',void,,lock_get,uint8_t * mutex)
__DPROTO(`b,c,d,e,iyh,iyl',`b,c,d,e,iyh,iyl',uint8_t,,lock_try,uint8_t * mutex)
__DPROTO(`b,c,d,e,iyh,iyl',`b,c,d,e,iyh,iyl',void,,lock_give,uint8_t * mutex)

// provide bank relative address functions

__DPROTO(`b,c,d,e,h,iyh,iyl',`b,c,d,e,h,iyh,iyl',int8_t,,bank_get_rel,uint8_t bankAbs)
__DPROTO(`b,c,d,e,h,iyh,iyl',`b,c,d,e,h,iyh,iyl',uint8_t,,bank_get_abs,int8_t bankRel)
__OPROTO(`b,c,iyh,iyl',`b,c,iyh,iyl',void,,jp_far,void *str, int8_t bank)

// provide memcpy_far and memset_far functions

__OPROTO(`iyh,iyl',`iyh,iyl',void,*,memcpy_far,void *str1, int8_t bank1, const void *str2, const int8_t bank2, size_t n)
__OPROTO(`b,c,iyh,iyl',`b,c,iyh,iyl',void,*,memset_far,void *str, int8_t bank, const int16_t c, size_t n)

// provide load_hex and load_bin functions

__DPROTO(`iyh,iyl',`iyh,iyl',void,,load_hex,uint8_t bankAbs)

// halt the YAZ180 with single step hardware.

#define __BREAK  __BREAK_HELPER()
__OPROTO(`a,d,e,h,l,iyl,iyh',`a,d,e,h,l,iyl,iyh',void,,__BREAK_HELPER,void)

#endif
