;
; 	Basic stdio handling for the OSCA architecture
;	By Stefano Bodrato Jul. 2011
;
;	Print character to the screen
;
;
;	$Id: fputc_cons.asm,v 1.7 2015-01-19 01:33:21 pauloscustodio Exp $
;


    INCLUDE "flos.def"

	PUBLIC  fputc_cons
	EXTERN  cursor_x

;
; Entry:        char to print
;


.fputc_cons
	ld	hl,3
	add	hl,sp

	; Be sure we have a string termination after char.
	xor a
	ld	(hl),a
	dec hl
	ld	a,(hl)
	cp 8
	jr nz,nobs
	ld	a,(cursor_x)
	and a
	ret z
	dec a
	ld (cursor_x),a
	ret
.nobs
	cp 10
	ret z
	cp 13
	jr nz,nocr
	dec (hl)	; switch CR to CRLF
	dec (hl)
.nocr
	cp 12
	jp z,kjt_clear_screen
	jp	kjt_print_string
