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
;
;	$Id: fgetc_cons.asm,v 1.3 2011-10-03 15:22:20 stefano Exp $
;

		XLIB	fgetc_cons

.fgetc_cons
;		call	$9b3	; wait for a key
;		call	$bce	; convert it to ASCII

		call	$1B   ;get key
		and	a
		jr		nz,fgetc_cons

.wkey
		call	$1B   ;get key
		and a
		jr	z,wkey

		cp	$66	; was it ENTER ?
		jr	nz,noenter
		ld	a,13
.noenter
		ld	l,a
		ld	h,0
		ret
