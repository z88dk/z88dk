;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get pointer to device info table
;
;	$Id: get_device_info.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  get_device_info
	
get_device_info:
	jp	kjt_get_device_info
