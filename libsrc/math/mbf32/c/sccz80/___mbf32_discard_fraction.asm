
	SECTION		code_fp_mbf32

	PUBLIC		___mbf32_discard_fraction

	EXTERN		___mbf32_set_zero
	EXTERN		___mbf32_FPREG

; Discard the fractional part of a floating point number
; Truncates towards 0: 2.4 -> 2, -2.4 -> -2
; Entry: number in ___mbf32_FPREG
; Exit:  integral number in ___mbf32_FPREG
; Uses:  a, b, hl
___mbf32_discard_fraction:
    ld      a,(___mbf32_FPREG + 3)
	sub	$81
	jp	c,___mbf32_set_zero
	cp	24
	ret	nc		;No shifts needed, all integer
	ld	b,a
	ld	a,23
	sub	b
	ld	hl,___mbf32_FPREG
	ld	b,a		; Save number of bits
	rrca
	rrca
	rrca
	and	3		; Number of bytes to clear
	jr	z,clear_bits
clear_bytes:	
	ld	(hl),0
	inc	hl
	dec	a
	jr	nz,clear_bytes
clear_bits:
	ld	a,b
	and	7
	ret	z		;Nothing to clear
	ld	b,a
	ld	a,$ff
calc_mask:
IF __CPU_INTEL__
	rlca
	and	@11111110
ELSE
	sla	a
ENDIF
	djnz	calc_mask
	and	(hl)
	ld	(hl),a
	ret
