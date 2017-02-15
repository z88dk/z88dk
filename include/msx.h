/*
 * Headerfile for MSX specific stuff
 *
 * Most of the functions are based on GFX,
 * a small graphics library by Rafael de Oliveira Jannone - (C) 2004
 *
 * $Id: msx.h,v 1.24 2016-06-16 20:54:11 dom Exp $
 */

#ifndef __MSX_H__
#define __MSX_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <lib3d.h>


// PSG register, sound, ...


// Video related functions

// Set the screen mode
extern void __LIB__  msx_screen(int mode) __z88dk_fastcall;

// Get the screen mode
extern int __LIB__ msx_screenmode();

// Set the screen mode (alternate method)
extern void __LIB__  msx_set_mode(int mode) __z88dk_fastcall;

// Video modes for set_mode

#ifdef __SVI__
#define vmode_defined 1
enum video_mode {
	mode_0 = 0x47,
	mode_1 = 0x4A,
	mode_2 = 0x4A,
	mode_3 = 0x4D
};
#endif

#ifdef __MSX__
#define vmode_defined 1
enum video_mode {
	mode_0 = 0x6C,
	mode_1 = 0x6F,
	mode_2 = 0x72,
	mode_3 = 0x75
};
#endif

#ifndef vmode_defined
enum video_mode {
	mode_0 = 0,
	mode_1 = 1,
	mode_2 = 2,
	mode_3 = 3
};
#endif

// Set screen to mangled mode (screen 1 + 2)
extern void __LIB__ msx_set_mangled_mode();

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



// VRAM read
extern int __LIB__  msx_vpeek(int address) __z88dk_fastcall;

// VRAM block read
extern void __LIB__ msx_vread(unsigned int source, char* dest, unsigned int count) __smallc;

// VRAM write
extern void __LIB__ msx_vpoke(int address, int value) __smallc;

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

// Set point at the given position on VRAM
//extern void __LIB__ msx_pset(int x, int y) __smallc;

// Switch to text mode
extern void __LIB__ msx_text();

// Move the screen cursor to a given position
extern void __LIB__ msx_locate(unsigned int x, unsigned int y) __smallc;

// Disable screen
extern void __LIB__ msx_blank();

// Enable screen
extern void __LIB__ msx_noblank();

// Change the MSX color attributes
extern int __LIB__ msx_color(int foreground, int background, int border) __smallc;

#define TRANSPARENT    0x00
#define BLACK          0x01
#define MEDIUM_GREEN   0x02
#define LIGHT_GREEN    0x03
#define DARK_BLUE      0x04
#define LIGHT_BLUE     0x05
#define DARK_RED       0x06
#define CYAN           0x07
#define MEDIUM_RED     0x08
#define LIGHT_RED      0x09
#define DARK_YELLOW    0x0A
#define LIGHT_YELLOW   0x0B
#define DARK_GREEN     0x0C
#define MAGENTA        0x0D
#define GRAY           0x0E
#define WHITE          0x0F


/************************************************************************/
/**********  Moved here from its original location in 'defs.h' **********/
/************************************************************************/

// screen mapping

//extern unsigned int map_pixel(unsigned int x, unsigned int y);

/// maps a block in the screen 2 model
//xdefine map_block(x,y)	((((y) & ~(7)) << 5) + ((x) & ~(7)))
extern int __LIB__ msx_map_m2_block(int x, int y) __smallc;
#define map_block(x,y)	msx_map_m2_block(x,y)

/// maps a pixel coordinate to a vram address
//xdefine map_pixel(x,y)	(map_block(x,y) + ((y) & 7))
extern int __LIB__ msx_map_m2_pixel(int x, int y) __smallc;
#define map_pixel(x,y)	msx_map_m2_pixel(x,y)

/*
	here is how it works:

	// map the row start (by row I mean a block of 8 lines)
	addr = (y & ~(7)) << 5;		// this is the same as (y / 8) * 256

	// then we aim for the column (column = block of 8 pixels)
	addr += (x & ~(7));	// this is the same as (x / 8) * 8

	// finally, aim for the remaining "sub-row" inside the row block
	addr += (y & 7);
*/

/// maps the subpixel (bit) inside the vram byte
#define map_subpixel(x)	(128 >> ((x) & 7))
//extern int __LIB__  msx_map_m2_subpixel(int x) __z88dk_fastcall;
//xdefine map_subpixel(x)	msx_map_m2_subpixel(x)

/************************************************************************/


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
#define create_lookup_tables() asm("\n");
#define destroy_lookup_tables() asm("\n");


extern void __LIB__ msx_blit(surface_t *source, surface_t *dest, rect_t *from, rect_t *to) __smallc;
extern void __LIB__ msx_blit_ram_vram(unsigned char* source, unsigned int dest, unsigned int w, unsigned int h, int sjmp, int djmp) __smallc;
extern void __LIB__ msx_blit_fill_vram(unsigned int dest, unsigned int value, unsigned int w, unsigned int h, int djmp) __smallc;

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
        unsigned int y;	///< Y position
        unsigned int x;	///< X position
        unsigned int handle;	///< internal vdp handle
        unsigned int color;	///< sprite color
} sprite_t;



// Joystick related stuff

// Get state of joystick number \a id
extern int  __LIB__ msx_get_stick(unsigned int id);

// Get state of joystick button (trigger) number \a id, true = pressed
extern int  __LIB__ msx_get_trigger(unsigned int id);

extern unsigned int st_dir[];

enum stick_direction {
	st_up = 1,
	st_right = 2,
	st_down = 4,
	st_left = 8
};




// Misc functions

// Check the current MSX type:
// 1: MSX 1
// 2: MSX 2
// 3: SVI-318
// 4: SVI-328
// 5: SVI-328 MKII
extern int __LIB__ msx_type();

// Detect the VRAM size (in KB)
extern int __LIB__ msx_vram();

// Check if the line printer is ready (1=ready, 0 if not)
extern int __LIB__ msx_lpt();
#define lpt_ready() msx_lpt()

// Check if Ctrl-STOP is being pressed (1=if pressed, 0 if not)
extern int __LIB__ msx_break();

// Clear the keyboard buffer
extern void __LIB__ msx_clearkey();

// Disable the CTRL-STOP effect (when a BASIC routine is being called)
extern void __LIB__ msx_breakoff();

// Restore the CTRL-STOP break command
extern void __LIB__ msx_breakon();



// Advanced line drawing functionalities

/************************************************************************/
/**********  Moved here from its original location in 'line.c' **********/
/************************************************************************/

#define LINE_T_MEMBERS \
	int dinc1, dinc2;	\
	char xinc1, xinc2;	\
	char yinc1, yinc2;	\
	int numpixels;		\
	int d

typedef struct {
	LINE_T_MEMBERS;
} line_t;

/*
 NOTE: the REVERSE_LINE_T_MEMBERS trick seems not to be necessary with z88dk **
*/

/************************************************************************/
/************************************************************************/


// set point at the given position on vram
//xdefine pset(x,y) msx_pset(x,y)
#define pset(x,y) plot(x,y)

// Draw a line on a surface
#define surface_line(s,x1,y1,x2,y2) surface_draw(s,x1,y1,x2,y2)

/* Render an area in a specified buffer (in surface), with the specified dither intensity (0..11) */
extern void __LIB__ surface_stencil_render(surface_t *s, unsigned char *stencil, unsigned int intensity) __smallc;

// Draw a line on video
#define line(x1,y1,x2,y2) draw(x1,y1,x2,y2) 

// Draw a line on video (was a slow and smaller version, now it is the same)
#define line_slow(x1,y1,x2,y2) draw(x1,y1,x2,y2) 

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
