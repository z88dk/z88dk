#ifndef __ARCH_SAM_H__
#define __ARCH_SAM_H__

#include <sys/compiler.h>

// Joystick functions
extern unsigned int  __LIB__ in_Joystick1(void);
extern unsigned int  __LIB__ in_Joystick2(void);

// Mouse (the SAM Coupe mouse interface), as in input.h: buttons are 00000MRL
// active high.  The position is 0..255 by 0..191 (IN_MAX_X, IN_MAX_Y).
// in_MouseSAMInit returns non-zero if a mouse answered: with none,
// in_MouseSAM returns no buttons and leaves the position alone (it looks for
// one again now and then), so a program can fall back to the keyboard.
// The state is in the library's bss: it must be mapped when these are called.
extern int  __LIB__ in_MouseSAMInit(void);
extern int  __LIB__ in_MouseSAMPresent(void);
extern void __LIB__ in_MouseSAM(unsigned char *buttons, unsigned int *xcoord, unsigned int *ycoord) __smallc;
extern void __LIB__ in_MouseSAMSetPos(unsigned int xcoord, unsigned int ycoord) __smallc;

extern void __LIB__ in_MouseSAM_callee(unsigned char *buttons, unsigned int *xcoord, unsigned int *ycoord) __smallc __z88dk_callee;
extern void __LIB__ in_MouseSAMSetPos_callee(unsigned int xcoord, unsigned int ycoord) __smallc __z88dk_callee;

#define in_MouseSAM(a,b,c)     in_MouseSAM_callee(a,b,c)
#define in_MouseSAMSetPos(a,b) in_MouseSAMSetPos_callee(a,b)

// Hardware ports
__sfr __at 0xfa IO_LMPR;       // Bottom 32k 
__sfr __at 0xfb IO_HMPR;       // Top 32k
__sfr __at 0xfc IO_VMPR;       // Video settings

__sfr __at 0xf8 IO_CLUT;       // Colour lookup table

__sfr __at 0xf9 IO_INTERRUPT;  // Interrupt (write)
__sfr __at 0xf9 IO_STATUS;     // System status (reaD)


__sfr __at 0xfe IO_BORDER;     // Border control (write)

__sfr __at 0xfe IO_KEYBOARD;   // Keyboard (read)

__sfr __at 0xff IO_SOUND_DATA; // Data port for SAA1099
__sfr __banked __at 0x1ff IO_SOUND_ADDRESS; // Address port for SAA1099

// Read only palette mirror
extern unsigned char *SAM_PALETTE_VALUES;

// Set the entire palette in one go
extern void __LIB__ sam_load_palette(unsigned char *data);

// Set an individual palette pen
extern void __LIB__ sam_set_palette(unsigned char index, unsigned char value) __smallc;

// Switch screenmode
extern void __LIB__ sam_set_screenmode(int mode);

// Configure FATPIX in mode 3
extern void __LIB__ sam_set_fatpix(int enabled);

// Add an interrupt handler on FRAME interrupt

#include <interrupt.h>

// Add and remove line ISR handlers. Setting up the line
// the interrupt is executed can be achieved as follows:
//
// IO_INTERRUPT = n;
//
// Where n is the line number
extern void __LIB__ sam_install_line_isr(isr_t handler);
extern void __LIB__ sam_uninstall_line_isr(isr_t handler);

#endif
