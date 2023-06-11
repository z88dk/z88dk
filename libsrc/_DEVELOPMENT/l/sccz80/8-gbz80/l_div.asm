

SECTION code_clib
SECTION code_l_sccz80
PUBLIC	l_div
EXTERN	___div16_bcde

; signed division
; hl = de/hl, de = de%hl
l_div:
	; Delegate to the sdcc routine 
	; Entry BC=dividend, DE=divisor
	; Exit: BC=quotient, DE=remainder
	ld	c,e
	ld	b,d
	ex	de,hl
	call	___div16_bcde
	ld	l,c
	ld	h,b
	ret
