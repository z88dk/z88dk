

		SECTION		code_clib

		PUBLIC		generic_console_vpeek
		EXTERN		__laser500_mode

		EXTERN		generic_console_xypos
		EXTERN		generic_console_font32
		EXTERN		generic_console_udg32
                EXTERN          screendollar
                EXTERN          screendollar_with_count

		INCLUDE		"target/laser500/def/laser500.def"

	

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	ld	a,(SYSVAR_bank1)
	push	af
	ld	a,7
	ld	(SYSVAR_bank1),a
	out	($41),a
        call    generic_console_xypos
	ld	a,(__laser500_mode)
	cp	2
	jr	z,vpeek_hires
	and	a
	jr	nz,skip_40col
	add	hl,bc
skip_40col:
	ld	a,(hl)
	and	127		;Remove inverse flag
	ex	af,af
vpeek_return:
	pop	af
	ld	(SYSVAR_bank1),a
	out	($41),a
	ex	af,af
	ret

vpeek_hires:
	add	hl,bc
	ex	de,hl		;de = screen adddress
        ld      hl,-8
        add     hl,sp           ;hl = buffer, bc = coords
        ld      sp,hl
        push    hl              ;Save buffer
	ex	de,hl		;de = buffer, hl = screen

	ld	b,8
vpeek_hires_loop:
	push	bc
	ld	a,(hl)
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
        rrc     c
        xor     c
        and     0x66
        xor     c
	ld	(de),a
	inc	de
	ld	bc,$800
	add	hl,bc
	pop	bc
	djnz	vpeek_hires_loop
        pop     de      ;de = buffer on stack
        ld      hl,(generic_console_font32)
        call    screendollar
        jr      nc,gotit
        ld      hl,(generic_console_udg32)
        ld      b,128
        call    screendollar_with_count
        jr      c,gotit
        add     128
gotit:
        ex      af,af
        ld      hl,8
        add     hl,sp
        ld      sp,hl
	jr	vpeek_return

