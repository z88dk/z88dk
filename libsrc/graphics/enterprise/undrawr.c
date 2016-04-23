/*
 *	Enterprise 64/128 graphics libraries
 *
 *	undrawr(x,y)
 *
 *	Stefano Bodrato - March 2011
 *
 *	$Id: undrawr.c,v 1.2 2016-04-23 08:20:39 dom Exp $
 */

#include <enterprise.h>
#include <graphics.h>


void undrawr(int x,int y)
{
	esccmd_cmd='I';	// INK colour
	esccmd_x=0;
	exos_write_block(DEFAULT_VIDEO, 3, esccmd);

	esccmd_cmd='S'; // set beam on
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);

	esccmd_cmd='R'; // relative beam position
	esccmd_x=x*4;
	esccmd_y=-y*4;
	exos_write_block(DEFAULT_VIDEO, 6, esccmd);

	esccmd_cmd='s'; // set beam off
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);
}
