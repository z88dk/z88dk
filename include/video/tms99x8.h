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

// Get the screen mode
extern int __LIB__ msx_screenmode(void);

// Set the screen mode (alternate method)
extern void __LIB__  msx_set_mode(int mode) __z88dk_fastcall;

// Video modes for set_mode
enum video_mode {
	mode_0 = 0,
	mode_1 = 1,
	mode_2 = 2,
	mode_3 = 3
};

// The addresses of the various tms9918 memory areas
extern const void *_tms9918_pattern_generator;
extern const void *_tms9918_pattern_name;
extern const void *_tms9918_colour_table;
extern const void *_tms9918_sprite_generator;
extern const void *_tms9918_sprite_table;


// VRAM read
extern int __LIB__     msx_vpeek(int address) __z88dk_fastcall;
#define vpeek(addr)    msx_vpeek(addr)

// VRAM block read
extern void __LIB__ msx_vread(unsigned int source, char* dest, unsigned int count) __smallc;

// VRAM write
extern int  __LIB__               vpoke(int address, int value) __smallc;
extern int  __LIB__           msx_vpoke(int address, int value) __smallc;
extern int  __LIB__    msx_vpoke_callee(int address, int value) __smallc __z88dk_callee;
#define msx_vpoke(a,b) msx_vpoke_callee(a,b)
#define vpoke(a,b)     msx_vpoke_callee(a,b)


// VRAM block write
extern void __LIB__ msx_vwrite(void* source, unsigned int dest, unsigned int count) __smallc;
extern void __LIB__ msx_vwrite_direct(void* source, unsigned int dest, unsigned int count) __smallc;

// VRAM fill
extern void __LIB__ msx_vfill(unsigned int addr, unsigned int value, unsigned int count) __smallc;

// VRAM vertical fill
extern void __LIB__ msx_vfill_v(unsigned int addr, unsigned int value, unsigned int count) __smallc;

// set \a value at a given VRAM address \a addr, merging bits (OR) with the existing value
extern void __LIB__ msx_vmerge(unsigned int addr, unsigned int value) __smallc;

// screen 2 section bytecount
#define MODE2_MAX	6144

// screen 2 attributes section start address
#define MODE2_ATTR	8192

// screen 2 width in pixels
#define MODE2_WIDTH	256

// screen 2 height in pixels
#define MODE2_HEIGHT	192

// Set a VDP register with a value
extern void __LIB__ set_vdp_reg(int reg, int value) __smallc;
#define msx_set_vdp(reg, value) set_vdp_reg(reg, value)

// Get a value from a VDP register
extern unsigned int __LIB__  get_vdp_reg(int) __z88dk_fastcall;
#define msx_get_vdp(reg) get_vdp_reg(reg)

// Change the MSX color attributes
extern int __LIB__ msx_color(int foreground, int background, int border) __smallc;
extern int __LIB__ msx_set_border(int border) __z88dk_fastcall;

#define INK_TRANSPARENT    0x00
#undef INK_BLACK
#define INK_BLACK          0x01
#define INK_MEDIUM_GREEN   0x02
#define INK_LIGHT_GREEN    0x03
#define INK_DARK_BLUE      0x04
#define INK_LIGHT_BLUE     0x05
#define INK_DARK_RED       0x06
#undef INK_CYAN
#define INK_CYAN           0x07
#define INK_MEDIUM_RED     0x08
#define INK_LIGHT_RED      0x09
#define INK_DARK_YELLOW    0x0A
#define INK_LIGHT_YELLOW   0x0B
#define INK_DARK_GREEN     0x0C
#undef INK_MAGENTA
#define INK_MAGENTA        0x0D
#define INK_GRAY           0x0E
#undef INK_WHITE
#define INK_WHITE          0x0F

// Hardware sprite related functions

// Set the sprite mode
extern void __LIB__ msx_set_sprite_mode(unsigned int mode);

// Sprite modes
enum sprite_mode {
	sprite_default = 0,
	sprite_scaled = 1,
	sprite_large = 2
};

// Set the sprite handle with the shape from data (small size)
extern void __LIB__ msx_set_sprite_8(unsigned int handle, void* data) __smallc;

// Set the sprite handle, with the shape from data (big size)
extern void __LIB__ msx_set_sprite_16(unsigned int handle, void* data) __smallc;

// Put the sprite with id and shape from handle, into the given position with color (small size)
extern void __LIB__ msx_put_sprite_8(unsigned int id, int x, int y, unsigned int handle, unsigned int color) __smallc;
	
// Put the sprite with id and shape from handle, into the given position with color (big size)
extern void __LIB__ msx_put_sprite_16(unsigned int id, int x, int y, unsigned int handle, unsigned int color) __smallc;

// Sprite data
typedef struct {
        unsigned char y;	///< Y position
        unsigned char x;	///< X position
        unsigned char handle;	///< internal vdp handle
        unsigned char color;	///< sprite color
} sprite_t;




// Detect the VRAM size (in KB)
extern int __LIB__ msx_vram(void);

// Add a raster interrupt handler
extern void __LIB__ add_raster_int(void *);


// Surface (Blit) - Under Construction

/// represents a drawing surface
typedef struct {
        int width;
        int height;
	int type;
	union {
	        unsigned char* ram;	///< ram adress, for off-screen surfaces
		unsigned int vram;
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


extern void __LIB__ msx_blit(surface_t *source, surface_t *dest, rect_t *from, rect_t *to) __smallc;
extern void __LIB__ msx_blit_ram_vram(unsigned char* source, unsigned int dest, unsigned int w, unsigned int h, int sjmp, int djmp) __smallc;
extern void __LIB__ msx_blit_fill_vram(unsigned int dest, unsigned int value, unsigned int w, unsigned int h, int djmp) __smallc;


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


#endif
