;
;	Sharp MZ Routines
;
;	fgetc_cons() Wait for keypress
;
;	Stefano Bodrato - 5/5/2000
;
;	No auto-repeat for now.
;	Maybe someone wants to improve this ?
;

		XLIB	fgetc_cons

.fgetc_cons
		call	$9b3	; wait for a key
		call	$bce	; convert it to ASCII
		
		cp	$66	; was it ENTER ?
		jr	nz,noenter
		ld	a,13
.noenter
		ld	l,a
		ld	h,0
		ret
