;
;	CPM Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2000
;	Stefano Bodrato - Mar. 2004 - fixed
;
;
;	$Id: getk.asm,v 1.7 2016-03-06 21:36:52 dom Exp $
;

	SECTION	code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
	LD 	c,6
	ld	e,255
	call	5
	ld	h,0
	ld	l,a
	
	ret
