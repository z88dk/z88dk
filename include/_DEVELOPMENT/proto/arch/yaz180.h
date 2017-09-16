include(__link__.m4)

#ifndef __ARCH_YAZ180_H__
#define __ARCH_YAZ180_H__

#include <arch.h>

// Halt the YAZ180 with single step hardware.

#define __BREAK __BREAK_HELPER()

__OPROTO(`a,d,e,h,l,iy,iyh',`a,d,e,h,l,iyl,iyh',void,,__BREAK_HELPER,void)

#endif
