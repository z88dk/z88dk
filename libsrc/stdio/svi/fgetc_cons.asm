;
;	Spectravideo SVI C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2001
;

	XLIB	fgetc_cons

.fgetc_cons
	call	$3e
	ld	l,a
	ld	h,0
	ret
