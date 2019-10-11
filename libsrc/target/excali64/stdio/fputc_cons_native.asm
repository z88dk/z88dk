
		SECTION	code_clib
		PUBLIC	fputc_cons_native


; (char to print)
fputc_cons_native:
	ld      hl,2
	add     hl,sp
	ld	a,(hl)
	cp	10
	jr	nz,not_lf
	ld	a,13
not_lf:
	jp	$0040
