;
; 	Basic keyboard handling for the Grundy Newbrain
;	By Stefano Bodrato May 2005
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.3 2015-01-19 01:33:20 pauloscustodio Exp $
;

	PUBLIC	getk

.getk
	;ld	e,0
	rst	20h
	defb	38h
	rst	20h	; Convert Key code
	defb	3Ah
	ld	h,0
	ld	l,a
	ret
