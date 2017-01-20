/*
 *      TIKI-100 specific functions
 *
 *		Changelog:
 *
 *		   1.3 FrodeM
 *		   * Added vertical scrolling library
 *
 *
 *      $Id: tiki100.h,v 1.5 2016-06-11 19:53:08 dom Exp $
 */

#ifndef __TIKI100_H__
#define __TIKI100_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <psg.h>


/* If in CP/M mode (the only existing mode, ATM), exclude the global definitions for GFX lib */
#pragma output nogfxglobals



/* 
	Set graphics mode 
		0 = Freeze dot-clock (one-pixel display)
		1 = BW mode (1024x256x2)
		2 = 512x256x4
		3 = 256x256x16
*/
extern void __LIB__  gr_defmod(int mode) __z88dk_fastcall;

/* 
	Set color palette ('len' must be a fraction of 16)
	The single color entries must be encoded as follows:
		Bit 5-7: Red
		Bit 2-4: Green
		Bit 0-1: Blue
*/
extern void __LIB__ gr_setpalette(int len, char *palette) __smallc;

/* 
	Hardcopy
*/
extern void __LIB__ gr_hardcopy();

/* 
	Scrolling

	gr_vscroll scrolls the display up or down a number of lines (signed int)
	gr_vscroll_abs puts the display at a given vertical position

*/
extern void __LIB__  gr_vscroll(int lines) __z88dk_fastcall;
extern void __LIB__  gr_vscroll_abs(int line) __z88dk_fastcall;

#endif
