;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Move in next directory position
;
;	$Id: dir_move_next.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  dir_move_next
	PUBLIC  _dir_move_next
	EXTERN   flos_err

dir_move_next:
_dir_move_next:
	call	kjt_dir_list_next_entry
	jp		flos_err
