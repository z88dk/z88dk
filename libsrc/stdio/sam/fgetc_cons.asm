;
;       SAM Coupe C Library
;
;	getkey() Wait for keypress
;
;       We will corrupt any register
;
;       Stefano Bodrato - Mar.2001
;
;
;	$Id: fgetc_cons.asm,v 1.3 2015-01-19 01:33:21 pauloscustodio Exp $
;



		PUBLIC	fgetc_cons

.fgetc_cons
		call	$016C

		ld	h,0
		ld	l,a

		ret
