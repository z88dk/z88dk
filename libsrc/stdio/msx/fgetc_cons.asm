;
;	MSX C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2001
;

	XLIB	fgetc_cons

.fgetc_cons
	call	$9f
	ld	l,a
	ld	h,0
	ret
