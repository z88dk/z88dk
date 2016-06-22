;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get current volume
;
;	$Id: get_device_list.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  get_device_list
	PUBLIC  _get_device_list

	defc	get_device_list = kjt_get_device_info
	defc	_get_device_list = kjt_get_device_info
	
