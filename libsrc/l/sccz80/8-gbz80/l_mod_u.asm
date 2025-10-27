

SECTION code_clib
SECTION code_l_sccz80
PUBLIC	l_mod_u
EXTERN	___divu16_bcde

; signed division
; hl = de/hl, de = de%hl
l_mod_u:
	; Delegate to the sdcc routine 
	; Entry BC=dividend, DE=divisor
	; Exit: BC=quotient, DE=remainder
	ld	c,e
	ld	b,d
	ex	de,hl
	call	___divu16_bcde
	ld	l,e
	ld	h,d
	ret
