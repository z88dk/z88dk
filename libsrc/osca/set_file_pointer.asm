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
;	$Id: set_file_pointer.asm,v 1.4 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  set_file_pointer
	PUBLIC  _set_file_pointer

set_file_pointer:
_set_file_pointer:

	;__FASTCALL__
	;pop		hl		; sector ptr
	;pop		iy
	;pop		ix
	;push	ix
	;push	iy
	;push	hl
	push	ix	;save callers
	push hl
	pop iy
	push de
	pop ix
	call	kjt_set_file_pointer
	pop	ix	;restore callers
	ret
