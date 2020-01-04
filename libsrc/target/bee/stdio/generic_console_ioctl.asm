
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	copy_font_8x8
	EXTERN	generic_console_cls
	EXTERN	__bee_mode
	EXTERN	__console_h
	EXTERN	__console_w
	EXTERN	__bee_custom_font


        PUBLIC          CLIB_GENCON_CAPS
        defc            CLIB_GENCON_CAPS =  CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS | CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR

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
	ld	(__bee_custom_font),a
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
	jr	nz,check_mode
	ld	hl,$f800 + (16 * 16)		;PCG area
	ld	e,c
	ld	d,b
	ld	c,128 - 16
	ld	a,(__bee_custom_font)
	and	a
	jr	z,copy_font
	ld	c,16			;If we have a font, then we can have 16 udgs
	jr	copy_font
check_mode:
	cp	IOCTL_GENCON_SET_MODE
	jr	nz,failure
	ld	a,c
	ld	l,80
	ld	h,24
	ld	de,screen_80x24
	and	a
	jr	z,set_mode
	ld	l,64
	ld	h,16
	ld	de,screen_64x16
	cp	1
	jr	z,set_mode
	ld	l,40
	ld	h,25
	ld	de,screen_40x25
	cp	2
	jr	nz,failure
set_mode:
	ld	(__console_w),hl
	ld	(__bee_mode),a
	ld	c,0
	ld	b,16
vduloop:
	ld	a,c
	out	($c),a
	ld	a,(de)
	out	($d),a
	inc	de
	inc	c
	djnz	vduloop
	call	generic_console_cls
	jr	success
failure:
	scf
dummy_return:
	ret


	SECTION		rodata_clib

screen_80x24:
	defb    $6b, 80,$58,$37,$1b,$05,$18,$1a,$48,$0a,$2a,$0a,$20,0,0,0
;	defb    $6b,$50,$59,$37,$1b,$05,$19,$1b,$48,$0a,$2a,$0a,$20,0,0,0

screen_64x16:
	defb    107,64,81,55,18,9,16,17,$48,$0F,$2F,$0F,0,0,0,0

screen_40x25:
	defb    $35,40,$2D,$24,$1b,$05,$19,$1a,$48,$0a,$2a,$0a,$20,0,0,0
