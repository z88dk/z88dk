/*
 *	Enterprise 64/128 libraries
 *
 *	extern int __LIB__ exos_set_vmode(unsigned char mode, unsigned char color, unsigned int x_size, unsigned int y_size);
 *
 *	Stefano Bodrato - March 2011
 *
 *	$Id: exos_set_vmode.c,v 1.4 2016-06-24 05:22:42 dom Exp $
 */

#include <enterprise.h>


void exos_set_vmode(int mode, int color, int x_size, int y_size)
{

exos_close_channel(DEFAULT_VIDEO);

set_exos_variable(EV_MODE_VID,mode);
set_exos_variable(EV_COLR_VID,color);
set_exos_variable(EV_X_SIZ_VID,x_size);
set_exos_variable(EV_Y_SIZ_VID,y_size);

exos_open_channel(DEFAULT_VIDEO,DEV_VIDEO);

exos_reset_font(DEFAULT_VIDEO);

exos_display_page(DEFAULT_VIDEO, 1, y_size, 1);

}
