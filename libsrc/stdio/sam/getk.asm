;
;       SAM Coupe C Library
;
;	getk() Read key status
;
;       We will corrupt any register
;
;       Stefano Bodrato - Mar.2001



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
