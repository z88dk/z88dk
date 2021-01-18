;
;	Enterprise 64/128 C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - 2011
;
;
;	$Id: fgetc_cons.asm,v 1.4 2016-06-12 17:07:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons

	ld   a,69h ; keyboard channel
	rst  $30   ; EXOS
	defb 5     ; output to channel
IF STANDARDESCAPECHARS
	ld	a,13
	cp	b
	jr	nz,not_return
	ld	b,10
.not_return
ENDIF

	ld   h,0
	ld   l,b
	ret
