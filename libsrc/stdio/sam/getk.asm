;
;       SAM Coupe C Library
;
;	getk() Read key status
;
;       We will corrupt any register
;
;       Stefano Bodrato - Mar.2001
;
;
;	$Id: getk.asm,v 1.3 2002-03-11 17:11:34 stefano Exp $
;



		XLIB	getk

.getk
		call	$0169
		ld	h,0
		jr	nz,gotkey
		ld	l,h
		ret
.gotkey
		ld	l,a
		ret
