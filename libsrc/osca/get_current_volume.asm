;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get current volume
;
;	$Id: get_current_volume.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  get_current_volume
	PUBLIC  _get_current_volume
	
get_current_volume:
_get_current_volume:
	call	kjt_get_volume_info
	ld	l,a
	ld	h,0
	ret
