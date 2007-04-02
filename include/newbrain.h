/*
 *      Grundy Newbrain specific functions
 *
 *	$Id: newbrain.h,v 1.1 2007-04-02 17:01:52 stefano Exp $
 */

#ifndef __NEWBRAIN_H__
#define __NEWBRAIN_H__


/* 
 * LCD display handling (position from 0 to 15)
 * lowercase characters are not ASCII coded
 */

extern int __LIB__ fputc_lcd(int position, int character);


#endif
