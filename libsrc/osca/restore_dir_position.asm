;
;	Get the FLOS version number
;	by Stefano Bodrato, 2011
;
;
;
;	$Id: restore_dir_position.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  restore_dir_position
	PUBLIC  _restore_dir_position

	defc restore_dir_position = kjt_restore_dir_position
	defc _restore_dir_position = kjt_restore_dir_position
	
