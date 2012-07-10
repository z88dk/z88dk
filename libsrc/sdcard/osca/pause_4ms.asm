;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;
;	Ported by Stefano Bodrato, 2012
;
;	Short delay to sync communications with card
;
;	$Id: pause_4ms.asm,v 1.1 2012-07-10 05:55:38 stefano Exp $
;


	XLIB	pause_4ms
	
    INCLUDE "flos.def"

pause_4ms:
	xor a
	jp kjt_timer_wait
