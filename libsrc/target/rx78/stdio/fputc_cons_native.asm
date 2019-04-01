
	SECTION	code_clib
	PUBLIC  fputc_cons_native


fputc_cons_native:
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
        cp      10
        jr      nz,not_lf
        ld      a,13
not_lf:
        call    0x07a0
	ret	
