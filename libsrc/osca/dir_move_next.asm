;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Move in next directory position
;
;	$Id: dir_move_next.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  dir_move_next
	LIB   flos_err

dir_move_next:
	call	kjt_dir_list_next_entry
	jp		flos_err
