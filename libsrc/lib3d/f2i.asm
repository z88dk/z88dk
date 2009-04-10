;
;	Fixed Point functions
;
;	int f2i (long v)
;	fixed point to integer
;
; ------
; $Id: f2i.asm,v 1.1 2009-04-10 12:47:42 stefano Exp $
;

	XLIB	f2i


.f2i
        pop     bc	; RET addr.
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc

;; DEHL holds value

	;rr	d
	;rr	e
	;rr	h
	;rr	l
	;rr	d
	;rr	e
	;rr	h
	;rr	l

	ld	d,l

	ld	l,h
	ld	h,e
	
	rl	d
	rl	l
	rl	h

	rl	d
	rl	l
	rl	h
	
	ret
	