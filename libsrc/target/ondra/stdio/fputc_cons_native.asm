
	SECTION	code_clib

	PUBLIC	fputc_cons_native
	PUBLIC	_fputc_cons_native


fputc_cons_native:
_fputc_cons_native:
	ld	hl,2
	add	hl,sp
        ld      a,(hl)
        cp      10
        jr      nz,continue
        ld      a,13
	rst	$10
	ret
continue:
	rst	$10
	ret
