
#ifndef __AQPLUS_H
#define __AQPLUS_H

#include <stdint.h>
#include <arch/aquarius.h>

// Stat buffer returned by ESP32
struct aqplus_stat {
    uint16_t date;
    uint16_t time;
    uint8_t  attr;
    uint32_t size;
};


static __sfr __at 0xE0 IO_VCTRL;
static __sfr __at 0xE1 IO_VSCRX_L;
static __sfr __at 0xE2 IO_VSCRX_H;
static __sfr __at 0xE3 IO_VSCRY;
static __sfr __at 0xE4 IO_VSPRSEL;
static __sfr __at 0xE5 IO_VSPRX_L;
static __sfr __at 0xE6 IO_VSPRX_H;
static __sfr __at 0xE7 IO_VSPRY;
static __sfr __at 0xE8 IO_VSPRIDX;
static __sfr __at 0xE9 IO_VSPRATTR;
static __sfr __at 0xEA IO_VPALSEL;
static __sfr __at 0xEB IO_VPALDATA;
static __sfr __at 0xEC IO_VLINE;
static __sfr __at 0xED IO_VIRQLINE;
static __sfr __at 0xEE IO_IRQMASK;
static __sfr __at 0xEF IO_IRQSTAT;
static __sfr __at 0xF0 IO_BANK0;
static __sfr __at 0xF1 IO_BANK1;
static __sfr __at 0xF2 IO_BANK2;
static __sfr __at 0xF3 IO_BANK3;
static __sfr __at 0xF4 IO_ESPCTRL;
static __sfr __at 0xF5 IO_ESPDATA;
static __sfr __at 0xF8 IO_PSG2DATA;
static __sfr __at 0xF9 IO_PSG2ADDR;
static __sfr __at 0xFB IO_SYSCTRL;

#endif
