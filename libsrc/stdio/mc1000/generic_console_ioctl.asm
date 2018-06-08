
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	generic_console_cls
	EXTERN	__mc1000_font
	EXTERN	__mc1000_udg
	EXTERN	__mc1000_mode
	EXTERN	__console_h


; a = ioctl
; de = arg
generic_console_ioctl:
	ex	de,hl
	ld	c,(hl)	;bc = where we point to
	inc	hl
	ld	b,(hl)
	cp	IOCTL_GENCON_SET_FONT32
	jr	nz,check_set_udg
	ld	(__mc1000_font),bc
success:
	and	a
	ret
check_set_udg:
	cp	IOCTL_GENCON_SET_UDGS
	jr	nz,check_mode
	ld	(__mc1000_udg),bc
	jr	success
check_mode:
	cp	IOCTL_GENCON_SET_MODE
	jr	nz,failure
	ld	a,c
	ld	l,0x9e
	ld	h,24
	cp	1
	jr	z,set_mode
	ld	h,16
	ld	l,a
	and	a
	jr	z,set_mode
	cp	2
	jr	nz,failure
set_mode:
	ld	a,h
	ld	(__console_h),a
	ld	a,l
	ld	(__mc1000_mode),a
	out	($80),a
	call	generic_console_cls
	jr	success
failure:
	scf
	ret
