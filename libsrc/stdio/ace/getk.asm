;
; 	Basic keyboard handling for the Jupiter ACE
;	By Stefano Bodrato Feb. 2001
;
;	getk() Read key status
;
;

	XLIB	getk

.getk

	call	$336

	ld	l,a
	ld	h,0
	ret
