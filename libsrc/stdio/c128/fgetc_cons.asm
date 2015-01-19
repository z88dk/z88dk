;
; 	Keyboard routines for the Commodore 128 (Z80 mode)
;	By Stefano Bodrato - 27/08/2001
;
;	getkey() Wait for keypress
;
;	$Id: fgetc_cons.asm,v 1.3 2015-01-19 01:33:20 pauloscustodio Exp $
;


		PUBLIC	fgetc_cons
		EXTERN	getk

.fgetc_cons
	call	getk
	and	a
	jr	nz,fgetc_cons
.kwait
	call	getk
	and	a
	jr	z,kwait
	
	ld	l,a
	ld	h,0
	ret
