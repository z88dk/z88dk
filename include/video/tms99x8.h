/*
 * Headerfile for TMS99x8 routines
 *
 * Most of the functions are based on GFX,
 * a small graphics library by Rafael de Oliveira Jannone - (C) 2004
 *
 * $Id: msx.h $
 */

#ifndef __VIDEO_TMS99x8_H__
#define __VIDEO_TMS99x8_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <graphics.h>
#include <lib3d.h>


// Video related functions

// Video modes for set_mode
enum video_mode {
	mode_0 = 0,
	mode_1 = 1,
	mode_2 = 2,
	mode_3 = 3
};


// Set the screen mode (alternate method)
extern void __LIB__  vdp_set_mode(int mode) __z88dk_fastcall;

// Get the screen mode
extern int __LIB__ vdp_get_mode(void);

// Mangled (mode 1+2) not support on V9938
extern void __LIB__   vdp_set_mangled_mode(void);


// mangled mode chars

// Set char \a c shape, from \a form, at the given screen map \a place
extern void __LIB__ vdp_set_char_form(int c, void* form, unsigned int place) __smallc;

// Set char \a c attributes, from \a attr, at the given screen map \a place
extern void __LIB__ vdp_set_char_attr(int c, void *attr, unsigned int place) __smallc;

// Set char \a c with \a color, at the given screen map \a place
extern void __LIB__ vdp_set_char_color(int c, unsigned int color, unsigned int place) __smallc;

// Set char \a c shape, attributes and color, all in one
extern void __LIB__ vdp_set_char(int c, void* form, void *attr, unsigned int color, unsigned int place) __smallc;

// Mangled screen sections (3 maps)
enum screen_map {
    place_1 = 1,
    place_2 = 2,
    place_3 = 4,
    place_all = 255
};



// The addresses of the various tms9918 memory areas
extern const void *_tms9918_pattern_generator;
extern const void *_tms9918_pattern_name;
extern const void *_tms9918_colour_table;
extern const void *_tms9918_sprite_generator;
extern const void *_tms9918_sprite_table;


// VRAM read
extern int __LIB__     vdp_vpeek(int address) __z88dk_fastcall;

// VRAM block read
extern void __LIB__    vdp_vread(unsigned int source, char* dest, unsigned int count) __smallc;

// VRAM write
extern int  __LIB__    vdp_vpoke(int address, int value) __smallc;
extern int  __LIB__    vdp_vpoke_callee(int address, int value) __smallc __z88dk_callee;
#define vdp_vpoke(a,b) vdp_vpoke_callee(a,b)



// VRAM block write
extern void __LIB__ vdp_vwrite(void* source, unsigned int dest, unsigned int count) __smallc;


extern void __LIB__ vdp_vwrite_direct(void* source, unsigned int dest, unsigned int count) __smallc;

// VRAM fill
extern void __LIB__ vdp_vfill(unsigned int addr, unsigned int value, unsigned int count) __smallc;

// VRAM vertical fill
extern void __LIB__ vdp_vfill_v(unsigned int addr, unsigned int value, unsigned int count) __smallc;

// set \a value at a given VRAM address \a addr, merging bits (OR) with the existing value
extern void __LIB__ vdp_vmerge(unsigned int addr, unsigned int value) __smallc;

// screen 2 section bytecount
#define MODE2_MAX	6144

// screen 2 attributes section start address
#define MODE2_ATTR	8192

// screen 2 width in pixels
#define MODE2_WIDTH	256

// screen 2 height in pixels
#define MODE2_HEIGHT	192

// Set a VDP register with a value
extern void __LIB__ vdp_set_reg(int reg, int value) __smallc;


// Get a value from a VDP register
extern unsigned int __LIB__  vdp_get_reg(int) __z88dk_fastcall;

// Change the MSX color attributes
extern int __LIB__ vdp_color(int foreground, int background, int border) __smallc;
extern int __LIB__ vdp_set_border(int border) __z88dk_fastcall;

#define VDP_INK_TRANSPARENT    0x00
#define VDP_INK_BLACK          0x01
#define VDP_INK_MEDIUM_GREEN   0x02
#define VDP_INK_LIGHT_GREEN    0x03
#define VDP_INK_DARK_BLUE      0x04
#define VDP_INK_LIGHT_BLUE     0x05
#define VDP_INK_DARK_RED       0x06
#define VDP_INK_CYAN           0x07
#define VDP_INK_MEDIUM_RED     0x08
#define VDP_INK_LIGHT_RED      0x09
#define VDP_INK_DARK_YELLOW    0x0A
#define VDP_INK_LIGHT_YELLOW   0x0B
#define VDP_INK_DARK_GREEN     0x0C
#define VDP_INK_MAGENTA        0x0D
#define VDP_INK_GRAY           0x0E
#define VDP_INK_WHITE          0x0F

// Hardware sprite related functions

// Sprite modes
enum sprite_mode {
    sprite_default = 0,
    sprite_scaled = 1,
    sprite_large = 2
};

// Set the sprite mode
extern void __LIB__ vdp_set_sprite_mode(enum sprite_mode mode);



// Read the status register. 
//
// The parameter only has an effect on a V9938
extern int __LIB__ vdp_get_status(int status_register) __z88dk_fastcall;

// Set the sprite handle with the shape from data (small size)
extern void __LIB__ vdp_set_sprite_8(unsigned int handle, void* data) __smallc;

// Set the sprite handle, with the shape from data (big size)
extern void __LIB__ vdp_set_sprite_16(unsigned int handle, void* data) __smallc;

// Put the sprite with id and shape from handle, into the given position with color (small size)
extern void __LIB__ vdp_put_sprite_8(unsigned int id, int x, int y, unsigned int handle, unsigned int color) __smallc;
	
// Put the sprite with id and shape from handle, into the given position with color (big size)
extern void __LIB__ vdp_put_sprite_16(unsigned int id, int x, int y, unsigned int handle, unsigned int color) __smallc;

// Sprite data
typedef struct {
        unsigned char y;	///< Y position
        unsigned char x;	///< X position
        unsigned char handle;	///< internal vdp handle
        unsigned char color;	///< sprite color
} sprite_t;




// Detect the VRAM size (in KB)
extern int __LIB__ vdp_vram(void);

#include <interrupt.h>

// Blank the screen
extern void __LIB__ vdp_blank(void);
// Unblank the screen
extern void __LIB__ vdp_noblank(void);


// Surface (Blit) - Under Construction

/// represents a drawing surface
typedef struct {
    int width;
    int height;
    int type;
    union {
        unsigned char *ram;	///< ram adress, for off-screen surfaces
        unsigned int   vram;
    } data;
} surface_t;


enum surface_type {
    surface_ram,
    surface_vram
};

typedef struct {
    int x, y;
    int width, height;
} rect_t; 


/// create / destroy lookup tables aren't necessary: 
/// we use the existing sin/cos functions
#define create_lookup_tables(void) 
#define destroy_lookup_tables(void) 


// Not implemented
extern void __LIB__ vdp_blit(surface_t *source, surface_t *dest, rect_t *from, rect_t *to) __smallc;



extern void __LIB__ vdp_blit_ram_vram(unsigned char* source, unsigned int dest, unsigned int w, unsigned int h, int sjmp, int djmp) __smallc;
extern void __LIB__ vdp_blit_fill_vram(unsigned int dest, unsigned int value, unsigned int w, unsigned int h, int djmp) __smallc;


// Surface render 

/* Render an area in a specified buffer (in surface), with the specified dither intensity (0..11) */
extern void __LIB__ surface_stencil_render(surface_t *s, unsigned char *stencil, unsigned int intensity) __smallc;


// Draw a line on a surface
extern void __LIB__ surface_draw(surface_t *s, int x1, int y1, int x2, int y2) __smallc;

// Draw a circle on a surface
extern void __LIB__ surface_circle(surface_t *s, int x, int y, int radius, int skip) __smallc;

/// render object obj with flat-shading, requires a normalized source of light
//extern void __LIB__ object_render_flatshading(surface_t* s, object_t* obj, vector_t* pbuffer, int* low, int* high, vector_t* light);
extern void __LIB__ object_render_flatshading(surface_t* s, object_t* obj, vector_t* pbuffer, char* stencil, vector_t* light) __smallc;

/// render object obj with wireframes
extern void __LIB__ object_render_wireframe(surface_t* s, object_t* obj, vector_t* pbuffer) __smallc;


// Routines to handle F18a

// Returns 0,1 if f18a is available and unlocked
extern int __LIB__ vdp_f18a_present(void);

// (un)lock the F18a
// 
// These routines may corrupt the mode setting of the VDP, so call unlock prior
// to setting the screen mode
extern void __LIB__ vdp_f18a_lock(void);
extern void __LIB__ vdp_f18a_unlock(void);

#endif
