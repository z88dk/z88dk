include(__link__.m4)

#ifndef __ARCH_YAZ180_H__
#define __ARCH_YAZ180_H__

#include <arch.h>

// Halt the YAZ180 with single step hardware.
// Affects BC, so restore these if you need them.

#define __BREAK             \
        __asm               \
        ld  bc,__IO_BREAK   \
        out (c),c           \
        __endasm;

#endif
