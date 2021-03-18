/*
 *	Enterprise 64/128 graphics libraries
 *
 *	move(x,y)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: move.c $
 */

#include <enterprise.h>
//#include <graphics.h>
extern void __LIB__ move(int px, int py) __smallc;
extern unsigned char _pen[];

void move(int x,int y)
{
	esccmd_cmd='I';	// INK colour
	esccmd_x=1;
	exos_write_block(DEFAULT_VIDEO, 3, esccmd);

	if (_pen[0] & 128) {
		esccmd_cmd='S'; // set beam on
		exos_write_block(DEFAULT_VIDEO, 2, esccmd);
	} else {
		esccmd_cmd='s'; // set beam off
		exos_write_block(DEFAULT_VIDEO, 2, esccmd);
	}

	esccmd_cmd='R'; // relative beam position
	esccmd_x=x*4;
	esccmd_y=-y*4;
	exos_write_block(DEFAULT_VIDEO, 6, esccmd);

	esccmd_cmd='s'; // set beam off
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);
}
