/*
 *	Enterprise 64/128 graphics libraries
 *
 *	clga(x1,y1,x2,y2)
 *
 *	Stefano Bodrato - March 2011
 *
 *	$Id: clga.c $
 */

#include <enterprise.h>
//#include <graphics.h>
extern void __LIB__ clga(int x1, int y1, int x2, int y2) __smallc;


int _yy_;

void clga(int x1,int y1,int x2,int y2)
{

	esccmd_cmd='I';	// INK colour
	esccmd_x=0;
	exos_write_block(DEFAULT_VIDEO, 3, esccmd);

	esccmd_cmd='s'; // set beam off
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);

	for (_yy_=y1; _yy_<y2; _yy_++) {

		esccmd_cmd='A'; // set beam position
		esccmd_x=x1*2;
		esccmd_y=971-_yy_*4;
		exos_write_block(DEFAULT_VIDEO, 6, esccmd);

		esccmd_cmd='S'; // set beam on
		exos_write_block(DEFAULT_VIDEO, 2, esccmd);

		esccmd_cmd='A'; // set beam position
		esccmd_x=x2*2-1;
		esccmd_y=971-_yy_*4;
		exos_write_block(DEFAULT_VIDEO, 6, esccmd);

		esccmd_cmd='s'; // set beam off
		exos_write_block(DEFAULT_VIDEO, 2, esccmd);
	}

}
