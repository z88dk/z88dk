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
;	$Id: getk.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;



		XLIB	getk

.getk
		call	$0169
		ld	h,0
		jr	nz,gotkey
		ld	l,h
		ret
.gotkey
		ld	h,0
		ld	l,a
	
		ret
