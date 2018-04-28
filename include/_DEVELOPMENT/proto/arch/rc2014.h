include(__link__.m4)

#ifndef __ARCH_RC2014_H__
#define __ARCH_RC2014_H__

#include <arch.h>

// GLOBAL VARIABLES


// IO MAPPED REGISTERS

#ifdef __CLANG

extern unsigned char IO_DIO

extern unsigned char IO_ACIA_CONTROL;
extern unsigned char IO_ACIA_STATUS;
extern unsigned char IO_ACIA_DATA;

extern unsigned char IO_SIOA_CONTROL;
extern unsigned char IO_SIOA_DATA;
extern unsigned char IO_SIOB_CONTROL;
extern unsigned char IO_SIOB_DATA;

extern unsigned char IO_PIO_PORT_A;
extern unsigned char IO_PIO_PORT_B;
extern unsigned char IO_PIO_PORT_C;
extern unsigned char IO_PIO_CONTROL;

extern unsigned char IO_PIO_IDE_LSB;
extern unsigned char IO_PIO_IDE_MSB;
extern unsigned char IO_PIO_IDE_CTL;
extern unsigned char IO_PIO_IDE_CONFIG;

extern unsigned char IO_PROM_RESET;
extern unsigned char IO_PROM_TOGGLE;

#else

__sfr __at __IO_DIO_PORT       IO_DIO;

__sfr __at __IO_ACIA_CONTROL_REGISTER   IO_ACIA_CONTROL;
__sfr __at __IO_ACIA_STATUS_REGISTER    IO_ACIA_STATUS;
__sfr __at __IO_ACIA_DATA_REGISTER      IO_ACIA_DATA;

__sfr __at __IO_SIOA_CONTROL_REGISTER   IO_SIOA_CONTROL;
__sfr __at __IO_SIOA_DATA_REGISTER      IO_SIOA_DATA;
__sfr __at __IO_SIOB_CONTROL_REGISTER   IO_SIOB_CONTROL;
__sfr __at __IO_SIOB_DATA_REGISTER      IO_SIOB_DATA;

__sfr __at __IO_PIO_PORT_A      IO_PIO_PORT_A;
__sfr __at __IO_PIO_PORT_B      IO_PIO_PORT_B;
__sfr __at __IO_PIO_PORT_C      IO_PIO_PORT_C;
__sfr __at __IO_PIO_CONTROL     IO_PIO_CONTROL;

__sfr __at __IO_PIO_IDE_LSB     IO_PIO_IDE_LSB;
__sfr __at __IO_PIO_IDE_MSB     IO_PIO_IDE_MSB;
__sfr __at __IO_PIO_IDE_CTL     IO_PIO_IDE_CTL;
__sfr __at __IO_PIO_IDE_CONFIG  IO_PIO_IDE_CONFIG;

__sfr __at __IO_PROM_RESET      IO_PROM_RESET;
__sfr __at __IO_PROM_TOGGLE     IO_PROM_TOGGLE;

#endif

#endif

// SYSTEM FUNCTIONS


