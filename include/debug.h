/*
 *      Debugging Routines
 *
 *	$Id: debug.h,v 1.1 2002-06-10 10:14:07 stefano Exp $
 */

#ifndef __DEBUG_H__
#define __DEBUG_H__

#define MYSELF = 0xFFFF

/* Disassembles a line; returns the address for the next line 
   if MYSELF, disassembles the current program location */
extern unsigned int __LIB__ disz80(unsigned int address, unsigned int lines);

/* Dump on screen: if MYSELF address is given, displays #count stack words 
   and returns the current SP value (dump excluded), otherwise dumps memory 
   bytes and returns the address reached */
extern unsigned int __LIB__ dump(unsigned int address,unsigned int count);


#endif

