
		PUBLIC	fputc_cons_rom_rst

		EXTERN	call_rom3

; (char to print)
fputc_cons_rom_rst:
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
	cp	10
	jr	nz,not_lf
	ld	a,13
not_lf:
	ld	hl,23692	;disable the scroll? prompt
	ld	(hl),255
	push	iy		;save callers iy
	ld	iy,0x5c3a
	call	call_rom3
	defw	16
	pop	iy
	ret
