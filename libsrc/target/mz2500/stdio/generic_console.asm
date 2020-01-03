;
;

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute

		EXTERN		__console_w
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		conio_map_colour


		INCLUDE		"target/mz2500/def/svc.inc"
		INCLUDE		"ioctl.def"

		PUBLIC          CLIB_GENCON_CAPS
		defc            CLIB_GENCON_CAPS = CAP_GENCON_FG_COLOUR


generic_console_ioctl:
        ex      de,hl
        ld      c,(hl)  ;bc = where we point to
        inc     hl
        ld      b,(hl)
	cp      IOCTL_GENCON_SET_MODE
        jr      nz,failure
	ld	a,c
	ld	b,@00000001
	ld	c,40
	and	a
	jr	z,setmode
	ld	b,@00000000
	ld	c,80
	dec	a
	jr	z,setmode
failure:
	scf
	ret

setmode:
	ld	a,c
	ld	(__console_w),a
	ld	a,b
	rst	$18
	defb	_TWID
	call	generic_console_cls
	and	a
	ret

generic_console_set_attribute:
	ret

generic_console_set_ink:
	call	conio_map_colour
	and	7
	ld	c,a
	ld	hl,COLORA
	ld	a,(hl)
	and	@11111000
	or	c
	ld	(COLORA),a
	ret

generic_console_set_paper:
	ret

generic_console_cls:
	xor	a
	ld	hl,0
	ld	de,(__console_w)
	rst	$18
	defb	_TCLR
	ret

generic_console_scrollup:
	push	de
	push	bc
	xor	a
	rst	$18
	defb	_TSCRL
	pop	bc
	pop	de
	ret

; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
	ld	a,c
	ld	(CURX),a
	ld	a,b
	ld	(CURY),a
	ld	a,d
	rst	$18
	defb	_CRT1C
	ret
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	ld	l,c
	ld	h,b
	ld	c,1
	rst	$18
	defb	_TGET
	ld	a,(de)
	and	a
	ret


	SECTION		data_clib

	SECTION		bss_clib
