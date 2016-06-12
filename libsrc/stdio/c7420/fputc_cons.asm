;
;	ROM Console routine for the Philips Videopac C7420
;	By Stefano Bodrato - 2015
;
;	$Id: fputc_cons.asm,v 1.3 2016-06-12 17:00:21 dom Exp $
;


	SECTION	code_clib
	PUBLIC	fputc_cons_native

.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
IF STANDARDESCAPECHARS
	cp	13
ELSE
	cp	10
ENDIF
	jr	nz,nocr
	ld	a,131		; ENTER
.nocr

	cp	8
	jr	nz,nobs
	ld	a,130		; RUBOUT
.nobs

	cp	12
	jr	nz,nocls
	;ld	a,159		; VIDINI (slower)
	ld	a,157		; CLEARA
	rst	$30
	ld	a,140		; HOME
.nocls

	rst	$30
	ret
