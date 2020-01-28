;
;       SAM Coupe C Library
;
;	getkey() Wait for keypress
;
;       We will corrupt any register
;
;       Stefano Bodrato - Mar.2001
;
;
;	$Id: fgetc_cons.asm,v 1.4 2016-06-12 17:32:01 dom Exp $
;


        SECTION code_clib

	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons
	xor	a
	call	$0166	;flush keyboard buffer
loop:
	call	$016C
	and	a
	jr	z,loop
IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF
	ld	h,0
	ld	l,a

	ret
