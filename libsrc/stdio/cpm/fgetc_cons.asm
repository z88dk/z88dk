;
;	CPM Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2000
;

	XLIB	fgetc_cons

.fgetc_cons

	ld	c,1
	call	5
	
	ld	e,8	; Backspace.
	ld	c,2	; The read key is been echoed, also!
	push	af
	call	5
	pop	af
	
	ld	l,a
	ld	h,0
	ret
