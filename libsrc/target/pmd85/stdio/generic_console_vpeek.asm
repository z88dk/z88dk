

        MODULE  generic_console_vpeek
        SECTION code_clib
        PUBLIC  generic_console_vpeek

        EXTERN  generic_console_xypos
        EXTERN  generic_console_font32
        EXTERN  generic_console_udg32
        EXTERN  screendollar
        EXTERN  screendollar_with_count

generic_console_vpeek:
        ld      hl,-8
        add     hl,sp
        ld      sp,hl
        push    hl                ;save buffer
	ex	de,hl
	call	generic_console_xypos
        ; hl = screen address, de = buffer
	ld	a,8
loop:	push	af
	ld	a,(hl)
	and	@00111111
	; And mirror byte
	ld	c,a
        rlca
        rlca
        xor     c
        and     0xaa
        xor     c
        ld      c,a
        rlca
        rlca
        rlca
	ld	b,a
	ld	a,c
	rrca
	ld	c,a
	ld	a,b
        xor     c
        and     0x66
        xor     c
	ld	(de),a
	inc	de
	ld	bc,64
	add	hl,bc
	pop	af
	dec	a
	jr	nz,loop
        pop     de                ;buffer
        ld      hl,(generic_console_font32)
        call    screendollar
        jr      nc,gotit
        ld      hl,(generic_console_udg32)
        ld      b,128
        call    screendollar_with_count
        jr      c,gotit
        add     128
gotit:
	pop	bc
	pop	bc
	pop	bc
	pop	bc
        ret
