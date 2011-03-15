/*
 *	Enterprise 64/128 libraries
 *
 *	extern int __LIB__ exos_set_vmode(unsigned char mode, unsigned char color, unsigned int x_size, unsigned int y_size);
 *
 *	Stefano Bodrato - March 2011
 *
 *	$Id: exos_set_vmode.c,v 1.2 2011-03-15 14:34:08 stefano Exp $
 */

#include <enterprise.h>


void exos_set_vmode(unsigned char mode, unsigned char color, unsigned char x_size, unsigned char y_size)
{

exos_close_channel(0x66);

set_exos_variable(EV_MODE_VID,mode);
set_exos_variable(EV_COLR_VID,color);
set_exos_variable(EV_X_SIZ_VID,x_size);
set_exos_variable(EV_Y_SIZ_VID,y_size);

exos_open_channel(0x66,DEV_VIDEO);

exos_reset_font(0x66);

exos_display_page(0x66, 1, y_size, 1);

}
