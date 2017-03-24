/*
 * Headerfile for ABC80 specific stuff
 *
 * $Id: abc80.h,v 1.3 2010-09-19 00:24:08 dom Exp $
 */

#ifndef __ABC80_H__
#define __ABC80_H__

#include <sys/compiler.h>
#include <sys/types.h>


/////////////
// GRAPHICS
/////////////

// Invert graphics display
extern void  __LIB__ abc_inv ();

// Set cursor shape
extern void  __LIB__ abc_cursor (int shape) __z88dk_fastcall;

#endif
