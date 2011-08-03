;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Move in first directory position
;
;	$Id: dir_move_first.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  dir_move_first
	LIB  flos_err

dir_move_first:
	call	kjt_dir_list_first_entry
	jp	flos_err
