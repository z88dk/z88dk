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

// misc

__DPROTO(`b,c,d,e',`b,c,d,e',void,,zx_border,uint16_t colour)
__DPROTO(,,void,,zx_cls,uint16_t attr)
__DPROTO(,,void,,zx_cls_wc,struct r_Rect8 *r,uint16_t attr)
__DPROTO(,,void,,zx_scroll_up,uint16_t rows,uint16_t attr)
__DPROTO(,,void,,zx_scroll_wc_up,struct r_Rect8 *r,uint16_t rows,uint16_t attr)

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
// cyx   = character (y,x) coordinate - ordering borrowed from Sinclair Basic
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

__DPROTO(`b,c,d,e',`b,c,d,e',unsigned int,,zx_aaddr2cx,void *aaddr)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned int,,zx_aaddr2cy,void *aaddr)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned int,,zx_aaddr2px,void *aaddr)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned int,,zx_aaddr2py,void *aaddr)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned char,*,zx_aaddr2saddr,void *aaddr)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned char,*,zx_aaddrcdown,void *aaddr)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned char,*,zx_aaddrcleft,void *aaddr)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned char,*,zx_aaddrcright,void *aaddr)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned char,*,zx_aaddrcup,void *aaddr)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned int,,zx_bitmask2px,int bitmask)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned char,*,zx_cy2aaddr,int row)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned char,*,zx_cy2saddr,int row)
__DPROTO(`b,c',`b,c',unsigned char,*,zx_cyx2aaddr,int row,int col)
__DPROTO(`b,c',`b,c',unsigned char,*,zx_cyx2saddr,int row,int col)
__DPROTO(`c,d,e',`c,d,e',unsigned int,,zx_px2bitmask,int x)
__DPROTO(`b,c',`b,c',unsigned char,*,zx_pxy2aaddr,int x,int y)
__DPROTO(`b,c',`b,c',unsigned char,*,zx_pxy2saddr,int x,int y)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned char,*,zx_py2aaddr,int y)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned char,*,zx_py2saddr,int y)
__DPROTO(`b,c,d,e,l',`b,c,d,e',unsigned char,*,zx_saddr2aaddr,void *saddr)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned int,,zx_saddr2cx,void *saddr)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned int,,zx_saddr2cy,void *saddr)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned int,,zx_saddr2px,void *saddr)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned int,,zx_saddr2py,void *saddr)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned char,*,zx_saddrcdown,void *saddr)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned char,*,zx_saddrcleft,void *saddr)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned char,*,zx_saddrcright,void *saddr)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned char,*,zx_saddrcup,void *saddr)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned char,*,zx_saddrpdown,void *saddr)
__DPROTO(`b,c',`b,c',unsigned char,*,zx_saddrpleft,void *saddr,int bitmask)
__DPROTO(`b,c',`b,c',unsigned char,*,zx_saddrpright,void *saddr,int bitmask)
__DPROTO(`b,c,d,e',`b,c,d,e',unsigned char,*,zx_saddrpup,void *saddr)

// graphics

__DPROTO(,,int,,zx_pattern_fill,int x,int y,void *pattern,unsigned int depth)

#endif
