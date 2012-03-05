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
;	$Id: set_load_length.asm,v 1.1 2012-03-05 20:40:15 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  set_load_length

set_load_length:

	pop		hl		; sector ptr
	pop		iy
	pop		ix
	push	ix
	push	iy
	push	hl
	
	jp	kjt_set_load_length
