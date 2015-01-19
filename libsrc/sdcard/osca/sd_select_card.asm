;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;
;	Ported by Stefano Bodrato, 2012
;
;	Select the sdcard
;
;	$Id: sd_select_card.asm,v 1.2 2015-01-19 01:33:07 pauloscustodio Exp $
;


	PUBLIC	sd_select_card	
	
	
    INCLUDE "osca.def"


sd_select_card:

	push af
	in a,(sys_sdcard_ctrl2)
	res sd_cs,a
	
	out (sys_sdcard_ctrl2),a
	pop af
	ret
	
