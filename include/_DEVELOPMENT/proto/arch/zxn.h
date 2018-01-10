include(__link__.m4)

#ifndef __ARCH_ZXN_H__
#define __ARCH_ZXN_H__

#include <arch.h>

#include <stddef.h>
#include <rect.h>

///////////////////////////////////////////////////////////////

// common constants

#define INK_BLACK                   0x00
#define INK_BLUE                    0x01
#define INK_RED                     0x02
#define INK_MAGENTA                 0x03
#define INK_GREEN                   0x04
#define INK_CYAN                    0x05
#define INK_YELLOW                  0x06
#define INK_WHITE                   0x07

#define PAPER_BLACK                 0x00
#define PAPER_BLUE                  0x08
#define PAPER_RED                   0x10
#define PAPER_MAGENTA               0x18
#define PAPER_GREEN                 0x20
#define PAPER_CYAN                  0x28
#define PAPER_YELLOW                0x30
#define PAPER_WHITE                 0x38

#define BRIGHT                      0x40
#define FLASH                       0x80

///////////////////////////////////////////////////////////////

// global variables - same port numbers are aliases

extern unsigned char GLOBAL_ZX_PORT_FE;
extern unsigned char GLOBAL_ZX_PORT_1FFD;
extern unsigned char GLOBAL_ZX_PORT_7FFD;

extern unsigned char GLOBAL_TS_PORT_FE;

extern unsigned char GLOBAL_ZXN_PORT_FE;
extern unsigned char GLOBAL_ZXN_PORT_1FFD;
extern unsigned char GLOBAL_ZXN_PORT_7FFD;
extern unsigned char GLOBAL_ZXN_PORT_DFFD;

#ifdef __ESXDOS_DOT_COMMAND

// DOTX and DOTN commands only
// details about the second binary file

extern unsigned char DOT_FILENAME[18];
extern unsigned int  DOT_BINLEN;

// DOTN commands only
// always DOTN[DOTN_PAGE_NUM] = 255

extern unsigned char DOTN_PAGE[];
extern unsigned char DOTN_PAGE_NUM;

#endif

///////////////////////////////////////////////////////////////

#ifdef __CLANG

extern unsigned char IO_FE;
extern unsigned char IO_FF;
extern unsigned char IO_TIMEX_VIDEO_MODE;
extern unsigned char IO_1FFD;
extern unsigned char IO_7FFD;
extern unsigned char IO_DFFD;
extern unsigned char IO_0F;
extern unsigned char IO_DAC_L0;
extern unsigned char IO_1F;
extern unsigned char IO_DAC_L1;
extern unsigned char IO_4F;
extern unsigned char IO_DAC_R0;
extern unsigned char IO_5F;
extern unsigned char IO_DAC_R1;
extern unsigned char IO_2D;
extern unsigned char IO_DAC_M0;
extern unsigned char IO_FFFD;
extern unsigned char IO_TURBOSOUND;
extern unsigned char IO_AY_REG;
extern unsigned char IO_BFFD;
extern unsigned char IO_AY_DAT;
extern unsigned char IO_123B;
extern unsigned char IO_LAYER_2_CONFIG;
extern unsigned char IO_303B;
extern unsigned char IO_SPRITE_SLOT;
extern unsigned char IO_SPRITE_FLAGS;
extern unsigned char IO_53;
extern unsigned char IO_SPRITE_PALETTE;
extern unsigned char IO_57;
extern unsigned char IO_SPRITE_ATTRIBUTE;
extern unsigned char IO_5B;
extern unsigned char IO_SPRITE_PATTERN;
extern unsigned char IO_143B;
extern unsigned char IO_UART_RX;
extern unsigned char IO_UART_BAUD_RATE;
extern unsigned char IO_133B;
extern unsigned char IO_UART_TX;
extern unsigned char IO_UART_STATUS;

#else

// io ports - spectrum & timex

__sfr __at 0xfe IO_FE;

__sfr __at 0xff IO_FF;
__sfr __at __IO_TIMEX_VIDEO_MODE IO_TIMEX_VIDEO_MODE;

__sfr __banked __at 0x1ffd IO_1FFD;
__sfr __banked __at 0x7ffd IO_7FFD;
__sfr __banked __at 0xdffd IO_DFFD;

// io ports - dac

__sfr __at 0x0f IO_0F;
__sfr __at __IO_DAC_L0 IO_DAC_L0;

__sfr __at 0x1f IO_1F;
__sfr __at __IO_DAC_L1 IO_DAC_L1;

__sfr __at 0x4f IO_4F;
__sfr __at __IO_DAC_R0 IO_DAC_R0;

__sfr __at 0x5f IO_5F;
__sfr __at __IO_DAC_R1 IO_DAC_R1;

__sfr __at 0xdf IO_DF;
__sfr __at __IO_DAC_M0 IO_DAC_M0;  // writes to L0 and R0

// io ports - ay-3-8912

__sfr __banked __at 0xfffd IO_FFFD;
__sfr __banked __at __IO_TURBOSOUND IO_TURBOSOUND;
__sfr __banked __at __IO_AY_REG IO_AY_REG;

__sfr __banked __at 0xbffd IO_BFFD;
__sfr __banked __at __IO_AY_DAT IO_AY_DAT;

// io ports - layer 2

__sfr __banked __at 0x123b IO_123B;
__sfr __banked __at __IO_LAYER_2_CONFIG IO_LAYER_2_CONFIG;

// io ports - sprites

__sfr __banked __at 0x303b IO_303B;
__sfr __banked __at __IO_SPRITE_SLOT IO_SPRITE_SLOT;
__sfr __banked __at __IO_SPRITE_FLAGS IO_SPRITE_FLAGS;

__sfr __at 0x53 IO_53;
__sfr __at __IO_SPRITE_PALETTE IO_SPRITE_PALETTE;

__sfr __at 0x57 IO_57;
__sfr __at __IO_SPRITE_ATTRIBUTE IO_SPRITE_ATTRIBUTE;

__sfr __at 0x5b IO_5B;
__sfr __at __IO_SPRITE_PATTERN IO_SPRITE_PATTERN;

// io ports - uart

__sfr __banked __at 0x143b IO_143B;
__sfr __banked __at __IO_UART_RX IO_UART_RX;
__sfr __banked __at __IO_UART_BAUD_RATE IO_UART_BAUD_RATE;

__sfr __banked __at 0x133b IO_133B;
__sfr __banked __at __IO_UART_TX IO_UART_TX;
__sfr __banked __at __IO_UART_STATUS IO_UART_STATUS;

#endif

// io port bits

// 0xfe, IO_FE

#define IO_FE_EAR  __IO_FE_EAR
#define IO_FE_MIC  __IO_FE_MIC
#define IO_FE_BORDER_MASK  __IO_FE_BORDER_MASK

// 0xff, IO_TIMEX_VIDEO_MODE

#define IO_TVM_DISABLE_ULA_INTERRUPT  __IO_TVM_DISABLE_ULA_INTERRUPT
#define IO_TVM_DFILE_1  __IO_TVM_DFILE_1
#define IO_TVM_DFILE_2  __IO_TVM_DFILE_2
#define IO_TVM_HICOLOR  __IO_TVM_HICOLOR
#define IO_TVM_HIRES  __IO_TVM_HIRES
#define IO_TVM_HIRES_BLACK  __IO_TVM_HIRES_BLACK
#define IO_TVM_HIRES_BLUE  __IO_TVM_HIRES_BLUE
#define IO_TVM_HIRES_RED  __IO_TVM_HIRES_RED
#define IO_TVM_HIRES_MAGENTA  __IO_TVM_HIRES_MAGENTA
#define IO_TVM_HIRES_GREEN  __IO_TVM_HIRES_GREEN
#define IO_TVM_HIRES_CYAN  __IO_TVM_HIRES_CYAN
#define IO_TVM_HIRES_YELLOW  __IO_TVM_HIRES_YELLOW
#define IO_TVM_HIRES_WHITE  __IO_TVM_HIRES_WHITE

// 0x7ffd, IO_7FFD

#define IO_7FFD_LOCK  __IO_7FFD_LOCK
#define IO_7FFD_ROM0  __IO_7FFD_ROM0
#define IO_7FFD_ALT_DFILE  __IO_7FFD_ALT_DFILE
#define IO_7FFD_RAM_PAGE_MASK  __IO_7FFD_RAM_PAGE_MASK

// 0xdffd, IO_DFFD

#define IO_DFFD_RAM_PAGE_MASK  __IO_DFFD_RAM_PAGE_MASK

// 0x1ffd, IO_1FFD

#define IO_1FFD_PAGING_MODE_NORMAL  __IO_1FFD_PAGING_MODE_NORMAL
#define IO_1FFD_PAGING_MODE_SPECIAL  __IO_1FFD_PAGING_MODE_SPECIAL
#define IO_1FFD_PAGING_MODE_SPECIAL_3210  __IO_1FFD_PAGING_MODE_SPECIAL_3210
#define IO_1FFD_PAGING_MODE_SPECIAL_7654  __IO_1FFD_PAGING_MODE_SPECIAL_7654
#define IO_1FFD_PAGING_MODE_SPECIAL_3654  __IO_1FFD_PAGING_MODE_SPECIAL_3654
#define IO_1FFD_PAGING_MODE_SPECIAL_3674  __IO_1FFD_PAGING_MODE_SPECIAL_3674
#define IO_1FFD_ROM1  __IO_1FFD_ROM1
#define IO_1FFD_DISK_MOTOR  __IO_1FFD_DISK_MOTOR
#define IO_1FFD_PRINTER_STROBE  __IO_1FFD_PRINTER_STROBE

// 0xfffd, IO_TURBOSOUND

#define IT_ENABLE_L  __IT_ENABLE_L
#define IT_ENABLE_R  __IT_ENABLE_R
#define IT_ENABLE_LR  __IT_ENABLE_LR
#define IT_SELECT_PSG_0  __IT_SELECT_PSG_0
#define IT_SELECT_PSG_1  __IT_SELECT_PSG_1
#define IT_SELECT_PSG_2  __IT_SELECT_PSG_2

// 0x123b, IO_LAYER_2_CONFIG

#define IL2C_ENABLE_LOWER_16K  __IL2C_ENABLE_LOWER_16K
#define IL2C_SHOW_LAYER_2  __IL2C_SHOW_LAYER_2
#define IL2C_SELECT_SHADOW_BUFFER  __IL2C_SELECT_SHADOW_BUFFER
#define IL2C_BANK_SELECT_MASK  __IL2C_BANK_SELECT_MASK
#define IL2C_BANK_SELECT_0  __IL2C_BANK_SELECT_0
#define IL2C_BANK_SELECT_1  __IL2C_BANK_SELECT_1
#define IL2C_BANK_SELECT_2  __IL2C_BANK_SELECT_2

// 0x303b, IO_SPRITE_FLAGS

#define ISF_MAX_SPRITES_PER_LINE  __ISF_MAX_SPRITES_PER_LINE
#define ISF_COLLISION  __ISF_COLLISION

// 0x143b, IO_UART_BAUD_RATE

#define IUBR_115200  __IUBR_115200
#define IUBR_57600  __IUBR_57600
#define IUBR_38400  __IUBR_38400
#define IUBR_31250  __IUBR_31250
#define IUBR_19200  __IUBR_19200
#define IUBR_9600  __IUBR_9600
#define IUBR_4800  __IUBR_4800
#define IUBR_2400  __IUBR_2400

// 0x133b, IO_UART_STATUS

#define IUS_RX_AVAIL  __IUS_RX_AVAIL
#define IUS_TX_READY  __IUS_TX_READY

///////////////////////////////////////////////////////////////

// tbblue registry system

__sfr __banked __at 0x243b IO_243B;
__sfr __banked __at __IO_NEXTREG_REG IO_NEXTREG_REG;

__sfr __banked __at 0x253b IO_253B;
__sfr __banked __at __IO_NEXTREG_DAT IO_NEXTREG_DAT;

// zx next registry

#define REG_MACHINE_ID  __REG_MACHINE_ID

#define REG_VERSION  __REG_VERSION
#define RV_MAJOR  __RV_MAJOR
#define RV_MINOR  __RV_MINOR

#define REG_RESET  __REG_RESET
#define RR_POWER_ON_RESET  __RR_POWER_ON_RESET
#define RR_HARD_RESET  __RR_HARD_RESET
#define RR_SOFT_RESET  __RR_SOFT_RESET

#define REG_MACHINE_TYPE  __REG_MACHINE_TYPE
#define RMT_LOCK_TIMING  __RMT_LOCK_TIMING
#define RMT_TIMING_48  __RMT_TIMING_48
#define RMT_TIMING_128  __RMT_TIMING_128
#define RMT_TIMING_P3E  __RMT_TIMING_P3E
#define RMT_TIMING_PENTAGON  __RMT_TIMING_PENTAGON
#define RMT_CONFIG_MODE  __RMT_CONFIG_MODE
#define RMT_48  __RMT_48
#define RMT_128  __RMT_128
#define RMT_P3E  __RMT_P3E
#define RMT_PENTAGON  __RMT_PENTAGON

#define REG_PAGE_RAM  __REG_PAGE_RAM
#define RPR_MASK  __RPR_MASK
// preferred name is bank for 16k banks
#define REG_BANK_RAM  __REG_BANK_RAM
#define RBR_MASK  __RBR_MASK

#define REG_PERIPHERAL_1  __REG_PERIPHERAL_1
#define RP1_JOY1_SINCLAIR  __RP1_JOY1_SINCLAIR
#define RP1_JOY1_KEMPSTON  __RP1_JOY1_KEMPSTON
#define RP1_JOY1_CURSOR  __RP1_JOY1_CURSOR
#define RP1_JOY2_SINCLAIR  __RP1_JOY2_SINCLAIR
#define RP1_JOY2_KEMPSTON  __RP1_JOY2_KEMPSTON
#define RP1_JOY2_CURSOR  __RP1_JOY2_CURSOR
#define RP1_RATE_50  __RP1_RATE_50
#define RP1_RATE_60  __RP1_RATE_60
#define RP1_ENABLE_SCANLINES  __RP1_ENABLE_SCANLINES
#define RP1_ENABLE_SCANDOUBLER  __RP1_ENABLE_SCANDOUBLER

#define REG_PERIPHERAL_2  __REG_PERIPHERAL_2
#define RP2_ENABLE_TURBO  __RP2_ENABLE_TURBO
#define RP2_DAC_I2S  __RP2_DAC_I2S
#define RP2_DAC_JAP  __RP2_DAC_JAP
#define RP2_ENABLE_LIGHTPEN  __RP2_ENABLE_LIGHTPEN
#define RP2_ENABLE_DIVMMC  __RP2_ENABLE_DIVMMC
#define RP2_ENABLE_MULTIFACE  __RP2_ENABLE_MULTIFACE
#define RP2_PS2_KEYBOARD  __RP2_PS2_KEYBOARD
#define RP2_PS2_MOUSE  __RP2_PS2_MOUSE
#define RP2_PSGMODE_AY  __RP2_PSGMODE_AY
#define RP2_PSGMODE_YM  __RP2_PSGMODE_YM
#define RP2_PSGMODE_DISABLE  __RP2_PSGMODE_DISABLE

#define REG_TURBO_MODE  __REG_TURBO_MODE
#define RTM_3MHZ  __RTM_3MHZ
#define RTM_7MHZ  __RTM_7MHZ
#define RTM_14MHZ  __RTM_14MHZ
#define RTM_28MHZ  __RTM_28MHZ

#define REG_PERIPHERAL_3  __REG_PERIPHERAL_3
#define RP3_STEREO_ABC  __RP3_STEREO_ABC
#define RP3_STEREO_ACB  __RP3_STEREO_ACB
#define RP3_ENABLE_SPEAKER  __RP3_ENABLE_SPEAKER
#define RP3_ENABLE_SPECDRUM  __RP3_ENABLE_SPECDRUM
#define RP3_ENABLE_COVOX  __RP3_ENABLE_COVOX
#define RP3_ENABLE_TIMEX  __RP3_ENABLE_TIMEX
#define RP3_ENABLE_TURBOSOUND  __RP3_ENABLE_TURBOSOUND
#define RP3_UNLOCK_7FFD  __RP3_UNLOCK_7FFD

#define REG_ANTI_BRICK  __REG_ANTI_BRICK
#define RAB_START_NORMAL_CORE  __RAB_START_NORMAL_CORE
#define RAB_BUTTON_DIVMMC  __RAB_BUTTON_DIVMMC
#define RAB_BUTTON_MULTIFACE  __RAB_BUTTON_MULTIFACE

#define REG_LAYER_2_RAM_PAGE  __REG_LAYER_2_RAM_PAGE
#define RL2RP_MASK  __RL2RP_MASK
// preferred name is bank for 16k banks
#define REG_LAYER_2_RAM_BANK  __REG_LAYER_2_RAM_BANK
#define RL2RB_MASK  __RL2RB_MASK

#define REG_LAYER_2_SHADOW_RAM_PAGE  __REG_LAYER_2_SHADOW_RAM_PAGE
#define RL2SRP_MASK  __RL2SRP_MASK
// preferred name is bank for 16k banks
#define REG_LAYER_2_SHADOW_RAM_BANK  __REG_LAYER_2_SHADOW_RAM_BANK
#define RL2SRB_MASK  __RL2SRB_MASK

#define REG_GLOBAL_TRANSPARENCY_COLOR  __REG_GLOBAL_TRANSPARENCY_COLOR

#define REG_SPRITE_LAYER_SYSTEM  __REG_SPRITE_LAYER_SYSTEM
#define RSLS_ENABLE_LORES  __RSLS_ENABLE_LORES
#define RSLS_LAYER_PRIORITY_SLU  __RSLS_LAYER_PRIORITY_SLU
#define RSLS_LAYER_PRIORITY_LSU  __RSLS_LAYER_PRIORITY_LSU
#define RSLS_LAYER_PRIORITY_SUL  __RSLS_LAYER_PRIORITY_SUL
#define RSLS_LAYER_PRIORITY_LUS  __RSLS_LAYER_PRIORITY_LUS
#define RSLS_LAYER_PRIORITY_USL  __RSLS_LAYER_PRIORITY_USL
#define RSLS_LAYER_PRIORITY_ULS  __RSLS_LAYER_PRIORITY_ULS
#define RSLS_SPRITES_OVER_BORDER  __RSLS_SPRITES_OVER_BORDER
#define RSLS_SPRITES_VISIBLE  __RSLS_SPRITES_VISIBLE

#define REG_LAYER_2_OFFSET_X  __REG_LAYER_2_OFFSET_X

#define REG_LAYER_2_OFFSET_Y  __REG_LAYER_2_OFFSET_Y

#define REG_CLIP_WINDOW_LAYER_2  __REG_CLIP_WINDOW_LAYER_2

#define REG_CLIP_WINDOW_SPRITES  __REG_CLIP_WINDOW_SPRITES

#define REG_CLIP_WINDOW_ULA  __REG_CLIP_WINDOW_ULA

#define REG_CLIP_WINDOW_CONTROL  __REG_CLIP_WINDOW_CONTROL
#define RCWC_RESET_ULA_CLIP_INDEX  __RCWC_RESET_ULA_CLIP_INDEX
#define RCWC_RESET_SPRITE_CLIP_INDEX  __RCWC_RESET_SPRITE_CLIP_INDEX
#define RCWC_RESET_LAYER_2_CLIP_INDEX  __RCWC_RESET_LAYER_2_CLIP_INDEX

#define REG_ACTIVE_VIDEO_LINE_MSB  __REG_ACTIVE_VIDEO_LINE_MSB

#define REG_ACTIVE_VIDEO_LINE_LSB  __REG_ACTIVE_VIDEO_LINE_LSB

#define REG_LINE_INTERRUPT_CONTROL  __REG_LINE_INTERRUPT_CONTROL
#define RLIC_INTERRUPT_FLAG  __RLIC_INTERRUPT_FLAG
#define RLIC_DISABLE_ULA_INTERRUPT  __RLIC_DISABLE_ULA_INTERRUPT
#define RLIC_ENABLE_LINE_INTERRUPT  __RLIC_ENABLE_LINE_INTERRUPT
#define RLIC_LINE_INTERRUPT_VALUE_MSB  __RLIC_LINE_INTERRUPT_VALUE_MSB

#define REG_LINE_INTERRUPT_VALUE_LSB  __REG_LINE_INTERRUPT_VALUE_LSB

#define REG_KEYMAP_ADDRESS_MSB  __REG_KEYMAP_ADDRESS_MSB

#define REG_KEYMAP_ADDRESS_LSB  __REG_KEYMAP_ADDRESS_LSB

#define REG_KEYMAP_DATA_MSB  __REG_KEYMAP_DATA_MSB

#define REG_KEYMAP_DATA_LSB  __REG_KEYMAP_DATA_LSB

#define REG_AUDIO_MONO_DAC  __REG_AUDIO_MONO_DAC

#define REG_LORES_OFFSET_X  __REG_LORES_OFFSET_X

#define REG_LORES_OFFSET_Y  __REG_LORES_OFFSET_Y

#define REG_PALETTE_INDEX  __REG_PALETTE_INDEX

#define REG_PALETTE_VALUE_8  __REG_PALETTE_VALUE_8

#define REG_ULA_PALETTE_FORMAT  __REG_ULA_PALETTE_FORMAT

#define REG_PALETTE_CONTROL  __REG_PALETTE_CONTROL
#define RPC_SELECT_ULA_PALETTE_0  __RPC_SELECT_ULA_PALETTE_0
#define RPC_SELECT_ULA_PALETTE_1  __RPC_SELECT_ULA_PALETTE_1
#define RPC_SELECT_LAYER_2_PALETTE_0  __RPC_SELECT_LAYER_2_PALETTE_0
#define RPC_SELECT_LAYER_2_PALETTE_1  __RPC_SELECT_LAYER_2_PALETTE_1
#define RPC_SELECT_SPRITES_PALETTE_0  __RPC_SELECT_SPRITES_PALETTE_0
#define RPC_SELECT_SPRITES_PALETTE_1  __RPC_SELECT_SPRITES_PALETTE_1
#define RPC_ENABLE_SPRITES_PALETTE_0  __RPC_ENABLE_SPRITES_PALETTE_0
#define RPC_ENABLE_SPRITES_PALETTE_1  __RPC_ENABLE_SPRITES_PALETTE_1
#define RPC_ENABLE_LAYER_2_PALETTE_0  __RPC_ENABLE_LAYER_2_PALETTE_0
#define RPC_ENABLE_LAYER_2_PALETTE_1  __RPC_ENABLE_LAYER_2_PALETTE_1
#define RPC_ENABLE_ULA_PALETTE_0  __RPC_ENABLE_ULA_PALETTE_0
#define RPC_ENABLE_ULA_PALETTE_1  __RPC_ENABLE_ULA_PALETTE_1
#define RPC_ENABLE_ULANEXT  __RPC_ENABLE_ULANEXT

#define REG_PALETTE_VALUE_16  __REG_PALETTE_VALUE_16

#define REG_MMU0  __REG_MMU0
#define REG_MMU1  __REG_MMU1
#define REG_MMU2  __REG_MMU2
#define REG_MMU3  __REG_MMU3
#define REG_MMU4  __REG_MMU4
#define REG_MMU5  __REG_MMU5
#define REG_MMU6  __REG_MMU6
#define REG_MMU7  __REG_MMU7

#define REG_COPPER_DATA  __REG_COPPER_DATA

#define REG_COPPER_CONTROL_LO  __REG_COPPER_CONTROL_LO

#define REG_COPPER_CONTROL_HI  __REG_COPPER_CONTROL_HI
#define RCCH_COPPER_STOP  __RCCH_COPPER_STOP
#define RCCH_COPPER_RUN_ONCE  __RCCH_COPPER_RUN_ONCE
#define RCCH_COPPER_RUN_LOOP  __RCCH_COPPER_RUN_LOOP
#define RCCH_COPPER_RUN_ON_INTERRUPT  __RCCH_COPPER_RUN_ON_INTERRUPT

///////////////////////////////////////////////////////////////

// zx next configuration

#ifdef __CLANG
#define ZXN_NEXTREG(reg,data) ((void)ZXN_NEXTREG_##reg##_##data())
#endif

#ifdef __SDCC
#define ZXN_NEXTREG(reg,data) { extern void ZXN_NEXTREG_##reg##_##data(void) __preserves_regs(d,e,h,l,iyl,iyh); ZXN_NEXTREG_##reg##_##data(); }
#endif

#ifdef __SCCZ80
#define ZXN_NEXTREG(reg,data) { extern void ZXN_NEXTREG_##reg##_##data(void); ZXN_NEXTREG_##reg##_##data(); }
#endif

__DPROTO(`a,d,e,h,iyl,iyh',`a,d,e,h,iyl,iyh',unsigned char,,ZXN_READ_REG,unsigned char reg)
__DPROTO(`a,d,e,iyl,iyh',`a,d,e,iyl,iyh',void,,ZXN_WRITE_REG,unsigned char reg, unsigned char data)

// zx next memory map

__OPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',unsigned char,,ZXN_READ_MMU0,void)
__OPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',unsigned char,,ZXN_READ_MMU1,void)
__OPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',unsigned char,,ZXN_READ_MMU2,void)
__OPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',unsigned char,,ZXN_READ_MMU3,void)
__OPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',unsigned char,,ZXN_READ_MMU4,void)
__OPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',unsigned char,,ZXN_READ_MMU5,void)
__OPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',unsigned char,,ZXN_READ_MMU6,void)
__OPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',unsigned char,,ZXN_READ_MMU7,void)

__DPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',void,,ZXN_WRITE_MMU0,unsigned char page)
__DPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',void,,ZXN_WRITE_MMU1,unsigned char page)
__DPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',void,,ZXN_WRITE_MMU2,unsigned char page)
__DPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',void,,ZXN_WRITE_MMU3,unsigned char page)
__DPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',void,,ZXN_WRITE_MMU4,unsigned char page)
__DPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',void,,ZXN_WRITE_MMU5,unsigned char page)
__DPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',void,,ZXN_WRITE_MMU6,unsigned char page)
__DPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',void,,ZXN_WRITE_MMU7,unsigned char page)

// miscellaneous - paging and banking state

__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned int,,zxn_addr_from_mmu,unsigned char mmu)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,zxn_mmu_from_addr,unsigned int addr)

__DPROTO(`b,c,iyl,iyh',`b,c,iyl,iyh',unsigned long,,zxn_addr_from_page,unsigned char page)
__DPROTO(`b,c,iyl,iyh',`b,c,iyl,iyh',unsigned long,,zxn_addr_from_page_2mb,unsigned char page)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,iyl,iyh',unsigned char,,zxn_page_from_addr,unsigned long addr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,iyl,iyh',unsigned char,,zxn_page_from_addr_2mb,unsigned long addr)

__DPROTO(`a,iyl,iyh',`iyl,iyh',void,,zxn_read_mmu_state,void *dst)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,zxn_write_mmu_state,void *src)

__DPROTO(`d,e,h,l,iyl,iyh',`d,e,iyl,iyh',void,,zxn_write_bank_state,unsigned int state)
__OPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned int,,zxn_read_sysvar_bank_state,void)
__DPROTO(`b,c,d,e,h,l,iyl,iyh',`b,c,d,e,iyl,iyh',void,,zxn_write_sysvar_bank_state,unsigned int state)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned int,,zxn_mangle_bank_state,unsigned int state)

///////////////////////////////////////////////////////////////

// tape i/o

struct zxtapehdr
{
	unsigned char hdtype;      // 0 = program, 1 = num array, 2 = char array, 3 = code/binary
	unsigned char hdname[10];  // space padded
	unsigned int  hdlen;       // ELINE - PROG, length field, length field, length in bytes
	unsigned int  hdadd;       // starting line number 0x8000 = none, lsb=0 msb=id, lsb=0 msb=id, address
	unsigned int  hdvars;      // VARS - PROG, 0, 0, 0
};

#define ZXT_TYPE_HEADER  0
#define ZXT_TYPE_DATA    0xff

__DPROTO(`iyl,iyh',`iyl,iyh',unsigned int,,zx_tape_load_block,void *dst,unsigned int len,unsigned char type)
__DPROTO(`iyl,iyh',`iyl,iyh',unsigned int,,zx_tape_save_block,void *src,unsigned int len,unsigned char type)
__DPROTO(`iyl,iyh',`iyl,iyh',unsigned int,,zx_tape_verify_block,void *dst,unsigned int len,unsigned char type)

// timex video mode

#define TVM_SPECTRUM   __IO_TVM_DFILE_1       // 256x192 pix, 32x24 attr
#define TVM_HICOLOR    __IO_TVM_HICOLOR       // 256x192 pix, 32x192 attr
#define TVM_HIRES      __IO_TVM_HIRES         // 512x192 pix or with paper colour

__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',void,,ts_vmod,unsigned char mode)

// miscellaneous - spectrum display

__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',void,,zx_border,unsigned char colour)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,zx_cls,unsigned char attr)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,zx_cls_attr,unsigned char attr)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,zx_cls_pix,unsigned char pix)
__DPROTO(,,void,,zx_cls_wc,struct r_Rect8 *r,unsigned char attr)
__DPROTO(,,void,,zx_cls_wc_attr,struct r_Rect8 *r,unsigned char attr)
__DPROTO(,,void,,zx_cls_wc_pix,struct r_Rect8 *r,unsigned char pix)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,zx_scroll_up,unsigned char rows,unsigned char attr)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,zx_scroll_up_attr,unsigned char rows,unsigned char attr)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,zx_scroll_up_pix,unsigned char rows,unsigned char pix)
__DPROTO(,,void,,zx_scroll_wc_up,struct r_Rect8 *r,unsigned char rows,unsigned char attr)
__DPROTO(,,void,,zx_scroll_wc_up_attr,struct r_Rect8 *r,unsigned char rows,unsigned char attr)
__DPROTO(,,void,,zx_scroll_wc_up_pix,struct r_Rect8 *r,unsigned char rows,unsigned char pix)

#ifdef __CLANG

__DPROTO(,,void,,zx_visit_wc_attr,struct r_Rect8 *r,`void (*visit)(unsigned char *)')
__DPROTO(,,void,,zx_visit_wc_pix,struct r_Rect8 *r,`void (*visit)(unsigned char *)')

#endif

#ifdef __SDCC

__DPROTO(,,void,,zx_visit_wc_attr,struct r_Rect8 *r,`void (*visit)(unsigned char *)')
__DPROTO(,,void,,zx_visit_wc_pix,struct r_Rect8 *r,`void (*visit)(unsigned char *)')

#endif

#ifdef __SCCZ80

__DPROTO(,,void,,zx_visit_wc_attr,struct r_Rect8 *r,void *visit)
__DPROTO(,,void,,zx_visit_wc_pix,struct r_Rect8 *r,void *visit)

#endif

// miscellaneous - timex hi-colour display

__DPROTO(`iyl,iyh',`iyl,iyh',void,,tshc_cls,unsigned char attr)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,tshc_cls_attr,unsigned char attr)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,tshc_cls_pix,unsigned char pix)
__DPROTO(,,void,,tshc_cls_wc,struct r_Rect8 *r,unsigned char attr)
__DPROTO(,,void,,tshc_cls_wc_attr,struct r_Rect8 *r,unsigned char attr)
__DPROTO(,,void,,tshc_cls_wc_pix,struct r_Rect8 *r,unsigned char pix)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,tshc_scroll_up,unsigned char rows,unsigned char attr)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,tshc_scroll_up_attr,unsigned char rows,unsigned char attr)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,tshc_scroll_up_pix,unsigned char rows,unsigned char pix)
__DPROTO(,,void,,tshc_scroll_wc_up,struct r_Rect8 *r,unsigned char rows,unsigned char attr)
__DPROTO(,,void,,tshc_scroll_wc_up_attr,struct r_Rect8 *r,unsigned char rows,unsigned char attr)
__DPROTO(,,void,,tshc_scroll_wc_up_pix,struct r_Rect8 *r,unsigned char rows,unsigned char pix)

#ifdef __CLANG

__DPROTO(,,void,,tshc_visit_wc_attr,struct r_Rect8 *r,`void (*visit)(unsigned char *)')
__DPROTO(,,void,,tshc_visit_wc_pix,struct r_Rect8 *r,`void (*visit)(unsigned char *)')

#endif

#ifdef __SDCC

__DPROTO(,,void,,tshc_visit_wc_attr,struct r_Rect8 *r,`void (*visit)(unsigned char *)')
__DPROTO(,,void,,tshc_visit_wc_pix,struct r_Rect8 *r,`void (*visit)(unsigned char *)')

#endif

#ifdef __SCCZ80

__DPROTO(,,void,,tshc_visit_wc_attr,struct r_Rect8 *r,void *visit)
__DPROTO(,,void,,tshc_visit_wc_pix,struct r_Rect8 *r,void *visit)

#endif

// miscellaneous - timex hi-res display

__DPROTO(`iyl,iyh',`iyl,iyh',void,,tshr_cls,unsigned char attr)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,tshr_cls_attr,unsigned char attr)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,tshr_cls_pix,unsigned char pix)
__DPROTO(,,void,,tshr_cls_wc_pix,struct r_Rect8 *r,unsigned char pix)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,tshr_scroll_up,unsigned char rows,unsigned char attr)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,tshr_scroll_up_pix,unsigned char rows,unsigned char pix)
__DPROTO(,,void,,tshr_scroll_wc_up_pix,struct r_Rect8 *r,unsigned char rows,unsigned char pix)

#ifdef __CLANG

__DPROTO(,,void,,tshr_visit_wc_pix,struct r_Rect8 *r,`void (*visit)(unsigned char *)')

#endif

#ifdef __SDCC

__DPROTO(,,void,,tshr_visit_wc_pix,struct r_Rect8 *r,`void (*visit)(unsigned char *)')

#endif

#ifdef __SCCZ80

__DPROTO(,,void,,tshr_visit_wc_pix,struct r_Rect8 *r,void *visit)

#endif

// display

// In the following, screen address refers to a pixel address within the display file while
// attribute address refers to the attributes area.
//
// Function names are constructed from the following atoms:
//
// saddr = screen address
// aaddr = attribute address
// 
// px    = pixel x coordinate (0..255)
// py    = pixel y coordinate (0..191)
// pxy   = pixel (x,y) coordinate
//
// cx    = character x coordinate (0..31)
// cy    = character y coordinate (0..23)
// cxy   = character (x,y) coordinate
//
// So for example:
//
// zx_saddr2cy(saddr) will return the character y coordinate corresponding to the given screen address
// zx_saddr2aaddr(saddr) will return the attribute address corresponding to the given screen address
// zx_pxy2aaddr(px,py) will return the attribute address corresponding to the given (x,y) pixel coordinate
//
// Some functions will return with carry flag set if coordinates or addresses move out of
// bounds.  In these cases the special z88dk keywords iferror() and ifnerror() can be used
// to test the carry flag and determine if invalid results are returned.  Check with the
// wiki documentation or the asm source files to see which functions support this.  If
// comments in the asm source file do not mention this, it is not supported.

__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,zx_aaddr2cx,void *aaddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,zx_aaddr2cy,void *aaddr)
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,zx_aaddr2px,void *aaddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,zx_aaddr2py,void *aaddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_aaddr2saddr,void *aaddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_aaddrcdown,void *aaddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_aaddrcleft,void *aaddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_aaddrcright,void *aaddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_aaddrcup,void *aaddr)
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,zx_bitmask2px,unsigned char bitmask)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_cxy2aaddr,unsigned char x,unsigned char y)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_cxy2saddr,unsigned char x,unsigned char y)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_cy2aaddr,unsigned char y)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_cy2saddr,unsigned char y)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,zx_px2bitmask,unsigned char x)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_pxy2aaddr,unsigned char x,unsigned char y)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_pxy2saddr,unsigned char x,unsigned char y)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_py2aaddr,unsigned char y)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_py2saddr,unsigned char y)
__DPROTO(`b,c,d,e,l,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_saddr2aaddr,void *saddr)
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,zx_saddr2cx,void *saddr)
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,zx_saddr2cy,void *saddr)
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,zx_saddr2px,void *saddr)
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,zx_saddr2py,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_saddrcdown,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_saddrcleft,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_saddrcright,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_saddrcup,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_saddrpdown,void *saddr)
__DPROTO(`b,c,iyl,iyh',`b,c,iyl,iyh',unsigned char,*,zx_saddrpleft,void *saddr,unsigned char bitmask)
__DPROTO(`b,c,iyl,iyh',`b,c,iyl,iyh',unsigned char,*,zx_saddrpright,void *saddr,unsigned char bitmask)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_saddrpup,void *saddr)

// Timex Hi-Colour Display 256x192 pixel 32x192 colour

__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,tshc_aaddr2cx,void *aaddr)
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,tshc_aaddr2cy,void *aaddr)
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,tshc_aaddr2px,void *aaddr)
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,tshc_aaddr2py,void *aaddr)
__DPROTO(`a,b,c,d,e,l,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_aaddr2saddr,void *aaddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_aaddrcdown,void *aaddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_aaddrcleft,void *aaddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_aaddrcright,void *aaddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_aaddrcup,void *aaddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_aaddrpdown,void *aaddr)
__DPROTO(`b,c,iyl,iyh',`b,c,iyl,iyh',unsigned char,*,tshc_aaddrpleft,void *aaddr,unsigned char bitmask)
__DPROTO(`b,c,iyl,iyh',`b,c,iyl,iyh',unsigned char,*,tshc_aaddrpright,void *aaddr,unsigned char bitmask)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_aaddrpup,void *aaddr)
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,tshc_bitmask2px,unsigned char bitmask)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_cxy2aaddr,unsigned char x,unsigned char y)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_cxy2saddr,unsigned char x,unsigned char y)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_cy2aaddr,unsigned char y)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_cy2saddr,unsigned char y)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,tshc_px2bitmask,unsigned char x)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_pxy2aaddr,unsigned char x,unsigned char y)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_pxy2saddr,unsigned char x,unsigned char y)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_py2aaddr,unsigned char y)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_py2saddr,unsigned char y)
__DPROTO(`a,b,c,d,e,l,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_saddr2aaddr,void *saddr)
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,tshc_saddr2cx,void *saddr)
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,tshc_saddr2cy,void *saddr)
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,tshc_saddr2px,void *saddr)
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,tshc_saddr2py,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_saddrcdown,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_saddrcleft,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_saddrcright,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_saddrcup,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_saddrpdown,void *saddr)
__DPROTO(`b,c,iyl,iyh',`b,c,iyl,iyh',unsigned char,*,tshc_saddrpleft,void *saddr,unsigned char bitmask)
__DPROTO(`b,c,iyl,iyh',`b,c,iyl,iyh',unsigned char,*,tshc_saddrpright,void *saddr,unsigned char bitmask)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshc_saddrpup,void *saddr)

// Timex Hi-Res Display, 512x192 monochrome

__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,tshr_bitmask2px,unsigned char bitmask)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshr_cxy2saddr,unsigned char x,unsigned char y)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshr_cy2saddr,unsigned char y)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,tshr_px2bitmask,unsigned char x)
__DPROTO(`iyl,iyh',`iyl,iyh',unsigned char,*,tshr_pxy2saddr,unsigned int x,unsigned char y)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshr_py2saddr,unsigned char y)
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,tshr_saddr2cx,void *saddr)
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,tshr_saddr2cy,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned int,,tshr_saddr2px,void *saddr)
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,tshr_saddr2py,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshr_saddrcdown,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshr_saddrcleft,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshr_saddrcright,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshr_saddrcup,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshr_saddrpdown,void *saddr)
__DPROTO(`b,c,iyl,iyh',`b,c,iyl,iyh',unsigned char,*,tshr_saddrpleft,void *saddr,unsigned char bitmask)
__DPROTO(`b,c,iyl,iyh',`b,c,iyl,iyh',unsigned char,*,tshr_saddrpright,void *saddr,unsigned char bitmask)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,tshr_saddrpup,void *saddr)

// graphics

__DPROTO(,,int,,zx_pattern_fill,unsigned char x,unsigned char y,void *pattern,unsigned int depth)

#endif
