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



// Video related functions

// Set the screen mode via BIOS (only valid BIOS modes)
extern void __LIB__  msx_screen(int mode) __z88dk_fastcall;

// Get the screen mode 
extern int __LIB__ msx_screenmode(void);

// Set screen to mangled mode (screen 1 + 2)
extern void __LIB__ msx_set_mangled_mode(void);

// Mangled screen sections (3 maps)
enum screen_map {
	place_1 = 1,
	place_2 = 2,
	place_3 = 4,
	place_all = 255
};

// mangled mode chars

// Set char \a c shape, from \a form, at the given screen map \a place
extern void __LIB__ msx_set_char_form(int c, void* form, unsigned int place) __smallc;

// Set char \a c attributes, from \a attr, at the given screen map \a place
extern void __LIB__ msx_set_char_attr(int c, void *attr, unsigned int place) __smallc;

// Set char \a c with \a color, at the given screen map \a place
extern void __LIB__ msx_set_char_color(int c, unsigned int color, unsigned int place) __smallc;

// Set char \a c shape, attributes and color, all in one
extern void __LIB__ msx_set_char(int c, void* form, void *attr, unsigned int color, unsigned int place) __smallc;



// Switch to text mode
extern void __LIB__ msx_text(void);

// Move the screen cursor to a given position
extern void __LIB__ msx_locate(unsigned int x, unsigned int y) __smallc;

// Disable screen
extern void __LIB__ msx_blank(void);

// Enable screen
extern void __LIB__ msx_noblank(void);

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
extern int  __LIB__  tape_save(char *name, size_t loadstart, void *start, size_t exec, size_t len) __smallc;
extern int  __LIB__  tape_save_callee(char *name, size_t loadstart, void *start, size_t exec, size_t len) __smallc __z88dk_callee;

#define tape_save(a,b,c,d,e) tape_save_callee(a,b,c,d,e)

// Custom data blocks transfer (no filename, just a short byte for "type" discrimination
extern int  __LIB__  tape_save_block(void *addr, size_t len, unsigned char type) __smallc;
extern int  __LIB__  tape_load_block(void *addr, size_t len, unsigned char type) __smallc;

// save_header is equivalent to save_block with a longer leading tone
extern int  __LIB__  msxtape_save_header(void *addr, size_t len) __smallc;
extern int  __LIB__  msxtape_save_block(void *addr, size_t len) __smallc;
extern int  __LIB__  msxtape_load_block(void *addr, size_t len) __smallc;

extern int  __LIB__  msxtape_save_header_callee(void *addr, size_t len) __smallc __z88dk_callee;
extern int  __LIB__  msxtape_save_block_callee(void *addr, size_t len) __smallc __z88dk_callee;
extern int  __LIB__  msxtape_load_block_callee(void *addr, size_t len) __smallc __z88dk_callee;

#define msxtape_save_header(a,b) msxtape_save_header_callee(a,b)
#define msxtape_save_block(a,b) msxtape_save_block_callee(a,b)
#define msxtape_load_block(a,b) msxtape_load_block_callee(a,b)


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
