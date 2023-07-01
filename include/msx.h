/*
 * Headerfile for MSX specific stuff
 *
 * Most of the functions are based on GFX,
 * a small graphics library by Rafael de Oliveira Jannone - (C) 2004
 *
 * $Id: msx.h $
 */

#ifndef __MSX_H__
#define __MSX_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <lib3d.h>
#include <sys/types.h>

// Include all the VDP routines
#include <video/tms99x8.h>

// Include some aliases for old MSX programs
#include <msx/defs.h>


// And now alias all the TMS99x8 routines into msx_ variants
#define msx_set_mode(mode)                     vdp_set_mode(mode)
#define msx_set_mangled_mode()                 vdp_set_mangled_mode()
#define msx_set_char(c,form,attr,color,place)  vdp_set_char(c,form,attr,color,place)
#define msx_set_char_form(c,form,place)        vdp_set_char_form(c,form,place)
#define msx_set_char_attr(c,attr,place)        vdp_set_char_attr(c,attr,place)
#define msx_set_char_color(c,color,place)      vdp_set_char_color(c,color,place) 
#define msx_screenmode()                       vdp_get_mode()
#define msx_vpoke(addr, val)                   vdp_vpoke(addr, val)
#define msx_vpeek(addr)                        vdp_vpeek(addr)
#define msx_vread(source,dest,count)           vdp_vread(source,dest,count)
#define msx_vwrite(source,dest,count)          vdp_vwrite(source,dest,count)
#define msx_vwrite_direct(source,dest,count)   vdp_write_direct(source,dest,count)
#define msx_vram()                             vdp_vram()
#define msx_fill(addr,value,count)             vdp_vfill(addr,value,count)
#define msx_fill_v(addr,value,count)           vdp_vfill_v(addr,value,count)
#define msx_vmerge(addr,value)                 vdp_vmerge(addr,value)
#define msx_set_vdp(reg, value)                vdp_set_vdp(reg, value)
#define msx_get_vdp(reg)                       vdp_get_reg(reg)
#define msx_color(fgcol, bgcol, border)        vdp_color(fgcol, bgcol, border)
#define msx_set_border(colour)                 vdp_set_border(colour)
#define msx_set_sprite_mode(mode)              vdp_set_sprite_mode(mode)
#define msx_set_sprite_8(handle,data)          vdp_set_sprite_8(handle,data)
#define msx_set_sprite_16(handle,data)         vdp_set_sprite_16(handle,data)
#define msx_put_sprite_8(id,x,y,handle,color)  vdp_put_sprite_8(id,x,y,handle,color)
#define msx_put_sprite_16(id,x,y,handle,color) vdp_put_sprite_16(id,x,y,handle,color)

// Disable screen
#define msx_blank()                            vdp_blank()

// Enable screen
#define msx_noblank()                          vdp_noblank()

#define msx_blit_ram_vram(source, dest, w, h, sjmp, djmp)   vdp_blit_ram_vram(source, dest, w, h, jmp, djmp)
#define msx_blit_vram_ram(dest, value, w, h, djmp)          vdp_blit_vram_ram(dest, value, w, h, djmp)

// Video related functions

// Set the screen mode via BIOS (only valid BIOS modes)
extern void __LIB__  msx_screen(int mode) __z88dk_fastcall;

// Switch to text mode
extern void __LIB__ msx_text(void);

// Move the screen cursor to a given position
__ZPROTO2(void,,msx_locate,unsigned int,x,unsigned int,y)


// Joystick related stuff - only for +svi, +msx using BIOS

// Get state of joystick number \a id
extern int  __LIB__ msx_get_stick(unsigned int id) __z88dk_fastcall;

// Get state of joystick button (trigger) number \a id, true = pressed
extern bool_t  __LIB__ msx_get_trigger(unsigned int id) __z88dk_fastcall;

extern unsigned int st_dir[];

enum stick_direction {
       st_up = 1,
       st_right = 2,
       st_down = 4,
       st_left = 8
};




////////////
// TAPE I/O
////////////

// leading bytes (type is repeated 10 times)
#define HDR_BASIC  0xD3    // The program body follows in a next block, terminated by 00H x 7
#define HDR_ASCII  0xEA    // 256 bytes chuncks, CTRL+Z (EOF) is included in data
#define HDR_CODE   0x0D    // Must have 6 extra bytes on top: addr, end_addr, exec.

// Standard filename header
struct msxtapehdr {
   char          leader[10];    // leading bytes (leading type repeated x 10)
   char          name[6];
};

struct msxcodehdr {
   int           addr;
   int           end_addr;
   int           exec;
};

// Standard BSAVE tape format
__ZPROTO5(int,,tape_save,char *,name,size_t,loadstart,void *,start,size_t,exec,size_t,len)

#ifndef __STDC_ABI_ONLY
extern int  __LIB__  tape_save_callee(char *name, size_t loadstart, void *start, size_t exec, size_t len) __smallc __z88dk_callee;
#define tape_save(a,b,c,d,e) tape_save_callee(a,b,c,d,e)
#endif

// Custom data blocks transfer (no filename, just a short byte for "type" discrimination
__ZPROTO3(int,,tape_save_block,void *,addr,size_t,len,unsigned char,type)
__ZPROTO3(int,,tape_load_block,void *,addr,size_t,len,unsigned char,type)


// save_header is equivalent to save_block with a longer leading tone
__ZPROTO2(int,,msxtape_save_header,void *,addr,size_t,len)
__ZPROTO2(int,,msxtape_save_block,void *,addr,size_t,len)
__ZPROTO2(int,,msxtape_load_block,void *,addr,size_t,len)


#ifndef __STDC_ABI_ONLY
extern int  __LIB__  msxtape_save_header_callee(void *addr, size_t len) __smallc __z88dk_callee;
extern int  __LIB__  msxtape_save_block_callee(void *addr, size_t len) __smallc __z88dk_callee;
extern int  __LIB__  msxtape_load_block_callee(void *addr, size_t len) __smallc __z88dk_callee;

#define msxtape_save_header(a,b) msxtape_save_header_callee(a,b)
#define msxtape_save_block(a,b) msxtape_save_block_callee(a,b)
#define msxtape_load_block(a,b) msxtape_load_block_callee(a,b)
#endif


// Low level tape control
// WARNING: the output sequences must avoid gaps !
extern int __LIB__  msxtape_rd_opn(void);
extern int __LIB__  msxtape_wr_opn(void);
extern int __LIB__  msxtape_wr_opn_hdr(void);
extern int __LIB__  msxtape_rd_cls(void);
extern int __LIB__  msxtape_wr_cls(void);
extern int __LIB__  msxtape_send_byte(unsigned char msxbyte) __z88dk_fastcall;
extern int __LIB__  msxtape_get_byte(void);




//////////////////
// Misc functions
//////////////////

// Check the current MSX type:
// 1: MSX 1
// 2: MSX 2
// 3: SVI-318
// 4: SVI-328
// 5: SVI-328 MKII
extern int __LIB__ msx_type(void);

// MSX2 version number
// 0 = MSX 1
// 1 = MSX 2
// 2 = MSX 2+
// 3 = MSX turbo R
static __at(0x2d) unsigned char MSX2_SUBTYPE;


// Check if the line printer is ready (1=ready, 0 if not)
extern bool_t __LIB__ msx_lpt(void);
#define lpt_ready() msx_lpt()

// Check if Ctrl-STOP is being pressed (1=if pressed, 0 if not)
extern bool_t __LIB__ msx_break(void);

// Clear the keyboard buffer
extern void __LIB__ msx_clearkey(void);

// Disable the CTRL-STOP effect (when a BASIC routine is being called)
extern void __LIB__ msx_breakoff(void);

// Restore the CTRL-STOP break command
extern void __LIB__ msx_breakon(void);

#endif
