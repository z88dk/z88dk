
        SECTION code_fp_dai32

        PUBLIC  l_f32_swap

; Entry: dehl = right hand operand
; Stack: defw return address
;        defw left hand LSW
;        defw left hand MSW
l_f32_swap:
IF __CPU_INTEL__ || CPU_GBZ80__
	ld	c,l	;right lsw
	ld	b,h
	ld	hl,sp+2	;points to left hand lsw
	ld	a,(hl)
	ld	(hl),c
	ld	c,a
	inc	hl
	ld	a,(hl)
	ld	(hl),b
	ld	b,a
	inc	hl
	ld	a,(hl)
	ld	(hl),e
	ld	e,a
	inc	hl
	ld	a,(hl)
	ld	(hl),d
	ld	d,a
	ld	l,c
	ld	h,b
ELSE
	pop	af	; Return
	pop	bc	; left-LSW
	ex	de,hl	; de = right-LSW, hl = right-MSW
	ex	(sp),hl	; hl = left-MSW, (sp) = right-MSW
	push	de	; Push right-LSW
	push	af	; Return address
	ex	de,hl	; de = left-MSW
	ld	l,c	
	ld	h,b	; hl = left-LSW
ENDIF
	ret

