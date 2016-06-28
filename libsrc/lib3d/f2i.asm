;
;	Fixed Point functions
;
;	int f2i (long v)
;	fixed point to integer
;
; ------
; $Id: f2i.asm,v 1.3 2016-06-28 19:31:42 dom Exp $
;

        SECTION code_clib
	PUBLIC	f2i
	PUBLIC	_f2i


.f2i
._f2i
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
	
