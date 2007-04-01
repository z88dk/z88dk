;
; 	Basic keyboard handling for the Grundy Newbrain
;	By Stefano Bodrato May 2005
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.1 2007-04-01 20:48:40 stefano Exp $
;

	XLIB	fgetc_cons

.fgetc_cons

.kwait
	ld	e,0
	rst	20h
	defb	31h
	jr	nc,kwait
.kwait1
	ld	e,0
	rst	20h
	defb	31h
	jr	c,kwait1

	cp	18h	; Delete?
	jr	nz,nodel
	ld	a,8
.nodel

	ld	l,a
	ld	h,0
	ret
