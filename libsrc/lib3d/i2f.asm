;
;	Fixed Point functions
;
;	long __FASTCALL__ i2f (int v)
;	integer to float;
;
; ------
; $Id: i2f.asm,v 1.3 2016-06-28 19:31:42 dom Exp $
;

        SECTION code_clib
	PUBLIC	i2f
	PUBLIC	_i2f
	

.i2f
._i2f
        ;pop     bc
        ;pop     hl
        ;push    hl
        ;push    bc

;; put long result in DEHL
	ld	e,h
	ld	h,l
	ld	l,0
	ld	d,l
        bit     7,e
        jr	z,noneg
        dec     d
        inc	l	; when rotated it will become bit 31
        scf		; when rotated it will become bit 30
.noneg	
	rr	d
	rr	e
	rr	h
	rr	l
	
	rr	d
	rr	e
	rr	h
	rr	l

        ret

