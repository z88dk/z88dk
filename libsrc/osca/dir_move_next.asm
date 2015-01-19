;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Move in next directory position
;
;	$Id: dir_move_next.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  dir_move_next
	EXTERN   flos_err

dir_move_next:
	call	kjt_dir_list_next_entry
	jp		flos_err
