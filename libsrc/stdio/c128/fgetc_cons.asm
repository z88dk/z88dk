;
; 	Keyboard routines for the Commodore 128 (Z80 mode)
;	By Stefano Bodrato - 27/08/2001
;
;	getkey() Wait for keypress
;
;	$Id: fgetc_cons.asm,v 1.1 2001-08-28 14:05:43 stefano Exp $
;


		XLIB	fgetc_cons
		LIB	getk

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
