/*
 * Headerfile for NEC PC-8801 specific stuff
 *
 * $Id: pc88.h $
 */

#ifndef __PC88_H__
#define __PC88_H__


// Misc functions

// Check if Ctrl-STOP is being pressed (1=if pressed, 0 if not)
extern int __LIB__ pc88_break();

// Clear the keyboard buffer
extern void __LIB__ pc88_clearkey();



#endif
