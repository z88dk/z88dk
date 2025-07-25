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
extern unsigned char IO_6B;
extern unsigned char IO_DMA;
extern unsigned char IO_E3;
extern unsigned char IO_DIVIDE_CONTROL;
extern unsigned char IO_E7;
extern unsigned char IO_SPI_CONTROL;
extern unsigned char IO_SPI_STATUS;
extern unsigned char IO_EB;
extern unsigned char IO_SPI_DATA;
extern unsigned char IO_103B;
extern unsigned char IO_I2C_SCL;
extern unsigned char IO_113B;
extern unsigned char IO_I2C_SDA;
extern unsigned char IO_LED_L;

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

// io ports - dma

__sfr __at 0x6b IO_6B;
__sfr __at __IO_DMA IO_DMA;

// io ports - divmmc memory

__sfr __at 0xe3 IO_E3;
__sfr __at __IO_DIVIDE_CONTROL IO_DIVIDE_CONTROL;

// io ports - spi interface (sd card, raspberry pi)

__sfr __at 0xe7 IO_E7;
__sfr __at __IO_SPI_CONTROL IO_SPI_CONTROL;
__sfr __at __IO_SPI_STATUS IO_SPI_STATUS;

__sfr __at 0xeb IO_EB;
__sfr __at __IO_SPI_DATA IO_SPI_DATA;

// io ports - i2c (real-time clock)

__sfr __banked __at 0x103b IO_103B;
__sfr __banked __at __IO_I2C_SCL IO_I2C_SCL;  // bit 0 w only

__sfr __banked __at 0x113b IO_113B;
__sfr __banked __at __IO_I2C_SDA IO_I2C_SDA;  // bit 0 r/w

// io ports - LED

// not implemented on zx next, needed by boot code for other hw
// mapped to same port as IO_I2C_SCL

__sfr __banked __at __IO_LED_L IO_LED_L;

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

#define IO_FF_DISABLE_ULA_INTERRUPT  __IO_FF_DISABLE_ULA_INTERRUPT
#define IO_FF_DFILE_1  __IO_FF_DFILE_1
#define IO_FF_DFILE_2  __IO_FF_DFILE_2
#define IO_FF_HICOLOR  __IO_FF_HICOLOR
#define IO_FF_HIRES  __IO_FF_HIRES
#define IO_FF_HIRES_BLACK  __IO_FF_HIRES_BLACK
#define IO_FF_HIRES_BLUE  __IO_FF_HIRES_BLUE
#define IO_FF_HIRES_RED  __IO_FF_HIRES_RED
#define IO_FF_HIRES_MAGENTA  __IO_FF_HIRES_MAGENTA
#define IO_FF_HIRES_GREEN  __IO_FF_HIRES_GREEN
#define IO_FF_HIRES_CYAN  __IO_FF_HIRES_CYAN
#define IO_FF_HIRES_YELLOW  __IO_FF_HIRES_YELLOW
#define IO_FF_HIRES_WHITE  __IO_FF_HIRES_WHITE

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

#define IO_FFFD_ENABLE_L  __IO_FFFD_ENABLE_L
#define IO_FFFD_ENABLE_R  __IO_FFFD_ENABLE_R
#define IO_FFFD_ENABLE_LR  __IO_FFFD_ENABLE_LR
#define IO_FFFD_SELECT_PSG_0  __IO_FFFD_SELECT_PSG_0
#define IO_FFFD_SELECT_PSG_1  __IO_FFFD_SELECT_PSG_1
#define IO_FFFD_SELECT_PSG_2  __IO_FFFD_SELECT_PSG_2

// 0x123b, IO_LAYER_2_CONFIG

#define IL2C_ENABLE_LOWER_16K  __IL2C_ENABLE_LOWER_16K
#define IL2C_SHOW_LAYER_2  __IL2C_SHOW_LAYER_2
#define IL2C_SELECT_SHADOW_BUFFER  __IL2C_SELECT_SHADOW_BUFFER
#define IL2C_BANK_SELECT_MASK  __IL2C_BANK_SELECT_MASK
#define IL2C_BANK_SELECT_0  __IL2C_BANK_SELECT_0
#define IL2C_BANK_SELECT_1  __IL2C_BANK_SELECT_1
#define IL2C_BANK_SELECT_2  __IL2C_BANK_SELECT_2

#define IO_123B_ENABLE_LOWER_16K  __IO_123B_ENABLE_LOWER_16K
#define IO_123B_SHOW_LAYER_2  __IO_123B_SHOW_LAYER_2
#define IO_123B_SELECT_SHADOW_BUFFER  __IO_123B_SELECT_SHADOW_BUFFER
#define IO_123B_BANK_SELECT_MASK  __IO_123B_BANK_SELECT_MASK
#define IO_123B_BANK_SELECT_0  __IO_123B_BANK_SELECT_0
#define IO_123B_BANK_SELECT_1  __IO_123B_BANK_SELECT_1
#define IO_123B_BANK_SELECT_2  __IO_123B_BANK_SELECT_2

// 0x303b, IO_SPRITE_FLAGS

#define ISF_MAX_SPRITES_PER_LINE  __ISF_MAX_SPRITES_PER_LINE
#define ISF_COLLISION  __ISF_COLLISION

#define IO_303B_MAX_SPRITES_PER_LINE  __IO_303B_MAX_SPRITES_PER_LINE
#define IO_303B_COLLISION  __IO_303B_COLLISION

// 0x143b, IO_UART_BAUD_RATE

// actual uart clock as a function of video timing 0-7

#define CLK_28_0  __CLK_28_0
#define CLK_28_1  __CLK_28_1
#define CLK_28_2  __CLK_28_2
#define CLK_28_3  __CLK_28_3
#define CLK_28_4  __CLK_28_4
#define CLK_28_5  __CLK_28_5
#define CLK_28_6  __CLK_28_6
#define CLK_28_7  __CLK_28_7

// these are calculated using a nominal 28MHz clock

#define IUBR_115200_L  __IUBR_115200_L
#define IUBR_115200_H  __IUBR_115200_H
#define IUBR_57600_L  __IUBR_57600_L
#define IUBR_57600_H  __IUBR_57600_H
#define IUBR_38400_L  __IUBR_38400_L
#define IUBR_38400_H  __IUBR_38400_H
#define IUBR_31250_L  __IUBR_31250_L
#define IUBR_31250_H  __IUBR_31250_H
#define IUBR_19200_L  __IUBR_19200_L
#define IUBR_19200_H  __IUBR_19200_H
#define IUBR_9600_L  __IUBR_9600_L
#define IUBR_9600_H  __IUBR_9600_H
#define IUBR_4800_L  __IUBR_4800_L
#define IUBR_4800_H  __IUBR_4800_H
#define IUBR_2400_L  __IUBR_2400_L
#define IUBR_2400_H  __IUBR_2400_H

#define IO_143B_115200_L  __IO_143B_115200_L
#define IO_143B_115200_H  __IO_143B_115200_H
#define IO_143B_57600_L  __IO_143B_57600_L
#define IO_143B_57600_H  __IO_143B_57600_H
#define IO_143B_38400_L  __IO_143B_38400_L
#define IO_143B_38400_H  __IO_143B_38400_H
#define IO_143B_31250_L  __IO_143B_31250_L
#define IO_143B_31250_H  __IO_143B_31250_H
#define IO_143B_19200_L  __IO_143B_19200_L
#define IO_143B_19200_H  __IO_143B_19200_H
#define IO_143B_9600_L  __IO_143B_9600_L
#define IO_143B_9600_H  __IO_143B_9600_H
#define IO_143B_4800_L  __IO_143B_4800_L
#define IO_143B_4800_H  __IO_143B_4800_H
#define IO_143B_2400_L  __IO_143B_2400_L
#define IO_143B_2400_H  __IO_143B_2400_H

// 0x133b, IO_UART_STATUS

#define IUS_RX_AVAIL  __IUS_RX_AVAIL
#define IUS_RX_FULL  __IUS_RX_FULL
#define IUS_TX_BUSY  __IUS_TX_BUSY

#define IO_133B_RX_AVAIL  __IO_133B_RX_AVAIL
#define IO_133B_RX_FULL  __IO_133B_RX_FULL
#define IO_133B_TX_BUSY  __IO_133B_TX_BUSY

// 0x6b, IO_DMA

#define D_WR0  __D_WR0

#define D_WR0_TRANSFER  __D_WR0_TRANSFER
#define D_WR0_A_TO_B  __D_WR0_A_TO_B
#define D_WR0_B_TO_A  __D_WR0_B_TO_A

#define D_WR0_X3_A_START_L  __D_WR0_X3_A_START_L
#define D_WR0_X4_A_START_H  __D_WR0_X4_A_START_H
#define D_WR0_X34_A_START  __D_WR0_X34_A_START
#define D_WR0_X5_LEN_L  __D_WR0_X5_LEN_L
#define D_WR0_X6_LEN_H  __D_WR0_X6_LEN_H
#define D_WR0_X56_LEN  __D_WR0_X56_LEN

#define D_WR0_X3  __D_WR0_X3
#define D_WR0_X4  __D_WR0_X4
#define D_WR0_X5  __D_WR0_X5
#define D_WR0_X6  __D_WR0_X6
#define D_WR0_X34  __D_WR0_X34
#define D_WR0_X35  __D_WR0_X35
#define D_WR0_X36  __D_WR0_X36
#define D_WR0_X45  __D_WR0_X45
#define D_WR0_X46  __D_WR0_X46
#define D_WR0_X56  __D_WR0_X56
#define D_WR0_X345  __D_WR0_X345
#define D_WR0_X346  __D_WR0_X346
#define D_WR0_X356  __D_WR0_X356
#define D_WR0_X456  __D_WR0_X456
#define D_WR0_X3456  __D_WR0_X3456

#define D_WR0_TRANSFER_A_TO_B  __D_WR0_TRANSFER_A_TO_B
#define D_WR0_TRANSFER_B_TO_A  __D_WR0_TRANSFER_B_TO_A
#define D_WR0_XFER_A_TO_B  __D_WR0_XFER_A_TO_B
#define D_WR0_XFER_B_TO_A  __D_WR0_XFER_B_TO_A

#define D_WR1  __D_WR1

#define D_WR1_A_IS_MEM  __D_WR1_A_IS_MEM
#define D_WR1_A_IS_IO  __D_WR1_A_IS_IO
#define D_WR1_A_DEC  __D_WR1_A_DEC
#define D_WR1_A_INC  __D_WR1_A_INC
#define D_WR1_A_FIX  __D_WR1_A_FIX

#define D_WR1_X6  __D_WR1_X6
#define D_WR1_X6_A_TIMING  __D_WR1_X6_A_TIMING

#define D_WR1X6_A_CLEN_2  __D_WR1X6_A_CLEN_2
#define D_WR1X6_A_CLEN_3  __D_WR1X6_A_CLEN_3
#define D_WR1X6_A_CLEN_4  __D_WR1X6_A_CLEN_4

#define D_WR1_A_IS_MEM_DEC  __D_WR1_A_IS_MEM_DEC
#define D_WR1_A_IS_MEM_INC  __D_WR1_A_IS_MEM_INC
#define D_WR1_A_IS_MEM_FIX  __D_WR1_A_IS_MEM_FIX
#define D_WR1_A_IS_IO_DEC  __D_WR1_A_IS_IO_DEC
#define D_WR1_A_IS_IO_INC  __D_WR1_A_IS_IO_INC
#define D_WR1_A_IS_IO_FIX  __D_WR1_A_IS_IO_FIX

#define D_WR2  __D_WR2

#define D_WR2_B_IS_MEM  __D_WR2_B_IS_MEM
#define D_WR2_B_IS_IO  __D_WR2_B_IS_IO
#define D_WR2_B_DEC  __D_WR2_B_DEC
#define D_WR2_B_INC  __D_WR2_B_INC
#define D_WR2_B_FIX  __D_WR2_B_FIX

#define D_WR2_X6  __D_WR2_X6
#define D_WR2_X6_B_TIMING  __D_WR2_X6_B_TIMING

#define D_WR2X6_B_CLEN_2  __D_WR2X6_B_CLEN_2
#define D_WR2X6_B_CLEN_3  __D_WR2X6_B_CLEN_3
#define D_WR2X6_B_CLEN_4  __D_WR2X6_B_CLEN_4

#define D_WR2X6_X5  __D_WR2X6_X5
#define D_WR2X6_X5_PRESCALAR  __D_WR2X6_X5_PRESCALAR

#define D_WR2_B_IS_MEM_DEC  __D_WR2_B_IS_MEM_DEC
#define D_WR2_B_IS_MEM_INC  __D_WR2_B_IS_MEM_INC
#define D_WR2_B_IS_MEM_FIX  __D_WR2_B_IS_MEM_FIX
#define D_WR2_B_IS_IO_DEC  __D_WR2_B_IS_IO_DEC
#define D_WR2_B_IS_IO_INC  __D_WR2_B_IS_IO_INC
#define D_WR2_B_IS_IO_FIX  __D_WR2_B_IS_IO_FIX

#define D_WR3  __D_WR3
#define D_WR3_ENABLE_DMA  __D_WR3_ENABLE_DMA

#define D_WR4  __D_WR4

#define D_WR4_CONT  __D_WR4_CONT
#define D_WR4_BURST  __D_WR4_BURST

#define D_WR4_X2  __D_WR4_X2
#define D_WR4_X3  __D_WR4_X3
#define D_WR4_X23  __D_WR4_X23

#define D_WR4_X2_B_START_L  __D_WR4_X2_B_START_L
#define D_WR4_X3_B_START_H  __D_WR4_X3_B_START_H
#define D_WR4_X23_B_START  __D_WR4_X23_B_START

#define D_WR5  __D_WR5

#define D_WR5_CE  __D_WR5_CE
#define D_WR5_CE_WAIT  __D_WR5_CE_WAIT

#define D_WR5_STOP  __D_WR5_STOP
#define D_WR5_RESTART  __D_WR5_RESTART

#define D_LOAD  __D_LOAD
#define D_CONTINUE  __D_CONTINUE
#define D_ENABLE_DMA  __D_ENABLE_DMA
#define D_DISABLE_DMA  __D_DISABLE_DMA
#define D_READ_MASK  __D_READ_MASK

#define D_RM_STATUS  __D_RM_STATUS
#define D_RM_COUNTER_L  __D_RM_COUNTER_L
#define D_RM_COUNTER_H  __D_RM_COUNTER_H
#define D_RM_COUNTER  __D_RM_COUNTER
#define D_RM_A_ADDR_L  __D_RM_A_ADDR_L
#define D_RM_A_ADDR_H  __D_RM_A_ADDR_H
#define D_RM_A_ADDR  __D_RM_A_ADDR
#define D_RM_B_ADDR_L  __D_RM_B_ADDR_L
#define D_RM_B_ADDR_H  __D_RM_B_ADDR_H
#define D_RM_B_ADDR  __D_RM_B_ADDR

// 0xe3, IO_DIVIDE_CONTROL

#define IDC_CONMEM  __IDC_CONMEM
#define IDC_MAPRAM  __IDC_MAPRAM

// 0xe7, IO_SPI_CONTROL

#define ISC_SPI_CS  __ISC_SPI_CS
#define ISC_FT_CS  __ISC_FT_CS
#define ISC_RPI_CS1  __ISC_RPI_CS1
#define ISC_RPI_CS0  __ISC_RPI_CS0
#define ISC_SD_CS1  __ISC_SD_CS1
#define ISC_SD_CS0  __ISC_SD_CS0

#define IO_E7_SPI_CS  __IO_E7_SPI_CS
#define IO_E7_FT_CS  __IO_E7_FT_CS
#define IO_E7_RPI_CS1  __IO_E7_RPI_CS1
#define IO_E7_RPI_CS0  __IO_E7_RPI_CS0
#define IO_E7_SD_CS1  __IO_E7_SD_CS1
#define IO_E7_SD_CS0  __IO_E7_SD_CS0

///////////////////////////////////////////////////////////////

// tbblue registry system
#ifdef __CLANG
extern unsigned char IO_243B;
extern unsigned char IO_NEXTREG_REG;

extern unsigned char IO_253B;
extern unsigned char IO_NEXTREG_DAT;
#else
__sfr __banked __at 0x243b IO_243B;
__sfr __banked __at __IO_NEXTREG_REG IO_NEXTREG_REG;

__sfr __banked __at 0x253b IO_253B;
__sfr __banked __at __IO_NEXTREG_DAT IO_NEXTREG_DAT;
#endif

// zx next registry

#define REG_MACHINE_ID  __REG_MACHINE_ID
#define RMI_DE1A  __RMI_DE1A
#define RMI_DE2A  __RMI_DE2A
#define RMI_FBLABS  __RMI_FBLABS
#define RMI_VTRUCCO  __RMI_VTRUCCO
#define RMI_WXEDA  __RMI_WXEDA
#define RMI_EMULATORS  __RMI_EMULATORS
#define RMI_ZXNEXT  __RMI_ZXNEXT
#define RMI_MULTICORE  __RMI_MULTICORE
#define RMI_ZXNEXT_AB  __RMI_ZXNEXT_AB

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

#define REG_RAM_PAGE  __REG_RAM_PAGE
#define RRP_RAM_DIVMMC  __RRP_RAM_DIVMMC
#define RRP_ROM_DIVMMC  __RRP_ROM_DIVMMC
#define RRP_ROM_MF  __RRP_ROM_MF
#define RRP_ROM_SPECTRUM  __RRP_ROM_SPECTRUM

#define REG_PERIPHERAL_1  __REG_PERIPHERAL_1
#define RP1_JOY1_SINCLAIR  __RP1_JOY1_SINCLAIR
#define RP1_JOY1_SINCLAIR_1  __RP1_JOY1_SINCLAIR_1
#define RP1_JOY1_SINCLAIR_2  __RP1_JOY1_SINCLAIR_2
#define RP1_JOY1_KEMPSTON  __RP1_JOY1_KEMPSTON
#define RP1_JOY1_KEMPSTON_1  __RP1_JOY1_KEMPSTON_1
#define RP1_JOY1_KEMPSTON_2  __RP1_JOY1_KEMPSTON_2
#define RP1_JOY1_CURSOR  __RP1_JOY1_CURSOR
#define RP1_JOY1_MD_1  __RP1_JOY1_MD_1
#define RP1_JOY1_MD_2  __RP1_JOY1_MD_2
#define RP1_JOY2_SINCLAIR  __RP1_JOY2_SINCLAIR
#define RP1_JOY2_SINCLAIR_1  __RP1_JOY2_SINCLAIR_1
#define RP1_JOY2_SINCLAIR_2  __RP1_JOY2_SINCLAIR_2
#define RP1_JOY2_KEMPSTON  __RP1_JOY2_KEMPSTON
#define RP1_JOY2_KEMPSTON_1  __RP1_JOY2_KEMPSTON_1
#define RP1_JOY2_KEMPSTON_2  __RP1_JOY2_KEMPSTON_2
#define RP1_JOY2_CURSOR  __RP1_JOY2_CURSOR
#define RP1_JOY2_MD_1  __RP1_JOY2_MD_1
#define RP1_JOY2_MD_2  __RP1_JOY2_MD_2
#define RP1_RATE_50  __RP1_RATE_50
#define RP1_RATE_60  __RP1_RATE_60
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

#define REG_PERIPHERAL_3  __REG_PERIPHERAL_3
#define RP3_STEREO_ABC  __RP3_STEREO_ABC
#define RP3_STEREO_ACB  __RP3_STEREO_ACB
#define RP3_ENABLE_SPEAKER  __RP3_ENABLE_SPEAKER
#define RP3_ENABLE_SPECDRUM  __RP3_ENABLE_SPECDRUM
#define RP3_ENABLE_COVOX  __RP3_ENABLE_COVOX
#define RP3_ENABLE_TIMEX  __RP3_ENABLE_TIMEX
#define RP3_ENABLE_TURBOSOUND  __RP3_ENABLE_TURBOSOUND
#define RP3_DISABLE_CONTENTION  __RP3_DISABLE_CONTENTION
#define RP3_UNLOCK_7FFD  __RP3_UNLOCK_7FFD

#define REG_PERIPHERAL_4  __REG_PERIPHERAL_4
#define RP4_SCANLINES_OFF  __RP4_SCANLINES_OFF
#define RP4_SCANLINES_25  __RP4_SCANLINES_25
#define RP4_SCANLINES_50  __RP4_SCANLINES_50
#define RP4_SCANLINES_75  __RP4_SCANLINES_75

#define REG_SUB_VERSION  __REG_SUB_VERSION

#define REG_VIDEO_PARAM  __REG_VIDEO_PARAM

#define REG_ANTI_BRICK  __REG_ANTI_BRICK
#define RAB_COMMAND_NORMALCORE  __RAB_COMMAND_NORMALCORE
#define RAB_BUTTON_DIVMMC  __RAB_BUTTON_DIVMMC
#define RAB_BUTTON_MULTIFACE  __RAB_BUTTON_MULTIFACE

#define REG_VIDEO_TIMING  __REG_VIDEO_TIMING

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

#define REG_ACTIVE_VIDEO_LINE_H  __REG_ACTIVE_VIDEO_LINE_H

#define REG_ACTIVE_VIDEO_LINE_L  __REG_ACTIVE_VIDEO_LINE_L

#define REG_LINE_INTERRUPT_CONTROL  __REG_LINE_INTERRUPT_CONTROL
#define RLIC_INTERRUPT_FLAG  __RLIC_INTERRUPT_FLAG
#define RLIC_DISABLE_ULA_INTERRUPT  __RLIC_DISABLE_ULA_INTERRUPT
#define RLIC_ENABLE_LINE_INTERRUPT  __RLIC_ENABLE_LINE_INTERRUPT
#define RLIC_LINE_INTERRUPT_VALUE_H  __RLIC_LINE_INTERRUPT_VALUE_H

#define REG_LINE_INTERRUPT_VALUE_L  __REG_LINE_INTERRUPT_VALUE_L

#define REG_KEYMAP_ADDRESS_H  __REG_KEYMAP_ADDRESS_H

#define REG_KEYMAP_ADDRESS_L  __REG_KEYMAP_ADDRESS_L

#define REG_KEYMAP_DATA_H  __REG_KEYMAP_DATA_H

#define REG_KEYMAP_DATA_L  __REG_KEYMAP_DATA_L

#define REG_DAC_MONO  __REG_DAC_MONO

#define REG_LORES_OFFSET_X  __REG_LORES_OFFSET_X

#define REG_LORES_OFFSET_Y  __REG_LORES_OFFSET_Y

#define REG_PALETTE_INDEX  __REG_PALETTE_INDEX

#define REG_PALETTE_VALUE_8  __REG_PALETTE_VALUE_8

#define REG_ULANEXT_PALETTE_FORMAT  __REG_ULANEXT_PALETTE_FORMAT

#define REG_PALETTE_CONTROL  __REG_PALETTE_CONTROL
#define RPC_DISABLE_AUTOINC  __RPC_DISABLE_AUTOINC
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

#define REG_FALLBACK_COLOR  __REG_FALLBACK_COLOR

#define REG_SPRITE_TRANSPARENCY_INDEX  __REG_SPRITE_TRANSPARENCY_INDEX

#define REG_MMU0  __REG_MMU0
#define REG_MMU1  __REG_MMU1
#define REG_MMU2  __REG_MMU2
#define REG_MMU3  __REG_MMU3
#define REG_MMU4  __REG_MMU4
#define REG_MMU5  __REG_MMU5
#define REG_MMU6  __REG_MMU6
#define REG_MMU7  __REG_MMU7

#define REG_COPPER_DATA  __REG_COPPER_DATA

#define REG_COPPER_CONTROL_L  __REG_COPPER_CONTROL_L

#define REG_COPPER_CONTROL_H  __REG_COPPER_CONTROL_H
#define RCCH_COPPER_STOP  __RCCH_COPPER_STOP
#define RCCH_COPPER_RUN_LOOP_RESET  __RCCH_COPPER_RUN_LOOP_RESET
#define RCCH_COPPER_RUN_LOOP  __RCCH_COPPER_RUN_LOOP
#define RCCH_COPPER_RUN_VBI  __RCCH_COPPER_RUN_VBI

#define REG_DEBUG  __REG_DEBUG

///////////////////////////////////////////////////////////////

// zx next configuration

#ifdef __CLANG
#define ZXN_NEXTREG(reg,val)  ((void)ZXN_NEXTREG_##reg##_##val())
#endif

#ifdef __SDCC
#define ZXN_NEXTREG_helper(reg,val)  { extern void ZXN_NEXTREG_R_##reg(void) __preserves_regs(a,b,c,d,e,h,l,iyl,iyh); extern void ZXN_NEXTREG_V_##val(void) __preserves_regs(a,b,c,d,e,h,l,iyl,iyh); ZXN_NEXTREG_R_##reg(); ZXN_NEXTREG_V_##val(); }
#define ZXN_NEXTREG(reg,val)  ZXN_NEXTREG_helper(reg,val)
#define ZXN_NEXTREGA_helper(reg,val)  { extern void ZXN_NEXTREGA_##reg(unsigned char) __preserves_regs(b,c,d,e,h,l,iyl,iyh) __z88dk_fastcall; ZXN_NEXTREGA_##reg(val); }
#define ZXN_NEXTREGA(reg,val)  ZXN_NEXTREGA_helper(reg,val)
#endif

#ifdef __SCCZ80
#define ZXN_NEXTREG_helper(reg,val)  { extern void ZXN_NEXTREG_R_##reg(void); extern void ZXN_NEXTREG_V_##val(void); ZXN_NEXTREG_R_##reg(); ZXN_NEXTREG_V_##val(); }
#define ZXN_NEXTREG(reg,val)  ZXN_NEXTREG_helper(reg,val)
#define ZXN_NEXTREGA_helper(reg,val)  { extern void ZXN_NEXTREGA_##reg(unsigned char) __z88dk_fastcall; ZXN_NEXTREGA_##reg(val); }
#define ZXN_NEXTREGA(reg,val)  ZXN_NEXTREGA_helper(reg,val)
#endif

__DPROTO(`a,d,e,h,iyl,iyh',`a,d,e,h,iyl,iyh',unsigned char,,ZXN_READ_REG,unsigned char reg)
__DPROTO(`a,d,e,iyl,iyh',`a,d,e,iyl,iyh',void,,ZXN_WRITE_REG,unsigned char reg, unsigned char val)

// zx next memory map

__OPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',unsigned char,,ZXN_READ_MMU0,void)
__OPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',unsigned char,,ZXN_READ_MMU1,void)
__OPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',unsigned char,,ZXN_READ_MMU2,void)
__OPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',unsigned char,,ZXN_READ_MMU3,void)
__OPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',unsigned char,,ZXN_READ_MMU4,void)
__OPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',unsigned char,,ZXN_READ_MMU5,void)
__OPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',unsigned char,,ZXN_READ_MMU6,void)
__OPROTO(`d,e,h,iyl,iyh',`d,e,h,iyl,iyh',unsigned char,,ZXN_READ_MMU7,void)

#ifdef __SDCC
#define ZXN_WRITE_MMU0(val)  { extern void ZXN_WRITE_MMU_0(unsigned char) __preserves_regs(b,c,d,e,h,l,iyl,iyh) __z88dk_fastcall; ZXN_WRITE_MMU_0(val); }
#define ZXN_WRITE_MMU1(val)  { extern void ZXN_WRITE_MMU_1(unsigned char) __preserves_regs(b,c,d,e,h,l,iyl,iyh) __z88dk_fastcall; ZXN_WRITE_MMU_1(val); }
#define ZXN_WRITE_MMU2(val)  { extern void ZXN_WRITE_MMU_2(unsigned char) __preserves_regs(b,c,d,e,h,l,iyl,iyh) __z88dk_fastcall; ZXN_WRITE_MMU_2(val); }
#define ZXN_WRITE_MMU3(val)  { extern void ZXN_WRITE_MMU_3(unsigned char) __preserves_regs(b,c,d,e,h,l,iyl,iyh) __z88dk_fastcall; ZXN_WRITE_MMU_3(val); }
#define ZXN_WRITE_MMU4(val)  { extern void ZXN_WRITE_MMU_4(unsigned char) __preserves_regs(b,c,d,e,h,l,iyl,iyh) __z88dk_fastcall; ZXN_WRITE_MMU_4(val); }
#define ZXN_WRITE_MMU5(val)  { extern void ZXN_WRITE_MMU_5(unsigned char) __preserves_regs(b,c,d,e,h,l,iyl,iyh) __z88dk_fastcall; ZXN_WRITE_MMU_5(val); }
#define ZXN_WRITE_MMU6(val)  { extern void ZXN_WRITE_MMU_6(unsigned char) __preserves_regs(b,c,d,e,h,l,iyl,iyh) __z88dk_fastcall; ZXN_WRITE_MMU_6(val); }
#define ZXN_WRITE_MMU7(val)  { extern void ZXN_WRITE_MMU_7(unsigned char) __preserves_regs(b,c,d,e,h,l,iyl,iyh) __z88dk_fastcall; ZXN_WRITE_MMU_7(val); }
#endif

#ifdef __SCCZ80
#define ZXN_WRITE_MMU0(val)  { extern void ZXN_WRITE_MMU_0(unsigned char) __z88dk_fastcall; ZXN_WRITE_MMU_0(val); }
#define ZXN_WRITE_MMU1(val)  { extern void ZXN_WRITE_MMU_1(unsigned char) __z88dk_fastcall; ZXN_WRITE_MMU_1(val); }
#define ZXN_WRITE_MMU2(val)  { extern void ZXN_WRITE_MMU_2(unsigned char) __z88dk_fastcall; ZXN_WRITE_MMU_2(val); }
#define ZXN_WRITE_MMU3(val)  { extern void ZXN_WRITE_MMU_3(unsigned char) __z88dk_fastcall; ZXN_WRITE_MMU_3(val); }
#define ZXN_WRITE_MMU4(val)  { extern void ZXN_WRITE_MMU_4(unsigned char) __z88dk_fastcall; ZXN_WRITE_MMU_4(val); }
#define ZXN_WRITE_MMU5(val)  { extern void ZXN_WRITE_MMU_5(unsigned char) __z88dk_fastcall; ZXN_WRITE_MMU_5(val); }
#define ZXN_WRITE_MMU6(val)  { extern void ZXN_WRITE_MMU_6(unsigned char) __z88dk_fastcall; ZXN_WRITE_MMU_6(val); }
#define ZXN_WRITE_MMU7(val)  { extern void ZXN_WRITE_MMU_7(unsigned char) __z88dk_fastcall; ZXN_WRITE_MMU_7(val); }
#endif


// memory - paging and banking state

__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',void,*,zxn_addr_from_mmu,unsigned char mmu)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,,zxn_mmu_from_addr,void *addr)
__DPROTO(`b,c,d,iyl,iyh',`b,c,d,iyl,iyh',void,*,zxn_addr_in_mmu,unsigned char mmu, void *addr)

__DPROTO(`b,c,iyl,iyh',`b,c,iyl,iyh',unsigned long,,zxn_addr_from_page,unsigned char page)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,iyl,iyh',unsigned char,,zxn_page_from_addr,unsigned long addr)

__DPROTO(`a,iyl,iyh',`iyl,iyh',void,,zxn_read_mmu_state,void *dst)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,zxn_write_mmu_state,void *src)

__DPROTO(`d,e,h,l,iyl,iyh',`d,e,iyl,iyh',void,,zxn_write_bank_state,unsigned int state)
__OPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned int,,zxn_read_sysvar_bank_state,void)
__DPROTO(`b,c,d,e,h,l,iyl,iyh',`b,c,d,e,iyl,iyh',void,,zxn_write_sysvar_bank_state,unsigned int state)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned int,,zxn_mangle_bank_state,unsigned int state)

// version checks

// note that dot commands will automatically check version with suitable pragma defined
//
// core_version: MmSS (major, minor, sub) in hexadecimal; v 1.10.51 would be 0x1a33
// esxdos_version: esxdos does not return version yet; use 0 or 1 to verify presence
// nextzxos_version: MMmm (major, minor) in bcd; v 1.94 would be 0x0194

__DPROTO(`d,iyl,iyh',`d,iyl,iyh',unsigned char,,check_version_core,unsigned int core_version)
__DPROTO(`iyl,iyh',`iyl,iyh',unsigned char,,check_version_esxdos,unsigned int esxdos_version)
__DPROTO(`iyl,iyh',`iyl,iyh',unsigned char,,check_version_nextzxos,unsigned int nextzxos_version)

///////////////////////////////////////////////////////////////

// tape i/o - ROM3 (48k rom) must be enabled

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

// flags for "mode" parameter of ts_vmod()

#define TVM_SPECTRUM   __IO_TVM_DFILE_1       // 256x192 pix, 32x24 attr
#define TVM_DFILE1     __IO_TVM_DFILE_1       // synonym ^^
#define TVM_DFILE2     __IO_TVM_DFILE_2       // 256x192 pix, 32x24 attr second display file
#define TVM_HICOLOR    __IO_TVM_HICOLOR       // 256x192 pix, 32x192 attr
#define TVM_HIRES      __IO_TVM_HIRES         // 512x192 pix OR with paper colour

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
