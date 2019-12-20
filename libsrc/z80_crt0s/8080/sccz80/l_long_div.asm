

SECTION code_crt0_sccz80
PUBLIC  l_long_div

EXTERN	l_long_divide

l_long_div:
	ld	a,129
	jp	l_long_divide
