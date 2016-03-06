;
;	CPM Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2000
;	Stefano Bodrato - Mar. 2004 - removed the BS trick
;
;
;	$Id: fgetc_cons.asm,v 1.8 2016-03-06 21:36:52 dom Exp $
;


	SECTION	code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons

	LD 	c,6
	ld	e,255
	call	5
	and	a
	jr	z,fgetc_cons

	ld	l,a
	ld	h,0
	ret
