;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Wait video hardware to be ready
;
;	$Id: wait_vrt.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  wait_vrt
	
wait_vrt:
	jp	kjt_wait_vrt
