;
;	CCE MC-1000 Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato, 2013
;
;
;	$Id: fgetc_cons.asm,v 1.1 2013-03-04 18:08:43 stefano Exp $
;

; The code at entry $c009 checks if a key has been pressed in a 7ms interval.
; If so, A and (£012E) are set to $FF and the key code is put in (£011C).
; Otherwise, A and (£012E) are set to $00.

	XLIB	fgetc_cons

fgetc_cons:
	call	$C009
	and	a
	jr	z,fgetc_cons
	call	$C006
	ld	l,a
	ld	h,0
	ret
