/****************************************************************
 *		library.h					*
 *			Header for Rex addin program.		*
 *								*
 ****************************************************************/

#ifndef _LIB_H_
#define _LIB_H_


#pragma -shareoffset=12
#pragma -shared-file


#define getFuncID() asm("ld\tix,10\nadd\tix,sp\nld\tl,(ix+0)\nld\th,(ix+1)")

#endif
