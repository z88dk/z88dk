;
; 	Basic keyboard handling for the Jupiter ACE
;	By Stefano Bodrato Feb. 2001
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.4 2015-01-19 01:33:17 pauloscustodio Exp $
;

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
