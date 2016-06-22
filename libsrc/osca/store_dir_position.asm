;
;	Get the FLOS version number
;	by Stefano Bodrato, 2011
;
;
;
;	$Id: store_dir_position.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  store_dir_position
	PUBLIC  _store_dir_position

	defc store_dir_position = kjt_store_dir_position
	defc _store_dir_position = kjt_store_dir_position
	
