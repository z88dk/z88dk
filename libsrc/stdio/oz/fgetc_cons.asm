;
;	OZ 700 console library
;
;	getkey() Wait for keypress
;
;	$Id: fgetc_cons.asm,v 1.5 2016-07-14 17:44:18 pauloscustodio Exp $
;

		;EXTERN	KeyBufGetPos
		;EXTERN	KeyBufPutPos
		;EXTERN	EnableKeyboard

       	 	SECTION code_clib
		PUBLIC	fgetc_cons
		PUBLIC	_fgetc_cons
		EXTERN	getk

.fgetc_cons
._fgetc_cons
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
