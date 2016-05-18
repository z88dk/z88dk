;
; 	Basic keyboard handling for the Jupiter ACE
;	By Stefano Bodrato Feb. 2001
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.5 2016-05-18 21:25:24 dom Exp $
;

	SECTION	code_clib
	PUBLIC	fgetc_cons

.fgetc_cons

.kwait
	call	$336
	and	a
	jr	nz,kwait
.kwait1
	call	$336
	and	a
	jr	z,kwait1

	cp	5	; Delete?
	jr	nz,nodel
	ld	a,8
.nodel

	ld	l,a
	ld	h,0
	ret
