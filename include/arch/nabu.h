

#ifndef ARCH_NABU_H
#define ARCH_NABU_H

#include <sys/compiler.h>

__sfr __at 0x00 IO_CONTROL;


__sfr __at 0x40 IO_AYDATA;
__sfr __at 0x41 IO_AYLATCH;

__sfr __at 0x80 IO_HCCA;

__sfr __at 0x90 IO_KEYBOARD;
__sfr __at 0x91 IO_KEYBOARD_STATUS;


__sfr __at 0xA0 IO_VDPDATA;
__sfr __at 0xA1 IO_VDPLATCH;

__sfr __at 0xB0 IO_PRINTER;

#define NABU_INT_HCCA_RX   0x80
#define NABU_INT_HCCA_TX   0x40
#define NABU_INT_KBD       0x20
#define NABU_INT_VSYNC     0x10
#define NABU_INT_CARD0     0x08
#define NABU_INT_CARD1     0x02
#define NABU_INT_CARD2     0x02
#define NABU_INT_CARD3     0x01



extern void __LIB__ nabu_set_interrupt(int enabled) __z88dk_fastcall;


#endif
