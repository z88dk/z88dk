
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	generic_console_cls
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32
	EXTERN	__vz700_mode
	EXTERN	__console_w

	INCLUDE	"target/vz700/def/vz700.def"


; a = ioctl
; de = arg
generic_console_ioctl:
	ex	de,hl
	ld	c,(hl)	;bc = where we point to
	inc	hl
	ld	b,(hl)
	cp	IOCTL_GENCON_SET_FONT32
	jr	nz,check_set_udg
	ld	(generic_console_font32),bc
success:
	and	a
	ret
check_set_udg:
	cp	IOCTL_GENCON_SET_UDGS
	jr	nz,check_mode
	ld	(generic_console_udg32),bc
	jr	success
check_mode:
	cp	IOCTL_GENCON_SET_MODE
	jr	nz,failure
	ld	a,c
	ld	e,80
	cp	1		;80 column mode
	jr	z,set_mode
	ld	e,40
	and	a		;40 column mode
	jr	nz,failure
	; Graphical modes later
set_mode:
	ld	(__vz700_mode),a
	and	1
	ld	c,a
	ld	a,(SYSVAR_port44)
	or	c
	ld	(SYSVAR_port44),a
	out	($44),a
	ld	a,e		;columns
	ld	(__console_w),a
	call	generic_console_cls
	and	a
	ret
failure:
	scf
	ret
