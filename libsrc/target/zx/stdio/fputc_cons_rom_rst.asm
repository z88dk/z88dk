
		SECTION	code_clib
		PUBLIC	fputc_cons_rom_rst

		EXTERN	call_rom3

; (char to print)
fputc_cons_rom_rst:
        ld      hl,2
        add     hl,sp
	ld	b,(hl)
	ld	hl,skip_count
	ld	a,(hl)
	and	a
	ld	a,b
	jr	z,continue
	dec	(hl)
	jr	direct
continue:
	cp	22		;move to
	jr	nz,not_posn
	ld	(hl),2
not_posn:
	cp	10
	jr	nz,not_lf
	ld	a,13
not_lf:
direct:
	ld	hl,23692	;disable the scroll? prompt
	ld	(hl),255
	push	iy		;save callers iy
	ld	iy,0x5c3a
	call	call_rom3
	defw	16
	pop	iy
	ret

	SECTION	bss_clib

skip_count:	defb	0
