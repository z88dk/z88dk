;
; 	Basic keyboard handling for the Jupiter ACE
;	By Stefano Bodrato Feb. 2001
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

	XLIB	getk

.getk

	call	$336

	ld	l,a
	ld	h,0
	ret
