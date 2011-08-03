;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get pointer to driver table
;
;	$Id: get_driver_list.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  get_driver_list
	
get_driver_list:
	call	kjt_get_device_info
	ld	h,d
	ld	l,e
	ret
