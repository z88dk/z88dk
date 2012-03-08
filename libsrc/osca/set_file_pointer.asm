;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2012
;
;	void set_file_pointer(unsigned long pointer);
;
; Moves the read point from the start of a file (use after find file)
;
; Input Registers :
; IX:IY = Offset in bytes from start of file.
;
;
;	$Id: set_file_pointer.asm,v 1.2 2012-03-08 07:16:46 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  set_file_pointer

set_file_pointer:

	;__FASTCALL__
	;pop		hl		; sector ptr
	;pop		iy
	;pop		ix
	;push	ix
	;push	iy
	;push	hl
	push hl
	pop iy
	push de
	pop ix
	
	jp	kjt_set_file_pointer
