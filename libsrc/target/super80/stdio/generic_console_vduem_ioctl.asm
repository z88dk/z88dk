
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	copy_font_8x8
	EXTERN	generic_console_cls
	EXTERN	__super80_custom_font

	PUBLIC  CLIB_GENCON_CAPS
        defc    CLIB_GENCON_CAPS = CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR | CAP_GENCON_INVERSE | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS


; a = ioctl
; de = arg
generic_console_ioctl:
	ex	de,hl
	ld	c,(hl)	;bc = where we point to
	inc	hl
	ld	b,(hl)
	cp	IOCTL_GENCON_SET_FONT32
	jr	nz,check_set_udg
	ld	a,c
	or	b
	ld	(__super80_custom_font),a
	jr	z,success
	ld	hl,$f800 + (32 * 16)		;PCG area
	ld	e,c
	ld	d,b
	ld	c,96
copy_font:
	call	copy_font_8x8
success:
	and	a
	ret
check_set_udg:
	cp	IOCTL_GENCON_SET_UDGS
	jr	nz,failure
	ld	hl,$f800 + (16 * 16)		;PCG area
	ld	e,c
	ld	d,b
	ld	c,128 - 16
	ld	a,(__super80_custom_font)
	and	a
	jr	z,copy_font
	ld	c,16			;If we have a font, then we can have 16 udgs
	jr	copy_font
failure:
	scf
	ret
