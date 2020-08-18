


SECTION code_crt0_sccz80
PUBLIC l_long_ne

EXTERN l_long_ucmp

l_long_ne:
	call	l_long_ucmp
	ld	hl,1
	scf
	ret	nz
	dec	hl
	and	a
	ret
