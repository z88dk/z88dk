
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	__msx_font32
	EXTERN	__msx_udg32


; a = ioctl
; de = arg
generic_console_ioctl:
	ex	de,hl
	ld	c,(hl)	;bc = where we point to
	inc	hl
	ld	b,(hl)
	cp	IOCTL_GENCON_SET_FONT32
	jr	nz,check_set_udg
	ld	(__msx_font32),bc
success:
	and	a
	ret
check_set_udg:
	cp	IOCTL_GENCON_SET_UDGS
	jr	nz,failure
	ld	(__msx_udg32),bc
	jr	success
failure:
	scf
	ret
