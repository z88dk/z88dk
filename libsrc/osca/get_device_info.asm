;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get pointer to device info table
;
;	$Id: get_device_info.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  get_device_info
	PUBLIC  _get_device_info

	defc	get_device_info = kjt_get_device_info
	defc	_get_device_info = kjt_get_device_info
	
