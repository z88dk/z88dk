;
;	Sharp MZ Routines
;
;	getk() Read key status
;
;	Stefano Bodrato - 8/5/2000


		XLIB	getk

.getk
		call	$55AA	;get key
		cp	6	;was it ENTER ?
		jr	nz,noenter
		ld	a,13
		jr	setout
.noenter

; Numbers. (Hey! Exactly as on the ZX81 !)
		cp	28	; Between 0 and 9 ?
		jr	c,isntnum
		cp	38
		jr	nc,isntnum
		add	a,20	; Ok, re-code to the ASCII charset
		jr	setout
.isntnum

.setout
 		ld	l,a
		ld	h,0
		ret
