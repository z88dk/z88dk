;
;


		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_ioctl


		EXTERN		__tms9918_cls
		EXTERN		__tms9918_console_vpeek
		EXTERN		__tms9918_scrollup
		EXTERN		__tms9918_printc
		EXTERN		__tms9918_console_ioctl
                EXTERN          __tms9918_set_ink
                EXTERN          __tms9918_set_paper
                EXTERN          __tms9918_set_attribute
		EXTERN		generic_console_flags


		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		PUBLIC		__einstein_mode
		EXTERN		__console_w

		EXTERN		generic_console_caps

		INCLUDE		"ioctl.def"

		PUBLIC          CLIB_GENCON_CAPS
		EXTERN		__tms9918_CLIB_GENCON_CAPS
       		defc            CLIB_GENCON_CAPS = __tms9918_CLIB_GENCON_CAPS


		defc generic_console_set_attribute = __tms9918_set_attribute
		defc generic_console_set_paper   = __tms9918_set_paper
		defc generic_console_set_ink     = __tms9918_set_ink

generic_console_ioctl:
	cp	IOCTL_GENCON_SET_MODE
	jp	nz, __tms9918_console_ioctl
	; Set the mode here
	ex	de,hl
	ld	a,(hl)
	ld	bc,$1950
	cp	10
	jr	z,set_mode
	xor	a
	ld	(__einstein_mode),a
	ld	a,IOCTL_GENCON_SET_MODE
	ex	de,hl
	jp	__tms9918_console_ioctl

set_mode:
	ld	(__einstein_mode),a
	ld	a,CAP_GENCON_INVERSE
	ld	(generic_console_caps),a
	ld	(__console_w),bc
	and	a
	ret


generic_console_cls:
	ld	a,(__einstein_mode)
	cp	10
	jp	nz,__tms9918_cls
	; Clear the 80 column screen
	ld	hl, 80 * 25
	ld	de, 0x4000
	ld	a,' '
cls_loop:
	ld	c,d
	ld	b,e
	ld	a,32
	out	(c),a
	inc	de
	dec	hl
	ld	a,h
	or	l
	jr	nz,cls_loop
	ret


generic_console_vpeek:
	ld	a,(__einstein_mode)
	cp	10
	jp	nz,__tms9918_console_vpeek
	ld	a,e		;Save raw mode
        call    calc_xypos
	ld	e,a		;Raw mode back
	in	a,(c)
	rr	e
	call	nc,vpeek_unmap
	and	a
	ret

vpeek_unmap:
	cp	160		;Inverse characters are from 160
	ret	c
	sub	128
        ret


; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	ld	a,(__einstein_mode)
	cp	10
	ld	a,d
	jp	nz,__tms9918_printc
	rr	e
	call	nc,convert_inverse
	call	calc_xypos
	out	(c),a
	ret

convert_inverse:
	ld	hl,generic_console_flags
	bit	7,(hl)
	ret	z
	cp	128
	ret	nc
	set	7,a
	ret
	

calc_xypos:
	ld	hl,0x4000
	ld	de,80
	ld	d,0
	and	a
	sbc	hl,de
	inc	b
xypos_1:
	add	hl,de
	djnz	xypos_1
	add	hl,bc			;hl is now offset in display
	ld	c,h
	ld	b,l
	ret


generic_console_scrollup:
	ld	a,(__einstein_mode)
	cp	10
	jp	nz,__tms9918_scrollup
	push	bc
	push	de
	ld	b,24
	ld	hl,$4050		;Row 1
	ld	de,80			;Characters in row
row_loop:
	ld	c,80
char_loop:
	push	bc
	push	hl
	ld	c,h
	ld	b,l
	in	a,(c)			;Byte to move
	and	a
	sbc	hl,de
	ld	c,h
	ld	b,l
	out	(c),a
	pop	hl
	inc	hl
	pop	bc
	dec	c
	jr	nz,char_loop
	djnz	row_loop
	and	a
	sbc	hl,de		;hl = start of last row
	ld	e,80
	ld	d,' '
clear_loop:
	ld	c,h
	ld	b,l
	out	(c),d
	inc	hl
	dec	e
	jr	nz,clear_loop
	pop	de
	pop	bc
	ret

	SECTION	code_crt_init

	EXTERN	asm_set_cursor_state
	EXTERN	msx_set_mode
	ld	hl,$fb45
	res	0,(hl)		;DOS80 disable cursor
	res	2,(hl)		;XTAL 80 column cursor flag
	ld	l,$20
	call	asm_set_cursor_state
        ld      hl,2
        call    msx_set_mode

	SECTION		bss_clib

__einstein_mode:	defb	0

