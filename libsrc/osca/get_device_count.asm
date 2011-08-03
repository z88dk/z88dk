;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get number of devices
;
;	$Id: get_device_count.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  get_device_count
	
get_device_count:
	call	kjt_get_device_info
	ld	l,b
	ld	h,0
	ret
