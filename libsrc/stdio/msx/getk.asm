;
;	MSX C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: getk.asm,v 1.3 2007-12-03 07:29:40 stefano Exp $
;

	XLIB	getk
	LIB	msxbios
	LIB	fgetc_cons

.getk
	ld	ix,$9C		; CHSNS
	call	msxbios
	ret	z		; exit if no key in buffer
	jp	fgetc_cons
