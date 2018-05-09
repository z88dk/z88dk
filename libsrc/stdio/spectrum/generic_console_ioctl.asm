
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	__zx_32col_font
	EXTERN	__zx_64col_font
	EXTERN	__zx_32col_udgs


; a = ioctl
; de = arg
generic_console_ioctl:
	ex	de,hl
	ld	c,(hl)	;bc = where we point to
	inc	hl
	ld	b,(hl)
	cp	IOCTL_GENCON_SET_FONT32
	jr	nz,check_set_font64
	ld	(__zx_32col_font),bc
success:
	and	a
	ret
check_set_font64:
	cp	IOCTL_GENCON_SET_FONT64
	jr	nz,check_set_udg
	ld	(__zx_64col_font),bc
	jr	success
check_set_udg:
	cp	IOCTL_GENCON_SET_UDGS
	jr	nz,failure
	ld	(__zx_32col_udgs),bc
	jr	success
failure:
	scf
	ret
