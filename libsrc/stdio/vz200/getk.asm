;
;	Devilishly simple VZ Routines
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2000


		XLIB	getk

.getk
		call	12020		;scan keyboard once
		ld	l,a
		ld	h,0
		ret
