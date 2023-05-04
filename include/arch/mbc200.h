#ifndef __ARCH_MBC200_H__
#define __ARCH_MBC200_H__

//////////////////////////
//   Video interface
//////////////////////////

// Send a byte to the video section
extern void __LIB__ mbc_sendchar(int chr)  __z88dk_fastcall;

// CLS effect (text characters shifted right)
extern void __LIB__ mbc_fade();

// Get a byte from the video section
extern int __LIB__ mbc_getbyte();

// Receive a little-endian word from the video section
extern unsigned int __LIB__ mbc_getword();

// Set console cursor position, top-left=(0;0)
extern int  __LIB__    mbc_setcursorpos(int x, int y) __smallc;
extern int  __LIB__    mbc_setcursorpos_callee(int x, int y) __smallc __z88dk_callee;
#define mbc_setcursorpos(a,b)     mbc_setcursorpos_callee(a,b)


/* Set a single register in the 6845 CRTC
    
	Preset values:

	00 - $00 Horiz. total characters
	01 - $00 Horiz. displayed characters per line
	02 - $00 Horiz. synch position
	03 - $20 Horiz. synch width in characters
	04 - $03 Vert. total lines
	05 - $02 Vert. total adjust (scan lines)
	06 - $64 Vert. displayed rows
	07 - $64 Vert. synch position (character rows)
	08 - $00 Interlace mode
	09 - $68 Maximum scan line address
	0A - $4B Cursor start (scan line)
	0B - $51 Cursor end (scan line)
	0C - $50 Start address (MSB)
	0D - $65 Start address (LSB)
	0E -     Cursor address (MSB) (read/write)
	0F -     Cursor address (LSB) (read/write)
	10 -     Light pen (MSB)   (read only)
	11 -     Light pen (LSB)   (read only)
*/

extern int  __LIB__ set_crtc_reg(unsigned char register, unsigned char value) __smallc;


  
#endif
