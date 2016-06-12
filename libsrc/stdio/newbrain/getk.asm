;
; 	Basic keyboard handling for the Grundy Newbrain
;	By Stefano Bodrato May 2005
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.4 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
	;ld	e,0
	rst	20h
	defb	38h
	rst	20h	; Convert Key code
	defb	3Ah
	ld	h,0
	ld	l,a
	ret
