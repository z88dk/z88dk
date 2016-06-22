;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Move in first directory position
;
;	$Id: dir_move_first.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  dir_move_first
	PUBLIC  _dir_move_first
	EXTERN  flos_err

dir_move_first:
_dir_move_first:
	call	kjt_dir_list_first_entry
	jp	flos_err
