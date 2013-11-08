/*
 * Header file for Sharp X1 specific stuff
 *
 * $Id: x1.h,v 1.1 2013-11-08 09:10:53 stefano Exp $
 *
 */

#ifndef __X1_H__
#define __X1_H__

#define SUBCPU_TAPE_STATUS    0xea
#define SUBCPU_TAPE_SENSOR    0xeb
#define SUBCPU_SET_CALENDAR   0xec
#define SUBCPU_GET_CALENDAR   0xed
#define SUBCPU_SET_CLOCK      0xee
#define SUBCPU_GET_CLOCK      0xef

// Wait the SUB CPU to be ready
extern void wait_sub_cpu();

// Send a command to the SUB-CPU
extern void __FASTCALL__ __LIB__ subcpu_command(int command);

// Get a byte from the SUB-CPU
extern int __LIB__ subcpu_get();

// Get a byte parameter to the SUB-CPU
extern void __FASTCALL__ __LIB__ subcpu_set(int command);

#endif
