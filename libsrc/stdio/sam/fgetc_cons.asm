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
;	$Id: fgetc_cons.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;



		XLIB	fgetc_cons

.fgetc_cons
		call	$016C

		ld	h,0
		ld	l,a

		ret
