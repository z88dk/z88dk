;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get pointer to device info table
;
;	$Id: get_device_info.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  get_device_info
	
get_device_info:
	jp	kjt_get_device_info
