
	MODULE	fputc_cons_native
	SECTION	code_clib

        INCLUDE         "target/fp1100/def/fp1100.def"	
	PUBLIC	fputc_cons_native
	PUBLIC	_fputc_cons_native


fputc_cons_native:
_fputc_cons_native:
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	cp	10
	jr	nz,not_lf
	ld	a,13
not_lf:
	call	PRCRT
	ret

