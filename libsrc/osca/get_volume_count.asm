;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get number of volumes available
;
;	$Id: get_volume_count.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  get_volume_count
	
get_volume_count:
	call	kjt_get_volume_info
	ld	l,b
	ld	h,0
	ret
