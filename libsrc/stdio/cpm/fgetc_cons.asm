;
;	CPM Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2000
;	Stefano Bodrato - Mar. 2004 - removed the BS trick
;
;
;	$Id: fgetc_cons.asm,v 1.4 2004-03-20 11:16:24 stefano Exp $
;

	XLIB	fgetc_cons

.fgetc_cons

	LD 	c,6
	ld	e,255
	call	5
	ld	h,0
	ld	l,a
	and	a
	jr	z,fgetc_cons

	ld	l,a
	ld	h,0
	ret
