/*
 *	Enterprise 64/128 graphics libraries
 *
 *	circle(int x, int y, int radius, int skip)
 *
 *	Stefano Bodrato - March 2011
 *
 *	$Id: circle.c,v 1.1 2011-04-01 06:50:45 stefano Exp $
 */

#include <enterprise.h>
#include <graphics.h>


int circle(int x, int y, int radius, int skip)
{
	esccmd_cmd='I';	// INK colour
	esccmd_x=0;
	exos_write_block(DEFAULT_VIDEO, 3, esccmd);

	esccmd_cmd='s'; // set beam off
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);

	esccmd_cmd='A'; // set beam position
	esccmd_x=x*4;
	esccmd_y=972-y*4;
	exos_write_block(DEFAULT_VIDEO, 6, esccmd);

	esccmd_cmd='S'; // set beam on
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);

	esccmd_cmd='I';	// INK colour
	esccmd_x=1;
	exos_write_block(DEFAULT_VIDEO, 3, esccmd);

	esccmd_cmd='E'; // Ellipse
	esccmd_x=radius*4;
	esccmd_y=radius*4;
	exos_write_block(DEFAULT_VIDEO, 6, esccmd);

	esccmd_cmd='s'; // set beam off
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);
}
