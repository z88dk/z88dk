/*
 *	Enterprise 64/128 graphics libraries
 *
 *	clg()
 *
 *	Stefano Bodrato - March 2011
 *
 *	$Id: clg.c,v 1.2 2016-04-23 08:30:28 dom Exp $
 */

#include <enterprise.h>
#include <graphics.h>


/* Clear Graphics */

void clg()
{
	//	Initialize a custom video mode
	set_exos_variable(EV_BORD_VID,255);
	status_line_off();
	// x size = 42*8   -> 672 dots
	// y size = 27*9*2 -> 243 dots
	exos_set_vmode(VM_HRG,CM_2,42,27);
	
	esccmd_cmd='c';    // Set palette colour
	esccmd_x=0xff00;   // color #0, value 255
	exos_write_block(DEFAULT_VIDEO, 4, esccmd);
	esccmd_x=0x0001;   // color #1, value 0
	exos_write_block(DEFAULT_VIDEO, 4, esccmd);
}
