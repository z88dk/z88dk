;
;	Devilishly simple VZ Routines
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fgetc_cons.asm,v 1.4 2016-06-10 23:56:01 dom Exp $
;

        SECTION code_clib
		PUBLIC	fgetc_cons
		PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons
		ld	b,50		; Horrible workaround...
.sillyloop
		push	bc
		call	$2efd		; Wait for Key release
		pop	bc
		and	a
		djnz	sillyloop
		jr	nz,fgetc_cons
.fgetc_cons1
		call	$2efd		; Wait for Key press, now
		and	a
		jr	z,fgetc_cons1

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

		ld	l,a
		ld	h,0
		ret
