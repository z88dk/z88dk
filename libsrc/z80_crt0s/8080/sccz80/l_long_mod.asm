

SECTION code_crt_sccz80
PUBLIC  l_long_mod

EXTERN	l_long_divide

l_long_mod:
	ld	a,128
	jp	l_long_divide
