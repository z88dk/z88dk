;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get current volume
;
;	$Id: get_current_volume.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  get_current_volume
	
get_current_volume:
	call	kjt_get_volume_info
	ld	l,a
	ld	h,0
	ret
