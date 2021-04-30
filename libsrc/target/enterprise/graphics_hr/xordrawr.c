/*
 *	Enterprise 64/128 graphics libraries
 *
 *	xordrawr(x,y)
 *
 *	Stefano Bodrato - March 2011
 *
 *	$Id: xordrawr.c $
 */

#include <enterprise.h>
//#include <graphics.h>
extern void __LIB__ xordrawr(int px, int py) __smallc;


void xordrawr(int x,int y)
{
	esccmd_cmd='I';	// INK colour
	esccmd_x=1;
	exos_write_block(DEFAULT_VIDEO, 3, esccmd);

	esccmd_cmd='M'; // set beam style
	esccmd_x=3;	// XOR
	exos_write_block(DEFAULT_VIDEO, 3, esccmd);

	esccmd_cmd='S'; // set beam on
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);

	esccmd_cmd='R'; // relative beam position
	esccmd_x=x*2;
	esccmd_y=-y*4;
	exos_write_block(DEFAULT_VIDEO, 6, esccmd);

	esccmd_cmd='s'; // set beam off
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);

	esccmd_cmd='M'; // set beam style
	esccmd_x=0;	// PLOT
	exos_write_block(DEFAULT_VIDEO, 3, esccmd);
}
