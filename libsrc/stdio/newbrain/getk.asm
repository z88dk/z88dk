;
; 	Basic keyboard handling for the Grundy Newbrain
;	By Stefano Bodrato May 2005
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.2 2007-05-14 12:40:47 stefano Exp $
;

	XLIB	getk

.getk
	;ld	e,0
	rst	20h
	defb	38h
	rst	20h	; Convert Key code
	defb	3Ah
	ld	h,0
	ld	l,a
	ret
