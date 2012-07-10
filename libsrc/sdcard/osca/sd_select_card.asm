;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;
;	Ported by Stefano Bodrato, 2012
;
;	Select the sdcard
;
;	$Id: sd_select_card.asm,v 1.1 2012-07-10 05:55:38 stefano Exp $
;


	XLIB	sd_select_card	
	
	
    INCLUDE "osca.def"


sd_select_card:

	push af
	in a,(sys_sdcard_ctrl2)
	res sd_cs,a
	
	out (sys_sdcard_ctrl2),a
	pop af
	ret
	
