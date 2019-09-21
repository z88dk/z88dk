/** @file gb/hardware.h
    Defines that let the GB's hardware registers be accessed
    from C.  See the Pan doc for what to set them to.
*/
#ifndef _HARDWARE_H
#define _HARDWARE_H

#include <sys/types.h>
#include <sys/compiler.h>

#ifndef __SDCC
__sfr __at 0x00 P1_REG		; /* Joystick: 1.1.P15.P14.P13.P12.P11.P10 */
__sfr __at 0x01 SB_REG		; /* Serial IO data buffer */
__sfr __at 0x02 SC_REG		; /* Serial IO control register */
__sfr __at 0x04 DIV_REG		; /* Divider register */
__sfr __at 0x05 TIMA_REG		; /* Timer counter */
__sfr __at 0x06 TMA_REG		; /* Timer modulo */
__sfr __at 0x07 TAC_REG		; /* Timer control */
__sfr __at 0x0f IF_REG		; /* Interrupt flags: 0.0.0.JOY.SIO.TIM.LCD.VBL */
__sfr __at 0x10 NR10_REG		; /* Sound register */
__sfr __at 0x11 NR11_REG		; /* Sound register */
__sfr __at 0x12 NR12_REG		; /* Sound register */
__sfr __at 0x13 NR13_REG		; /* Sound register */
__sfr __at 0x14 NR14_REG		; /* Sound register */
__sfr __at 0x16 NR21_REG		; /* Sound register */
__sfr __at 0x17 NR22_REG		; /* Sound register */
__sfr __at 0x18 NR23_REG		; /* Sound register */
__sfr __at 0x19 NR24_REG		; /* Sound register */
__sfr __at 0x1a NR30_REG		; /* Sound register */
__sfr __at 0x1b NR31_REG		; /* Sound register */
__sfr __at 0x1c NR32_REG		; /* Sound register */
__sfr __at 0x1d NR33_REG		; /* Sound register */
__sfr __at 0x1e NR34_REG		; /* Sound register */
__sfr __at 0x20 NR41_REG		; /* Sound register */
__sfr __at 0x21 NR42_REG		; /* Sound register */
__sfr __at 0x22 NR43_REG		; /* Sound register */
__sfr __at 0x23 NR44_REG		; /* Sound register */
__sfr __at 0x25 NR50_REG		; /* Sound register */
__sfr __at 0x25 NR51_REG		; /* Sound register */
__sfr __at 0x26 NR52_REG		; /* Sound register */
__sfr __at 0x40 LCDC_REG		; /* LCD control */
__sfr __at 0x41 STAT_REG		; /* LCD status */
__sfr __at 0x42 SCY_REG		; /* Scroll Y */
__sfr __at 0x43 SCX_REG		; /* Scroll X */
__sfr __at 0x44 LY_REG		; /* LCDC Y-coordinate */
__sfr __at 0x45 LYC_REG		; /* LY compare */
__sfr __at 0x46 DMA_REG		; /* DMA transfer */
__sfr __at 0x47 BGP_REG		; /* BG palette data */
__sfr __at 0x48 OBP0_REG		; /* OBJ palette 0 data */
__sfr __at 0x49 OBP1_REG		; /* OBJ palette 1 data */
__sfr __at 0x4a WY_REG		; /* Window Y coordinate */
__sfr __at 0x4b WX_REG		; /* Window X coordinate */
__sfr __at 0x4d KEY1_REG		; /* CPU speed */
__sfr __at 0x4f VBK_REG		; /* VRAM bank */
__sfr __at 0x51 HDMA1_REG		; /* DMA control 1 */
__sfr __at 0x52 HDMA2_REG		; /* DMA control 2 */
__sfr __at 0x53 HDMA3_REG		; /* DMA control 3 */
__sfr __at 0x54 HDMA4_REG		; /* DMA control 4 */
__sfr __at 0x55 HDMA5_REG		; /* DMA control 5 */
__sfr __at 0x56 RP_REG		; /* IR port */
__sfr __at 0x68 BCPS_REG		; /* BG color palette specification */
__sfr __at 0x69 BCPD_REG		; /* BG color palette data */
__sfr __at 0x6a OCPS_REG		; /* OBJ color palette specification */
__sfr __at 0x6b OCPD_REG		; /* OBJ color palette data */
__sfr __at 0x70 SVBK_REG		; /* WRAM bank */
__sfr __at 0xff IE_REG		; /* Interrupt enable */

#else

#define __REG	volatile uint8_t *

#define P1_REG		(*(__REG)0xFF00)	/* Joystick: 1.1.P15.P14.P13.P12.P11.P10 */
#define SB_REG		(*(__REG)0xFF01)	/* Serial IO data buffer */
#define SC_REG		(*(__REG)0xFF02)	/* Serial IO control register */
#define DIV_REG		(*(__REG)0xFF04)	/* Divider register */
#define TIMA_REG	(*(__REG)0xFF05)	/* Timer counter */
#define TMA_REG		(*(__REG)0xFF06)	/* Timer modulo */
#define TAC_REG		(*(__REG)0xFF07)	/* Timer control */
#define IF_REG		(*(__REG)0xFF0F)	/* Interrupt flags: 0.0.0.JOY.SIO.TIM.LCD.VBL */
#define NR10_REG	(*(__REG)0xFF10)	/* Sound register */
#define NR11_REG	(*(__REG)0xFF11)	/* Sound register */
#define NR12_REG	(*(__REG)0xFF12)	/* Sound register */
#define NR13_REG	(*(__REG)0xFF13)	/* Sound register */
#define NR14_REG	(*(__REG)0xFF14)	/* Sound register */
#define NR21_REG	(*(__REG)0xFF16)	/* Sound register */
#define NR22_REG	(*(__REG)0xFF17)	/* Sound register */
#define NR23_REG	(*(__REG)0xFF18)	/* Sound register */
#define NR24_REG	(*(__REG)0xFF19)	/* Sound register */
#define NR30_REG	(*(__REG)0xFF1A)	/* Sound register */
#define NR31_REG	(*(__REG)0xFF1B)	/* Sound register */
#define NR32_REG	(*(__REG)0xFF1C)	/* Sound register */
#define NR33_REG	(*(__REG)0xFF1D)	/* Sound register */
#define NR34_REG	(*(__REG)0xFF1E)	/* Sound register */
#define NR41_REG	(*(__REG)0xFF20)	/* Sound register */
#define NR42_REG	(*(__REG)0xFF21)	/* Sound register */
#define NR43_REG	(*(__REG)0xFF22)	/* Sound register */
#define NR44_REG	(*(__REG)0xFF23)	/* Sound register */
#define NR50_REG	(*(__REG)0xFF24)	/* Sound register */
#define NR51_REG	(*(__REG)0xFF25)	/* Sound register */
#define NR52_REG	(*(__REG)0xFF26)	/* Sound register */
#define LCDC_REG	(*(__REG)0xFF40)	/* LCD control */
#define STAT_REG	(*(__REG)0xFF41)	/* LCD status */
#define SCY_REG		(*(__REG)0xFF42)	/* Scroll Y */
#define SCX_REG		(*(__REG)0xFF43)	/* Scroll X */
#define LY_REG		(*(__REG)0xFF44)	/* LCDC Y-coordinate */
#define LYC_REG		(*(__REG)0xFF45)	/* LY compare */
#define DMA_REG		(*(__REG)0xFF46)	/* DMA transfer */
#define BGP_REG		(*(__REG)0xFF47)	/* BG palette data */
#define OBP0_REG	(*(__REG)0xFF48)	/* OBJ palette 0 data */
#define OBP1_REG	(*(__REG)0xFF49)	/* OBJ palette 1 data */
#define WY_REG		(*(__REG)0xFF4A)	/* Window Y coordinate */
#define WX_REG		(*(__REG)0xFF4B)	/* Window X coordinate */
#define KEY1_REG	(*(__REG)0xFF4D)	/* CPU speed */
#define VBK_REG		(*(__REG)0xFF4F)	/* VRAM bank */
#define HDMA1_REG	(*(__REG)0xFF51)	/* DMA control 1 */
#define HDMA2_REG	(*(__REG)0xFF52)	/* DMA control 2 */
#define HDMA3_REG	(*(__REG)0xFF53)	/* DMA control 3 */
#define HDMA4_REG	(*(__REG)0xFF54)	/* DMA control 4 */
#define HDMA5_REG	(*(__REG)0xFF55)	/* DMA control 5 */
#define RP_REG		(*(__REG)0xFF56)	/* IR port */
#define BCPS_REG	(*(__REG)0xFF68)	/* BG color palette specification */
#define BCPD_REG	(*(__REG)0xFF69)	/* BG color palette data */
#define OCPS_REG	(*(__REG)0xFF6A)	/* OBJ color palette specification */
#define OCPD_REG	(*(__REG)0xFF6B)	/* OBJ color palette data */
#define SVBK_REG	(*(__REG)0xFF70)	/* WRAM bank */
#define IE_REG		(*(__REG)0xFFFF)	/* Interrupt enable */

#endif


#endif /* _HARDWARE_H */
