;
; 	Basic keyboard handling for the Grundy Newbrain
;	By Stefano Bodrato May 2005
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.1 2007-04-01 20:48:40 stefano Exp $
;

	XLIB	getk

.getk

	ld	e,0
	rst	20h
	defb	31h
	jr	nc,nozero
	xor	a
.nozero
	cp	18h	; Delete?
	jr	nz,nodel
	ld	a,8
.nodel

	ld	l,a
	ld	h,0
	ret
