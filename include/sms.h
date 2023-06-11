/*
 *  Sega Master System
 *
 *  $Id: sms.h,v 1.5 2017-01-03 02:23:05 aralbrec Exp $
 */

#ifndef __SMS_H__
#define __SMS_H__

#include <sys/compiler.h>

#include <compress/aplib.h>

#define VDP_REG_FLAGS0 0x80
// Screen sync off
#define VDP_REG_FLAGS0_SYNC 0x01
// Normal or enable stretch screen
#define VDP_REG_FLAGS0_STRETCH 0x02
// Causes graphics change (related to screen addr?)
#define VDP_REG_FLAGS0_CHANGE 0x04
// Shift sprites left by 1 character
#define VDP_REG_FLAGS0_SHIFT 0x08
// Horizontal interupts enable
#define VDP_REG_FLAGS0_HINT 0x10
// Display extra column on LHS of screen
#define VDP_REG_FLAGS0_LHS 0x20
// Top 2 rows of screen horizontal non-scrolling
#define VDP_REG_FLAGS0_LOCKTOP 0x40
// Right side of screen vertical non-scrolling
#define VDP_REG_FLAGS0_LOCKRIGHT 0x80


#define VDP_REG_FLAGS1 0x81
// Double sized pixels in sprites
#define VDP_REG_FLAGS1_DOUBLE 0x01
// 8x16 sprites
#define VDP_REG_FLAGS1_8x16 0x02
// 0?
#define VDP_REG_FLAGS1_BIT2 0x04
// Stretch screen by 6 rows
#define VDP_REG_FLAGS1_STRETCH6 0x08
// Stretch screen by 4 rows
#define VDP_REG_FLAGS1_STRETCH4 0x10
// Vertical interrupts enable
#define VDP_REG_FLAGS1_VINT 0x20
// Screen enable
#define VDP_REG_FLAGS1_SCREEN 0x40
// 0?
#define VDP_REG_FLAGS1_BIT7 0x80

#define VDP_REG_HINT_COUNTER 0x8A

// Bkg tile appears in front of the sprites
#define BKG_ATTR_PRIO 0x1000
// Bkg tile uses sprite palette
#define BKG_ATTR_SPRPAL 0x0800
// Bkg tile is vertically flipped
#define BKG_ATTR_VFLIP 0x0400
// Bkg tile is horizontally flipped
#define BKG_ATTR_HFLIP 0x0200
// Bkg tile uses the second tileset
#define BKG_ATTR_2NDTILESET 0x0100

#define __SMS_JOY_UP 0x01
#define __SMS_JOY_DOWN 0x02
#define __SMS_JOY_LEFT 0x04
#define __SMS_JOY_RIGHT 0x08
#define __SMS_JOY_FIREA 0x10
#define __SMS_JOY_FIREB 0x20

#ifndef JOY_UP
// JOY_UP is defined in games.h using standard z88dk bits
#define JOY_UP __SMS_JOY_UP
#define JOY_DOWN __SMS_JOY_DOWN
#define JOY_LEFT __SMS_JOY_LEFT
#define JOY_RIGHT __SMS_JOY_RIGHT
#define JOY_FIREA __SMS_JOY_FIREA
#define JOY_FIREB __SMS_JOY_FIREB
#endif


typedef char               INT8;
typedef unsigned char      UINT8;
typedef int                INT16;
typedef unsigned int       UINT16;
typedef long               INT32;
typedef unsigned long      UINT32;

typedef INT8               BYTE;
typedef UINT8              UBYTE;
typedef INT16              WORD;
typedef UINT16             UWORD;
typedef INT32              LWORD;
typedef UINT32             ULWORD;
typedef INT32		   DWORD;
typedef UINT32		   UDWORD;

#ifndef NULL
#define	NULL     0
#endif

#ifndef FALSE
#define	FALSE    0
#define	TRUE     1
#endif

/* Useful definition for fixed point values */
typedef union _fixed {
  struct {
    UBYTE l;
    UBYTE h;
  } b;
  UWORD w;
} fixed;

extern void __LIB__ clear_vram();
// Load a 6 bit palette - for both gamegear and sms
extern void __LIB__ load_palette(unsigned char *data, int index, int count) __smallc;
// Load a 12 bit palette - gamegear only
extern void __LIB__ load_palette_gamegear(unsigned int *data, int index, int count) __smallc;
extern void __LIB__ load_tiles(unsigned char *data, int index, int count, int bpp) __smallc;
extern void __LIB__ set_bkg_map(unsigned int *data, int x, int y, int w, int h) __smallc;
extern void __LIB__ scroll_bkg(int x, int y) __smallc;
extern int __LIB__ get_vcount();
extern int __LIB__ wait_vblank_noint();
extern void __LIB__ set_sprite(int n, int x, int y, int tile) __smallc;

// Following two methods return __SMS_JOY_XX
extern int __LIB__ read_joypad1();
extern int __LIB__ read_joypad2();

#ifndef gotoxy
// gotoxy is defined in conio.h, so avoid the clash
#define gotoxy(x,y) gotoxy_sms(x,y)
#endif
extern void __LIB__ gotoxy_sms(int x, int y) __smallc;
extern unsigned char standard_font[];  /* Actually data *not* a function */

extern void __LIB__ vdp_set_reg(int reg, int value) __smallc;
#define set_vdp_reg(reg,value)        vdp_set_reg(reg,value)

#include <interrupt.h>

extern void __LIB__ add_pause_int(isr_t func);

extern void __LIB__ set_sound_freq(int channel, int freq) __smallc;
extern void __LIB__ set_sound_volume(int channel, int volume) __smallc;



extern unsigned char pause_flag;

#endif
