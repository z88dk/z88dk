;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get number of volumes available
;
;	$Id: get_volume_count.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  get_volume_count
	PUBLIC  _get_volume_count
	
get_volume_count:
_get_volume_count:
	call	kjt_get_volume_info
	ld	l,b
	ld	h,0
	ret
