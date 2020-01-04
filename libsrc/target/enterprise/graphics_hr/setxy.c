/*
 *	Enterprise 64/128 graphics libraries
 *
 *	setxy(x,y)
 *
 *	Stefano Bodrato - March 2011
 *
 *	$Id: setxy.c,v 1.2 2016-04-23 08:30:28 dom Exp $
 */

#include <enterprise.h>
#include <graphics.h>


void setxy(int x, int y)
{
	esccmd_cmd='s'; // set beam off
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);

	esccmd_cmd='A'; // set beam position
	esccmd_x=x*2;
	esccmd_y=972-y*4;
	exos_write_block(DEFAULT_VIDEO, 6, esccmd);
}
