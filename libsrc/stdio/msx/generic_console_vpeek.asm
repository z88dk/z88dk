

	MODULE	generic_console_vpeek
	SECTION	code_lib
	PUBLIC	generic_console_vpeek

	EXTERN	LDIRMV
	EXTERN	__msx_font32
	EXTERN	screendollar
	EXTERN	msxbios

generic_console_vpeek:
	push	ix
        ld      a,c
        add     a
        add     a
        add     a
        ld      e,a	
        ld      d,b
	ld	hl,-8
	add	hl,sp
	push	hl		;save buffer
	; de = VDP address
	; hl = buffer
	ex	de,hl
	ld	ix,LDIRMV
	ld	bc,8
	call	msxbios
	pop	de		;buffer
	ld	hl,(__msx_font32)
	call	screendollar
        pop     ix
        ret
