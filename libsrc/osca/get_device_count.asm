;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get number of devices
;
;	$Id: get_device_count.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  get_device_count
	PUBLIC  _get_device_count
	
get_device_count:
_get_device_count:
	call	kjt_get_device_info
	ld	l,b
	ld	h,0
	ret
