; SVI console driver
;
; Supports:
;   Mode 0:  VDP 32x24
;   Mode 10: SVI806 80x24
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

		EXTERN		l_push_di
		EXTERN		l_pop_ei


		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		PUBLIC		__svi_mode
		EXTERN		__console_w

		INCLUDE		"ioctl.def"

		defc		DISPLAY = $f000

                PUBLIC          CLIB_GENCON_CAPS
                EXTERN          __tms9918_CLIB_GENCON_CAPS
                defc            CLIB_GENCON_CAPS = __tms9918_CLIB_GENCON_CAPS
		EXTERN		generic_console_caps

		defc generic_console_set_attribute = __tms9918_set_attribute
		defc generic_console_set_paper   = __tms9918_set_paper
		defc generic_console_set_ink     = __tms9918_set_ink

generic_console_ioctl:
	cp	IOCTL_GENCON_SET_MODE
	jp	nz, __tms9918_console_ioctl
	; Set the mode here
	ex	de,hl
	ld	a,(hl)
	ld	(__svi_mode),a
	cp	10
	jr	z,set_mode
	ex	de,hl
	ld	a,IOCTL_GENCON_SET_MODE
	jp	__tms9918_console_ioctl

set_mode:
	ld	hl,$1950
	ld	(__console_w),hl
	ld	a,CAP_GENCON_INVERSE
	ld	(generic_console_caps),a
	and	a
	ret

	



generic_console_cls:
	ld	a,(__svi_mode)
	cp	10
	jp	nz,__tms9918_cls
	call	l_push_di
	ld	a,255
	out	($58),a
	xor	a
	ld	hl,DISPLAY
	ld	de,DISPLAY + 1
	ld	bc,80 * 25 - 1
	ld	(hl),a
	ldir
	out	($58),a
	call	l_pop_ei
	ret


generic_console_vpeek:
	ld	a,(__svi_mode)
	cp	10
	jp	nz,__tms9918_console_vpeek
	ld	a,e		;Save raw mode
        call    calc_xypos
	call	l_push_di
	ld	a,255
	out	($58),a
	ld	d,(hl)
	xor	a
	out	($58),a
	call	l_pop_ei
	ld	a,d
	rr	e
	call	nc,vpeek_unmap
	and	a
	ret

vpeek_unmap:
	cp	96 * 2
	ret	nc
	add	32
	res	7,a
        ret


; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	ld	a,(__svi_mode)
	cp	10
	ld	a,d
	jp	nz,__tms9918_printc
	ld	a,d
	rr	e
	call	nc,convert_inverse
	call	calc_xypos
	ld	d,a
	call	l_push_di
	ld	a,255
	out	($58),a
	ld	(hl),d
	xor	a
	out	($58),a
	call	l_pop_ei
	ret

convert_inverse:
	sub	32
	ld	hl,generic_console_flags
	bit	7,(hl)
	ret	z
	add	96
	ret
	

calc_xypos:
	ld	hl,DISPLAY
	ld	de,80
	and	a
	sbc	hl,de
	inc	b
xypos_1:
	add	hl,de
	djnz	xypos_1
	add	hl,bc			;hl is now offset in display
	ret


generic_console_scrollup:
	ld	a,(__svi_mode)
	cp	10
	jp	nz,__tms9918_scrollup
	push	bc
	push	de
	call	l_push_di
	ld	a,255
	out	($58),a
	ld	hl,DISPLAY + 80
	ld	de,DISPLAY
	ld	bc, 24 * 80
	ldir
	ex	de,hl
	ld	b,80
	xor	a
clear_loop:
	ld	(hl),a
	inc	hl
	djnz	clear_loop
	out	($58),a
	call	l_pop_ei	
	pop	de
	pop	bc
	ret


	SECTION		bss_clib

__svi_mode:	defb	0

	SECTION		code_crt_init

	EXTERN		asm_set_cursor_state

	ld	hl,mc6845_init
	ld	c,0
	ld	b,16
init_loop:
	ld	a,c
	out	($50),a
	ld	a,(hl)
	out	($51),a
	inc	hl
	inc	c
	djnz	init_loop

	SECTION	rodata_clib
mc6845_init:
	defb	$6b	;Horizontal total
	defb	$50	;Horizontal displayed
	defb	$58	;Horizontal sync
	defb	$08	;Horizontal + vertical syncs VVVVHHHH
	defb	$26	;Vertical total
	defb 	$05	;Vertical Total adjust
	defb	$18	;Vertical displayed
	defb	$1e	;Vertical sync position
	defb	$00	;Interlace and skew
	defb	$07	;Maximum raster address
	defb	$00	;Cursor start raster
	defb	$00	;Cursor end raster
	defb	$00	;Display start address (high)
	defb	$00	;Display start address (low)
	defb	$00	;Cursor address (high)
	defb	$00	;Cursor address (low)
