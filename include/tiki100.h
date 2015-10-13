/*
 *      TIKI-100 specific functions
 *
 *      $Id: tiki100.h,v 1.1 2015-10-13 19:56:26 stefano Exp $
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
		0 = standard mode
		1 = BW mode (960x256x2)
		2 = 480x256x4
		3 = 240x256x16
*/
extern void __LIB__ __FASTCALL__ gr_defmod(int mode);

/* 
	Set color palette (len must be a fraction of 16)
*/
extern void __LIB__ gr_setpalette(int len, char *palette);

/* 
	Hardcopy
*/
extern void __LIB__ gr_hardcopy();

#endif

