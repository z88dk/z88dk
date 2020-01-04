/*
 *	Enterprise 64/128 graphics libraries
 *
 *	unplot(x,y)
 *
 *	Stefano Bodrato - March 2011
 *
 *	$Id: unplot.c,v 1.2 2016-04-23 08:20:39 dom Exp $
 */

#include <enterprise.h>
#include <graphics.h>


void unplot(int x, int y)
{
	esccmd_cmd='s'; // set beam off
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);

	esccmd_cmd='I';	// INK colour
	esccmd_x=0;
	exos_write_block(DEFAULT_VIDEO, 3, esccmd);

	esccmd_cmd='.'; // set beam style
	esccmd_x=0;	// PLOT
	exos_write_block(DEFAULT_VIDEO, 3, esccmd);

	esccmd_cmd='A'; // set beam position
	esccmd_x=x*4;
	esccmd_y=972-y*4;
	exos_write_block(DEFAULT_VIDEO, 6, esccmd);

	esccmd_cmd='S'; // set beam on
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);
	esccmd_cmd='s'; // set beam off
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);

//	esccmd_cmd='.'; // set beam style
//	esccmd_x=0;	// PLOT
//	exos_write_block(DEFAULT_VIDEO, 3, esccmd);
}
