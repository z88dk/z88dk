;
;	OZ 700 console library
;
;	getkey() Wait for keypress
;
;	$Id: fgetc_cons.asm,v 1.2 2003-05-20 16:01:56 stefano Exp $
;

		;XREF	KeyBufGetPos
		;XREF	KeyBufPutPos
		;XREF	EnableKeyboard

		XLIB	fgetc_cons
		LIB	getk

.fgetc_cons
		call	getk
		ld	a,l
		and	a
		jr	nz,fgetc_cons

.kwait
		call	getk
		ld	a,l
		and	a
		jr	z,kwait

		ret
