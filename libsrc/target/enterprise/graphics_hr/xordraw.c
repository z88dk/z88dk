/*
 *	Enterprise 64/128 graphics libraries
 *
 *	xordraw(x1,y1,x2,y2)
 *
 *	Stefano Bodrato - March 2011
 *
 *	$Id: xordraw.c $
 */

#include <enterprise.h>
//#include <graphics.h>
extern void __LIB__ xordraw(int x1, int y1, int x2, int y2) __smallc;


void xordraw(int x1,int y1,int x2,int y2)
{
	esccmd_cmd='I';	// INK colour
	esccmd_x=1;
	exos_write_block(DEFAULT_VIDEO, 3, esccmd);

	esccmd_cmd='s'; // set beam off
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);

	esccmd_cmd='A'; // set beam position
	esccmd_x=x1*2;
	esccmd_y=971-y1*4;
	exos_write_block(DEFAULT_VIDEO, 6, esccmd);

	esccmd_cmd='M'; // set beam style
	esccmd_x=3;	// XOR
	exos_write_block(DEFAULT_VIDEO, 3, esccmd);

	esccmd_cmd='S'; // set beam on
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);

	esccmd_cmd='A'; // set beam position
	esccmd_x=x2*2;
	esccmd_y=971-y2*4;
	exos_write_block(DEFAULT_VIDEO, 6, esccmd);

	esccmd_cmd='s'; // set beam off
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);

	esccmd_cmd='M'; // set beam style
	esccmd_x=0;	// PLOT
	exos_write_block(DEFAULT_VIDEO, 3, esccmd);
}
