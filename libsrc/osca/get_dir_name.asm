;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2012
;
;	Get name of current directory
;
;	$Id: get_dir_name.asm,v 1.4 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  get_dir_name
	PUBLIC  _get_dir_name

	defc get_dir_name = kjt_get_dir_name	
	defc _get_dir_name = kjt_get_dir_name	
