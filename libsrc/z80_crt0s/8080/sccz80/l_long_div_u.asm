

SECTION code_crt_sccz80
PUBLIC  l_long_div_u

EXTERN	l_long_divide

l_long_div_u:
	ld	a,1
	jp	l_long_divide
