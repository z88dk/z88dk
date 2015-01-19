;
;	Devilishly simple VZ Routines
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fgetc_cons.asm,v 1.3 2015-01-19 01:33:21 pauloscustodio Exp $
;

		PUBLIC	fgetc_cons

.fgetc_cons
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
