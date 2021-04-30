/*
 *	Enterprise 64/128 graphics libraries
 *
 *	setxy(x,y)
 *
 *	Stefano Bodrato - March 2011
 *
 *	$Id: setxy.c,v 1.1 2011-04-01 06:50:45 stefano Exp $
 */

#include <enterprise.h>
//#include <graphics.h>
extern void __LIB__ setxy(int x, int y) __smallc;


void setxy(int x, int y)
{
	esccmd_cmd='s'; // set beam off
	exos_write_block(DEFAULT_VIDEO, 2, esccmd);

	esccmd_cmd='A'; // set beam position
	esccmd_x=x*4;
	esccmd_y=971-y*4;
	exos_write_block(DEFAULT_VIDEO, 6, esccmd);
}
