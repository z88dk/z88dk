/*
 *      Grundy Newbrain specific functions
 *
 *	$Id: newbrain.h,v 1.2 2007-05-14 12:40:46 stefano Exp $
 */

#ifndef __NEWBRAIN_H__
#define __NEWBRAIN_H__


/* pokeing to location 19 changes the default I/O device for LOAD and SAVE */

#define DEVICE_TAPE	1
#define DEVICE_TAPE2	2
#define DEVICE_PARALLEL	8
#define DEVICE_SERIAL	9
#define DEVICE_DISK	12


/* 
 * LCD display handling (position from 0 to 15)
 * lowercase characters are not ASCII coded
 */

extern void __LIB__ fputc_lcd(int position, int character);

/* 
 * Check if break has been pressed
 */

extern int __LIB__ break_status();

/* 
 * warm_reset: jump to BASIC entry
 */

extern void __LIB__ warm_reset();

#endif
