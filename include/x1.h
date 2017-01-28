/*
 * Header file for Sharp X1 specific stuff
 *
 * $Id: x1.h,v 1.11 2016-06-11 19:53:08 dom Exp $
 *
 */

#ifndef __X1_H__
#define __X1_H__

#include <sys/compiler.h>

// PSG register, sound, ...

// Init the PSG (reset sound etc..)
//extern void __LIB__ x1_initpsg();


// Programmable Character Generator
// Get the PCG version (1 or 2), depending on the X1 model (or chipset)
// and on the mode DIP switch
extern int __LIB__ x1_get_pcg_version();

// Switch to 40 columns text mode
extern void __LIB__ x1_set_text_40();
// HighScan version, for turbo models only
extern void __LIB__ x1_set_text_40_hs();

// Switch to 80 columns text mode
extern void __LIB__ x1_set_text_80();
// HighScan version, for turbo models only
extern void __LIB__ x1_set_text_80_hs();

// Set 16 6845 CRTC registers at once
extern void  __LIB__ set_crtc(void *reg_list) __z88dk_fastcall;

// Set the first 10 6845 CRTC registers
extern void  __LIB__ set_crtc_10(void *reg_list) __z88dk_fastcall;

// Set a single register in the 6845 CRTC
extern void __LIB__ set_crtc_reg(int reg, int val) __smallc;

// Send a command to the SUB-CPU
extern void  __LIB__ subcpu_command(int command) __z88dk_fastcall;

// Send a byte parameter to the SUB-CPU
extern void  __LIB__ subcpu_set(int command) __z88dk_fastcall;

// Get a byte from the SUB-CPU
extern int __LIB__ subcpu_get();

// Wait the SUB CPU to be ready, used by libraries
extern void wait_sub_cpu();


// Timer related commands

#define SUBCPU_TIMER  0x0d

#define SET_TIMER_0  0xd0
#define SET_TIMER_1  0xd1
#define SET_TIMER_2  0xd2
#define SET_TIMER_3  0xd3
#define SET_TIMER_4  0xd4
#define SET_TIMER_5  0xd5
#define SET_TIMER_6  0xd6
#define SET_TIMER_7  0xd7

#define GET_TIMER_0  0xd8
#define GET_TIMER_1  0xd9
#define GET_TIMER_2  0xda
#define GET_TIMER_3  0xdb
#define GET_TIMER_4  0xdc
#define GET_TIMER_5  0xdd
#define GET_TIMER_6  0xde
#define GET_TIMER_7  0xdf

#define X1_TIMER_MODE_OFF    0x00
#define X1_TIMER_MODE_TVCMD  0x40
#define X1_TIMER_MODE_STOP   0x80
#define X1_TIMER_MODE_TAPE   0xc0



#define SUBCPU_IRQ_VECTOR_SET  0xe4
#define SUBCPU_IRQ_TIMERS_OFF  0xe5

// Direct keyboard access mode, not always available
#define SUBCPU_KEYBOARD_DIECT  0xe3
// on first byte
#define X1_KEY_C    1
#define X1_KEY_X    2
#define X1_KEY_Z    4
#define X1_KEY_D    8
#define X1_KEY_A    16
#define X1_KEY_E    32
#define X1_KEY_W    64
#define X1_KEY_Q    128
// on second byte
#define X1_KEY_3    1
#define X1_KEY_6    2
#define X1_KEY_9    4
#define X1_KEY_2    8
#define X1_KEY_8    16
#define X1_KEY_1    32
#define X1_KEY_4    64
#define X1_KEY_7    128
// on third byte
// .. to be completed

// Text typing keyboard access mode
// Two bytes to get, the SHIFT status flags and the ASCII code
#define SUBCPU_READ_KEYBOARD  0xe6
#define SHIFT_CTRL       1
#define SHIFT_SFT        2
#define SHIFT_KANA       4
#define SHIFT_CAPS       8
#define SHIFT_GRPH      16
#define SHIFT_REP       32
#define SHIFT_KIN       64
#define SHIFT_TEN      128

// TV control and text overlapping controls
#define SUBCPU_SET_TV      0xe7
#define SUBCPU_GET_TV      0xe8
#define TV_VOL_UP       0x01
#define TV_VOL_DOWN     0x02
#define TV_VOL_DEFAULT  0x03
#define TV_MUTE         0x06
#define TV_OFF          0x0d
#define TV_ON_FF        0x0e
#define TV_CHANNEL_1    0x10
#define TV_CHANNEL_2    0x11
#define TV_CHANNEL_3    0x12
#define TV_CHANNEL_4    0x13
#define TV_CHANNEL_5    0x14
#define TV_CHANNEL_6    0x15
#define TV_CHANNEL_7    0x16
#define TV_CHANNEL_8    0x17
#define TV_CHANNEL_9    0x18
#define TV_CHANNEL_10   0x19
#define TV_CHANNEL_11   0x1a
#define TV_CHANNEL_12   0x1b

// Cassette Recorder
#define SUBCPU_TAPE_CONTROL   0xe9
#define SUBCPU_TAPE_STATUS    0xea
#define TAPE_EJECT     0x00
#define TAPE_STOP      0x01
#define TAPE_PLAY      0x02
#define TAPE_FFWD      0x03
#define TAPE_REW       0x04
#define TAPE_APSS_NEXT 0x05
#define TAPE_APSS_PREV 0x06
#define TAPE_RECORD    0x07

#define SUBCPU_TAPE_SENSOR    0xeb
#define TAPE_END   1    // set if Tape end
#define TAPE_SET   2	// set if cassette is present
#define TAPE_WP    3    // set if Write Protected 

// Time / Date
#define SUBCPU_SET_CALENDAR   0xec
#define SUBCPU_GET_CALENDAR   0xed
#define SUBCPU_SET_CLOCK      0xee
#define SUBCPU_GET_CLOCK      0xef


// Input.h
extern unsigned int  __LIB__ in_JoyX1(char num);
#define in_JoyX1_1() in_JoyX1(0x0E);
#define in_JoyX1_2() in_JoyX1(0x0F);
#define in_GetKey() in_Inkey();

#endif
