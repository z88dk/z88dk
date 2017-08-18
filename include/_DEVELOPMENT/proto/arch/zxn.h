include(__link__.m4)

#ifndef _ARCH_ZX_H
#define _ARCH_ZX_H

#include <arch.h>

#include <stddef.h>
#include <rect.h>

// COMMON CONSTANTS

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

// GLOBAL VARIABLES

extern unsigned char GLOBAL_ZX_PORT_FE;
extern unsigned char GLOBAL_ZX_PORT_1FFD;
extern unsigned char GLOBAL_ZX_PORT_7FFD;

// IO MAPPED REGISTERS

#ifdef __CLANG

// SPECTRUM

extern unsigned char IO_FE;
extern unsigned char IO_1FFD;
extern unsigned char IO_7FFD;

// TBBLUE I/O Port system

extern unsigned char IO_REGISTRY_REG;
extern unsigned char IO_REGISTRY_DAT;

extern unsigned char IO_253B;
extern unsigned char IO_243B;

// Layer 2

extern unsigned char IO_LAYER_2_ACCESS;
extern unsigned char IO_123B;

// Hardware Sprites

extern unsigned char IO_SPRITE_SLOT;   // write
extern unsigned char IO_SPRITE_FLAGS;  // read

extern unsigned char IO_SPRITE_PALETTE;
extern unsigned char IO_SPRITE_ATTRIBUTE;
extern unsigned char IO_SPRITE_PATTERN;

extern unsigned char IO_303B;

extern unsigned char IO_53;
extern unsigned char IO_57;
extern unsigned char IO_5B;

// Audio

extern unsigned char IO_AUDIO_SELECT;

extern unsigned char IO_AUDIO_REG;
extern unsigned char IO_AUDIO_DAT;

extern unsigned char IO_FFFD;
extern unsigned char IO_BFFD;

#else

// SPECTRUM

__sfr __at 0xfe IO_FE;

__sfr __banked __at 0x1ffd IO_1FFD;
__sfr __banked __at 0x7ffd IO_7FFD;

// TBBLUE I/O Port system

__sfr __banked __at __IO_REGISTRY_REG IO_REGISTRY_REG;
__sfr __banked __at __IO_REGISTRY_DAT IO_REGISTRY_DAT;

__sfr __banked __at 0x253b IO_253B;
__sfr __banked __at 0x243b IO_243B;

// Layer 2

__sfr __banked __at __IO_LAYER_2_ACCESS IO_LAYER_2_ACCESS;
__sfr __banked __at 0x123b IO_123B;

// Hardware Sprites

__sfr __banked __at __IO_SPRITE_SLOT  IO_SPRITE_SLOT;   // write
__sfr __banked __at __IO_SPRITE_FLAGS IO_SPRITE_FLAGS;  // read

__sfr __at __IO_SPRITE_PALETTE   IO_SPRITE_PALETTE;
__sfr __at __IO_SPRITE_ATTRIBUTE IO_SPRITE_ATTRIBUTE;
__sfr __at __IO_SPRITE_PATTERN   IO_SPRITE_PATTERN;

__sfr __banked __at 0x303b IO_303B;

__sfr __at 0x53 IO_53;
__sfr __at 0x57 IO_57;
__sfr __at 0x5b IO_5B;

// Audio

__sfr __banked __at __IO_AUDIO_SELECT IO_AUDIO_SELECT;

__sfr __banked __at __IO_AUDIO_REG    IO_AUDIO_REG;
__sfr __banked __at __IO_AUDIO_DAT    IO_AUDIO_DAT;

__sfr __banked __at 0xfffd IO_FFFD;
__sfr __banked __at 0xbffd IO_BFFD;

#endif

// misc

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
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned int,,zx_saddr2px,void *saddr)
__DPROTO(`b,c,d,e,h,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned int,,zx_saddr2py,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_saddrcdown,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_saddrcleft,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_saddrcright,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_saddrcup,void *saddr)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_saddrpdown,void *saddr)
__DPROTO(`b,c,iyl,iyh',`b,c,iyl,iyh',unsigned char,*,zx_saddrpleft,void *saddr,unsigned char bitmask)
__DPROTO(`b,c,iyl,iyh',`b,c,iyl,iyh',unsigned char,*,zx_saddrpright,void *saddr,unsigned char bitmask)
__DPROTO(`b,c,d,e,iyl,iyh',`b,c,d,e,iyl,iyh',unsigned char,*,zx_saddrpup,void *saddr)

// graphics

__DPROTO(,,int,,zx_pattern_fill,unsigned char x,unsigned char y,void *pattern,unsigned int depth)

#endif
