;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get pointer to driver table
;
;	$Id: get_driver_list.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  get_driver_list
	
get_driver_list:
	call	kjt_get_device_info
	ld	h,d
	ld	l,e
	ret
