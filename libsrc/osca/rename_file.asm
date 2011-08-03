;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Like 'rename' but with a FLOS style error handling
;
;	$Id: rename_file.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  rename_file
	LIB   flos_err

rename_file:
	pop bc
	pop de
	pop hl
	push hl
	push de
	push bc
	call	kjt_rename_file
	jp   flos_err
