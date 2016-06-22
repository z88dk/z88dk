;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2012
;
;	void set_load_length(unsigned long length);
;
; Forces the read length of the file transfer to a certain value (use after find file)
;
; Input Registers :
; IX:IY = Bytes to load
;
;
;	$Id: set_load_length.asm,v 1.4 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  set_load_length
	PUBLIC  _set_load_length

set_load_length:
_set_load_length:

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
	
	call	kjt_set_load_length
	pop	ix	;restore callers
	ret
