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
		call	12020		; Wait for Key release
		pop	bc
		and	a
		djnz	sillyloop
		jr	nz,fgetc_cons
.fgetc_cons1
		call	12020		; Wait for Key press, now
		and	a
		jr	z,fgetc_cons1

		ld	l,a
		ld	h,0
		ret
