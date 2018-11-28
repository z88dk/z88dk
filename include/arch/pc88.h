/*
 * Headerfile for NEC PC-8801 specific stuff
 *
 * $Id: pc88.h $
 */

#ifndef __PC88_H__
#define __PC88_H__

#include <sys/types.h>


// Misc functions

// Check if Ctrl-STOP is being pressed (1=if pressed, 0 if not)
extern bool_t __LIB__ pc88_break();

// Disable the CTRL-STOP effect (when a BASIC routine is being called)
extern void __LIB__ pc88_breakoff();

// Restore the CTRL-STOP break command
extern void __LIB__ pc88_breakon();

// Clear the keyboard buffer
extern void __LIB__ pc88_clearkey();

// TRUE if the current DIP switch settings are in V2 mode
extern bool_t __LIB__ pc88_v2mode();

// TRUE if the CPU speed is 8mhz
extern bool_t __LIB__ pc88_8mhz();

// Test the PC88 mode:  0=V1(S), 1=V1(H), 2=V2
extern int __LIB__ pc88_mode();

// Look for an FM chip. Address for FM if found, otherwise 0
extern int __LIB__ pc88_fm_addr();


// Display related functions

// Show/Hide the text cursor
extern void __LIB__ pc88_cursoron();
extern void __LIB__ pc88_cursoroff();

// Move the screen cursor to a given position
extern void __LIB__ pc88_locate(unsigned int x, unsigned int y) __smallc;

// Set text windows (40 or 80 columns, 20 or 25 rows)
extern void __LIB__ pc88_crtset(int width, int height) __smallc;

#endif
