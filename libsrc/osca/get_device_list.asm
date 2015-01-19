;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get current volume
;
;	$Id: get_device_list.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  get_device_list
	
get_device_list:
	jp	kjt_get_device_info
