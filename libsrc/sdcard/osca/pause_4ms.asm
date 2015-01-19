;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;
;	Ported by Stefano Bodrato, 2012
;
;	Short delay to sync communications with card
;
;	$Id: pause_4ms.asm,v 1.5 2015-01-19 01:33:07 pauloscustodio Exp $
;


	PUBLIC	pause_4ms
	
    INCLUDE "flos.def"

pause_4ms:
	xor a
	jp kjt_timer_wait
