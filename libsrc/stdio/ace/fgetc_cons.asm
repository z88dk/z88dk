;
; 	Basic keyboard handling for the Jupiter ACE
;	By Stefano Bodrato Feb. 2001
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

	XLIB	fgetc_cons

.fgetc_cons

.kwait
	call	$336
	and	a
	jr	nz,kwait
.kwait1
	call	$336
	and	a
	jr	z,kwait1

	ld	l,a
	ld	h,0
	ret
