/*
 * Headerfile for Spectrum specific stuff
 *
 * $Id: spectrum.h,v 1.3 2001-05-01 13:58:43 dom Exp $
 */

#ifndef _SPECTRUM_H_
#define _SPECTRUM_H_

#ifdef PLUS3
/* If it's a +3 we want the dodos routine */
#pragma output NEEDplus3dodos
extern int __LIB__ findhand();
extern void __LIB__ freehand(int);
#endif


#endif


