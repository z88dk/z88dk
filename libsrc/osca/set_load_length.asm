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
;	$Id: set_load_length.asm,v 1.3 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  set_load_length

set_load_length:

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
	
	jp	kjt_set_load_length
