
SECTION code_crt0_sccz80

EXTERN l_cmpbcde

; {BC : DE}
l_cmpbcde:
	ld	a,e
	sub	c
	ld	a,d
	sbc	b
	ret

