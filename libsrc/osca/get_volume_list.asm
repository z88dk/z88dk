;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get current volume
;
;	$Id: get_volume_list.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  get_volume_list
	PUBLIC  _get_volume_list

	defc	get_volume_list = kjt_get_volume_info
	defc	_get_volume_list = kjt_get_volume_info
	
