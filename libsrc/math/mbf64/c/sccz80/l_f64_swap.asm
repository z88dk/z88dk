
        SECTION code_fp_mbf64

        PUBLIC  l_f64_swap

	EXTERN	___mbf64_FA

; Swap two values around
; Stack: +0 defw return address
;        +2 defw right hand LSW
;        +4 defw right hand NLSW
;        +6 defw right hand NMSW
;        +8 defw right hand MSW
l_f64_swap:
	ld	hl,2
	add	hl,sp
	ld	de,___mbf64_FA
	ld	b,8
loop:
	ld	c,(hl)
	ld	a,(de)
	ld	(hl),a
	ld	a,c
	ld	(de),a
	inc	hl
	inc	de
	djnz	loop
	ret
