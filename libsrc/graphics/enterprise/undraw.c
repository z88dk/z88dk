/*
 *	Enterprise 64/128 graphics libraries
 *
 *	undraw(x1,y1,x2,y2)
 *
 *	Stefano Bodrato - March 2011
 *
 *	$Id: undraw.c,v 1.2 2016-04-23 08:20:39 dom Exp $
 */

#include <enterprise.h>
#include <graphics.h>


void undraw(int x1,int y1,int x2,int y2)
{
	esccmd_cmd='I';	// INK colour
	esccmd_x=0;
	exos_write_block(DEFAULT_VIDEO, 3, esccmd);

	esccmd_cmd='s'; // set beam off
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);

	esccmd_cmd='A'; // set beam position
	esccmd_x=x1*4;
	esccmd_y=972-y1*4;
	exos_write_block(DEFAULT_VIDEO, 6, esccmd);

	esccmd_cmd='S'; // set beam on
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);

	esccmd_cmd='A'; // set beam position
	esccmd_x=x2*4;
	esccmd_y=972-y2*4;
	exos_write_block(DEFAULT_VIDEO, 6, esccmd);

	esccmd_cmd='s'; // set beam off
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);
}
