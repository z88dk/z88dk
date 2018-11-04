
	MODULE	tms9918_console_ioctl
	PUBLIC	__tms9918_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32

IF !FORspc1000 && !FOReinstein && !FORsvi
	PUBLIC		generic_console_ioctl

	defc		generic_console_ioctl = __tms9918_console_ioctl
ENDIF


; a = ioctl
; de = arg
__tms9918_console_ioctl:
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
	jr	nz,failure
	ld	(generic_console_udg32),bc
	jr	success
failure:
	scf
	ret
