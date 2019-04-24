
	SECTION		code_fp_mbf64

	PUBLIC		___mbf64_discard_fraction

	EXTERN		___mbf64_set_zero
	EXTERN		___mbf64_FA

; Discard the fractional part of a floating point number
; Truncates towards 0: 2.4 -> 2, -2.4 -> -2
; Entry: number in ___mbf64_FA
; Exit:  integral number in ___mbf64_FA
; Uses:  a, b, hl
___mbf64_discard_fraction:
        ld      a,(___mbf64_FA + 7)
	sub	$81
	jp	c,___mbf64_set_zero
	cp	56
	ret	nc		;No shifts needed, all integer
	ld	b,a
	ld	a,55
	sub	b
	ld	hl,___mbf64_FA
	ld	b,a		; Find number of bytes to clear
	srl	b
	srl	b
	srl	b
	jr	z,clear_bits
clear_bytes:	
	ld	(hl),0
	inc	hl
	djnz	clear_bytes
clear_bits:
	and	7
	ret	z		;Nothing to clear
	ld	b,a
	ld	a,$ff
calc_mask:
	sla	a
	djnz	calc_mask
	ld	b,(hl)
	ld	c,a
	and	(hl)
	ld	(hl),a
	ret
