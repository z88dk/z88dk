;
; 	Basic keyboard handling for the Jupiter ACE
;	By Stefano Bodrato Feb. 2001
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.5 2016-05-18 21:25:24 dom Exp $
;

	SECTION	code_clib
	PUBLIC	getk

.getk

	call	$336

	cp	5	; Delete?
	jr	nz,nodel
	ld	a,8
.nodel

	ld	l,a
	ld	h,0
	ret
