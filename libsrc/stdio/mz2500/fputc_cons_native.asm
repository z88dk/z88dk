
		SECTION	code_clib
		PUBLIC	fputc_cons_native


; (char to print)
fputc_cons_native:
        ld      hl,2
        add     hl,sp
	ld	a,(hl)
	
	cp	12
	jr	nz,nocls
	
	xor a
	rst 18h
	defb 70h	; _TCLR
	ret
	
nocls:
	
	cp	10
	jr	nz,not_lf
	ld	a,13
not_lf:
	
	rst 18h
	defb 03h	; _CRT1C
	ret
