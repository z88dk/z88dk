;
;	ROM Console routine for the Philips Videopac C7420
;	By Stefano Bodrato - 2015
;
;	$Id: fputc_cons.asm,v 1.1 2015-10-23 20:34:51 stefano Exp $
;

	PUBLIC	fputc_cons

.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)

	cp	13
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
