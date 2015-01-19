;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;
;	Ported by Stefano Bodrato, 2012
;
;	Power off the sdcard slot
;
;	$Id: sd_power_off.asm,v 1.2 2015-01-19 01:33:07 pauloscustodio Exp $
;


	PUBLIC	sd_power_off
    INCLUDE "osca.def"


sd_power_off:
	
	push af
	in a,(sys_sdcard_ctrl2)
	set sd_power,a			; set power control hi: inactive - no power to SD
	res sd_cs,a			; ensure /CS is low	- no power to this pin		; 			
	out (sys_sdcard_ctrl2),a		

	xor a

	out (sys_sdcard_ctrl1),a
	pop af
	ret
