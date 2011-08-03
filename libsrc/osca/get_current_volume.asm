;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get current volume
;
;	$Id: get_current_volume.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  get_current_volume
	
get_current_volume:
	call	kjt_get_volume_info
	ld	l,a
	ld	h,0
	ret
