;
;	OZ 700 console library
;	foo stub only, for now
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.1 2002-11-20 14:17:02 stefano Exp $
;

		XLIB	fgetc_cons
		XREF	KeyBufGetPos
		XREF	KeyBufPutPos
		XREF	EnableKeyboard

.fgetc_cons
		ld	hl,13
		ret
