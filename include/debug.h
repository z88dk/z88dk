/*
 *      Debugging Routines
 *
 *	$Id: debug.h,v 1.4 2016-06-11 19:53:08 dom Exp $
 */

#ifndef __DEBUG_H__
#define __DEBUG_H__

#include <sys/compiler.h>


#define MYSELF = 0xFFFF

/* Disassembles a line; returns the address for the next line 
   if MYSELF, disassembles the current program location */
extern unsigned int __LIB__ disz80(unsigned int address, unsigned int lines) __smallc;

/* Dump on screen: if MYSELF address is given, displays #count stack words 
   and returns the current SP value (dump excluded), otherwise dumps memory 
   bytes and returns the address reached */
extern unsigned int __LIB__ dump(unsigned int address,unsigned int count) __smallc;

/* TRUE if Z80 supports undocumented instructions.
   Otherwise, FALSE (or, in worst cases.. crash !) */
extern int __LIB__ z80undoc(void);

/* TRUE if Z80 supports strange undocumented flag behaviours
   Otherwise, FALSE */
extern int __LIB__ z80genuine(void);

/* TRUE if Z80 supports strange undocumented flag behaviours
   Otherwise, FALSE */
extern int __LIB__ z80rabbit(void);

/* Z80 type detection (cross fingers!) 
	0 - Z80                  
	1 - Z180 / HD6140 / Other
	2 - Z280                 
	3 - Z380                 
	4 - R800
	5 - Rabbit Control Module
*/

extern int __LIB__ z80type(void);

#endif

