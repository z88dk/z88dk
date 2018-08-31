
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	EXTERN	set_character8
	EXTERN	__vg5k_custom_font

	SECTION	code_clib
	INCLUDE	"ioctl.def"


; a = ioctl
; de = arg
generic_console_ioctl:
	ex	de,hl
	ld	c,(hl)	;hl = source
	inc	hl
	ld	h,(hl)
	ld	l,c
	cp	IOCTL_GENCON_SET_FONT32
	jr	nz,check_set_udg
	ld	a,1
	ld	(__vg5k_custom_font),a
	ld	b,96
	ld	c,32
set_font:
	push	bc
	push	hl
	call	set_character8
	pop	hl
	pop	bc
	inc	c
	ld	de,8
	add	hl,de	
	djnz	set_font
success:
	and	a
	ret
check_set_udg:
	cp	IOCTL_GENCON_SET_UDGS
	jr	nz,failure
	ld	b,128 - 32
	ld	c,128 + 32
	jr	set_font
failure:
	scf
	ret
