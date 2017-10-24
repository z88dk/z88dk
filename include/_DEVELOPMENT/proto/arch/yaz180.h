include(__link__.m4)

#ifndef __ARCH_YAZ180_H__
#define __ARCH_YAZ180_H__

#include <arch.h>

// provide the asci1 input and output stream instantiation
// note that asci0 is attached to stdin and stdout

extern FILE *linein;
extern FILE *lineout;

// Halt the YAZ180 with single step hardware.

#define __BREAK  __BREAK_HELPER()
__OPROTO(`a,d,e,h,l,iyl,iyh',`a,d,e,h,l,iyl,iyh',void,,__BREAK_HELPER,void)

#endif
