;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get number of devices
;
;	$Id: get_device_count.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  get_device_count
	
get_device_count:
	call	kjt_get_device_info
	ld	l,b
	ld	h,0
	ret
