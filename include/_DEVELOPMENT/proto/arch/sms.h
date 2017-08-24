include(__link__.m4)

#ifndef __ARCH_SMS_H__
#define __ARCH_SMS_H__

#include <arch.h>
#include <rect.h>

// GLOBAL VARIABLES

extern unsigned char GLOBAL_SMS_VDP_R0;
extern unsigned char GLOBAL_SMS_VDP_R1;

extern unsigned int GLOBAL_SMS_VRAM_SCREEN_MAP_ADDRESS;
extern unsigned int GLOBAL_SMS_VRAM_SPRITE_ATTRIBUTE_TABLE_ADDRESS;
extern unsigned int GLOBAL_SMS_VRAM_SPRITE_PATTERN_BASE_ADDRESS;

// IO MAPPED REGISTERS

#ifdef __CLANG

extern unsigned char IO_MEMORY_ENABLES;
extern unsigned char IO_JOYSTICK_PORT_CONTROL;
extern unsigned char IO_GUN_SPOT_VERTICAL;
extern unsigned char IO_GUN_SPOT_HORIZONTAL;
extern unsigned char IO_PSG;
extern unsigned char IO_VDP_DATA;
extern unsigned char IO_VDP_COMMAND;
extern unsigned char IO_VDP_STATUS;
extern unsigned char IO_JOYSTICK_READ_L;
extern unsigned char IO_JOYSTICK_READ_H;

extern unsigned char IO_3E;
extern unsigned char IO_3F;
extern unsigned char IO_7E;
extern unsigned char IO_7F;
extern unsigned char IO_BE;
extern unsigned char IO_BF;
extern unsigned char IO_DC;
extern unsigned char IO_DD;

#else

__sfr __at __IO_MEMORY_ENABLES         IO_MEMORY_ENABLES;
__sfr __at __IO_JOYSTICK_PORT_CONTROL  IO_JOYSTICK_PORT_CONTROL;
__sfr __at __IO_GUN_SPOT_VERTICAL      IO_GUN_SPOT_VERTICAL;
__sfr __at __IO_GUN_SPOT_HORIZONTAL    IO_GUN_SPOT_HORIZONTAL;
__sfr __at __IO_PSG                    IO_PSG;
__sfr __at __IO_VDP_DATA               IO_VDP_DATA;
__sfr __at __IO_VDP_COMMAND            IO_VDP_CONTROL;  // same port
__sfr __at __IO_VDP_COMMAND            IO_VDP_COMMAND;  // same port
__sfr __at __IO_VDP_STATUS             IO_VDP_STATUS;   // same port
__sfr __at __IO_JOYSTICK_READ_L        IO_JOYSTICK_READ_L;
__sfr __at __IO_JOYSTICK_READ_H        IO_JOYSTICK_READ_H;

__sfr __at 0x3e IO_3E;
__sfr __at 0x3f IO_3F;
__sfr __at 0x7e IO_7E;
__sfr __at 0x7f IO_7F;
__sfr __at 0xbe IO_BE;
__sfr __at 0xbf IO_BF;
__sfr __at 0xdc IO_DC;
__sfr __at 0xdd IO_DD;

#endif

// MEMORY MAPPED REGISTERS

extern volatile unsigned char MM_FRAME2_CONTROL_REGISTER;
extern volatile unsigned char MM_FRAME1_CONTROL_REGISTER;
extern volatile unsigned char MM_FRAME0_CONTROL_REGISTER;
extern volatile unsigned char MM_FRAME2_RAM_CONTROL_REGISTER;

extern volatile unsigned char MM_FFFF;
extern volatile unsigned char MM_FFFE;
extern volatile unsigned char MM_FFFD;
extern volatile unsigned char MM_FFFC;

// VRAM ADDRESS ASSIGNMENT

#define SMS_VRAM_SCREEN_MAP_ADDRESS              __SMS_VRAM_SCREEN_MAP_ADDRESS
#define SMS_VRAM_SPRITE_ATTRIBUTE_TABLE_ADDRESS  __SMS_VRAM_SPRITE_ATTRIBUTE_TABLE_ADDRESS
#define SMS_VRAM_SPRITE_PATTERN_BASE_ADDRESS     __SMS_VRAM_SPRITE_PATTERN_BASE_ADDRESS

// MISCELLANEOUS

__DPROTO(`b,c,d,e,h,l,iyl,iyh',`b,c,d,e,iyl,iyh',void,,sms_border,unsigned char color)
__DPROTO(`d,e,iyl,iyh',`d,e,iyl,iyh',unsigned int,,sms_cxy2saddr,unsigned char x, unsigned char y)

__DPROTO(`iyl,iyh',`iyl,iyh',void,*,sms_copy_font_8x8_to_vram,void *font,unsigned char num,unsigned char bgnd_color,unsigned char fgnd_color)

__DPROTO(,,void,,sms_cls_wc,struct r_Rect8 *r,unsigned int background_char)
__DPROTO(,,void,,sms_scroll_wc_up,struct r_Rect8 *r,unsigned char rows,unsigned int background_char)

__DPROTO(,,void,,sms_tiles_clear_area,struct r_Rect8 *r,unsigned int background_char)
__DPROTO(,,void,,sms_tiles_get_area,struct r_Rect8 *r,void *dst)
__DPROTO(,,void,,sms_tiles_put_area,struct r_Rect8 *r,void *src)

// VDP

#define VDP_FEATURE_SHIFT_SPRITES      __VDP_FEATURE_SHIFT_SPRITES
#define VDP_FEATURE_LINE_INTERRUPT     __VDP_FEATURE_LINE_INTERRUPT
#define VDP_FEATURE_LEFT_COLUMN_BLANK  __VDP_FEATURE_LEFT_COLUMN_BLANK
#define VDP_FEATURE_HSCROLL_INHIBIT    __VDP_FEATURE_HSCROLL_INHIBIT
#define VDP_FEATURE_VSCROLL_INHIBIT    __VDP_FEATURE_VSCROLL_INHIBIT

#define VDP_FEATURE_WIDE_SPRITES       __VDP_FEATURE_WIDE_SPRITES
#define VDP_FEATURE_VBLANK_INTERRUPT   __VDP_FEATURE_VBLANK_INTERRUPT
#define VDP_FEATURE_SHOW_DISPLAY       __VDP_FEATURE_SHOW_DISPLAY

#define sms_display_off()  sms_vdp_feature_disable(__VDP_FEATURE_SHOW_DISPLAY)
#define sms_display_on()   sms_vdp_feature_enable(__VDP_FEATURE_SHOW_DISPLAY)

__DPROTO(`b,c,iyl,iyh',`b,c,iyl,iyh',unsigned int,,sms_vdp_feature_disable,unsigned int features)
__DPROTO(`b,c,iyl,iyh',`b,c,iyl,iyh',unsigned int,,sms_vdp_feature_enable,unsigned int features)

__DPROTO(`c,d,e,iyl,iyh',`c,d,e,iyl,iyh',void,,sms_vdp_init,void *vdp_reg_array)

__DPROTO(`b,c,d,e,h,l,iyl,iyh',`b,c,d,e,iyl,iyh',void,,sms_vdp_set_read_address,unsigned int addr)
__DPROTO(`b,c,iyl,iyh',`b,c,iyl,iyh',void,,sms_vdp_set_write_address,unsigned int addr)

// VRAM <-> MEMORY COPY OPERATIONS

__DPROTO(`iyl,iyh',`iyl,iyh',void,,sms_copy_mem_to_vram,void *src,unsigned int n)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,sms_copy_mem_to_vram_unsafe,void *src,unsigned int n)

__DPROTO(`iyl,iyh',`iyl,iyh',void,,sms_copy_vram_to_mem,void *dst,unsigned int n)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,sms_copy_vram_to_mem_unsafe,void *dst,unsigned int n)

__DPROTO(`d,e,iyl,iyh',`d,e,iyl,iyh',void,,sms_set_vram,unsigned char c,unsigned int n)
__DPROTO(`d,e,iyl,iyh',`d,e,iyl,iyh',void,,sms_set_vram_unsafe,unsigned char c,unsigned int n)

__DPROTO(`iyl,iyh',`iyl,iyh',void,,sms_setw_vram,unsigned int c,unsigned int n)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,sms_setw_vram_unsafe,unsigned int c,unsigned int n)

__DPROTO(`iyl,iyh',`iyl,iyh',unsigned int,,sms_memcpy_mem_to_cram,unsigned int cdst,void *src,unsigned int n)
__DPROTO(`iyl,iyh',`iyl,iyh',unsigned int,,sms_memcpy_mem_to_cram_unsafe,unsigned int cdst,void *src,unsigned int n)

__DPROTO(`iyl,iyh',`iyl,iyh',unsigned int,,sms_memcpy_mem_to_vram,unsigned int dst,void *src,unsigned int n)
__DPROTO(`iyl,iyh',`iyl,iyh',unsigned int,,sms_memcpy_mem_to_vram_unsafe,unsigned int dst,void *src,unsigned int n)

__DPROTO(`iyl,iyh',`iyl,iyh',unsigned int,,sms_memcpy_vram_to_mem,void *dst,unsigned int src,unsigned int n)
__DPROTO(`iyl,iyh',`iyl,iyh',unsigned int,,sms_memcpy_vram_to_mem_unsafe,void *dst,unsigned int src,unsigned int n)

__DPROTO(`iyl,iyh',`iyl,iyh',unsigned int,,sms_memcpy_vram_to_vram,unsigned int dst,unsigned int src,unsigned int n)
__DPROTO(`iyl,iyh',`iyl,iyh',unsigned int,,sms_memcpy_vram_to_vram_unsafe,unsigned int dst,unsigned int src,unsigned int n)

__DPROTO(`iyl,iyh',`iyl,iyh',unsigned int,,sms_memset_vram,unsigned int dst,unsigned char c,unsigned int n)
__DPROTO(`iyl,iyh',`iyl,iyh',unsigned int,,sms_memset_vram_unsafe,unsigned int dst,unsigned char c,unsigned int n)

__DPROTO(`iyl,iyh',`iyl,iyh',unsigned int,,sms_memsetw_vram,unsigned int dst,unsigned int c,unsigned int n)
__DPROTO(`iyl,iyh',`iyl,iyh',unsigned int,,sms_memsetw_vram_unsafe,unsigned int dst,unsigned int c,unsigned int n)

#endif
