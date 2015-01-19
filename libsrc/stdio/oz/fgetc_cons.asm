;
;	OZ 700 console library
;
;	getkey() Wait for keypress
;
;	$Id: fgetc_cons.asm,v 1.3 2015-01-19 01:33:21 pauloscustodio Exp $
;

		;XREF	KeyBufGetPos
		;XREF	KeyBufPutPos
		;XREF	EnableKeyboard

		PUBLIC	fgetc_cons
		EXTERN	getk

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
