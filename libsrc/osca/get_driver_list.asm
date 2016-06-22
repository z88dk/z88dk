;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get pointer to driver table
;
;	$Id: get_driver_list.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  get_driver_list
	PUBLIC  _get_driver_list
	
get_driver_list:
_get_driver_list:
	call	kjt_get_device_info
	ld	h,d
	ld	l,e
	ret
