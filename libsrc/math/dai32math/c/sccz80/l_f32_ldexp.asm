;
; Intrinsic sccz80 routine to multiply by a power of 2
;
;
    SECTION code_fp_dai32

    PUBLIC  l_f32_ldexp

; Entry: a = adjustment for exponent
;       Stack: float, ret
; Exit: dehl = adjusted float

l_f32_ldexp:
	add	d
	ld	d,a
	ret
