/***************************************************************************
 *                                                                         *
 *	 FILE: LCD106x56.C                                                     *
 *   LCD Display Controller Interface Routines for use with Tian-ma        *
 *   106x56 Graphics module with onboard S6B0724X01-B0CY controller        *
 *                                                                         *
 *   Copyright (C) 2003 by Carousel Design Solutions                       *
 *                                                                         *
 *									Written by:                            *
 *									Michael J. Karas                       *
 *									Carousel Design Solutions              *
 *									4217 Grimes Ave South                  *
 *									Edina MN 55416                         *
 *									(952) 929-7537                         *
 *                                                                         *
 ***************************************************************************/

#include <drivers/lcd.h>
#include <drivers/lcdtarget.h>

#include <drivers/lcd.h>
#include <drivers/lcdtarget.h>

/*
**
** Updates area of the display. Writes data from display 
** RAM to the lcd display controller.
*/
void LCD_UpdateScreen( void ) {
	LCDTARGET_UpdateScreen();
}

