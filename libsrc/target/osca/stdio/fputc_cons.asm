;
; 	Basic stdio handling for the OSCA architecture
;	By Stefano Bodrato Jul. 2011
;
;	Print character to the screen
;
;
;	$Id: fputc_cons.asm,v 1.8+ (now on GIT) $
;


    INCLUDE "target/osca/def/flos.def"
	SECTION code_clib
	PUBLIC  fputc_cons_native
	EXTERN  cursor_x

;
; Entry:        char to print
;


.fputc_cons_native
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
IF STANDARDESCAPECHARS
	cp	13
	ret	z
	cp	10
	jr	nz,nocr
	ld	(hl),13
	push	hl
	call	kjt_print_string
	pop	hl
	ld	(hl),10
ELSE
	cp	10	
	ret	z
	cp	13
	jr	nz,nocr
	push	hl
	call	kjt_print_string
	pop	hl
	ld	(hl),10
ENDIF
.nocr
	cp 12
	jp z,kjt_clear_screen
	jp	kjt_print_string
