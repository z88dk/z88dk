
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib

	EXTERN	generic_console_cls
	EXTERN	__console_h
	EXTERN	__console_w
	EXTERN	__pc88_mode
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32

	INCLUDE	"ioctl.def"


; a = ioctl
; de = arg
generic_console_ioctl:
	ex	de,hl
	ld	c,(hl)	;bc = where we point to
	inc	hl
	ld	b,(hl)
        cp      IOCTL_GENCON_SET_FONT32
        jr      nz,check_set_udg
        ld      (generic_console_font32),bc
success:
        and     a
        ret
check_set_udg:
        cp      IOCTL_GENCON_SET_UDGS
        jr      nz,check_mode
        ld      (generic_console_udg32),bc
        jr      success
check_mode:
	cp	IOCTL_GENCON_SET_MODE
	jr	nz,failure
	ld	a,c
	and	a
	jr	z,set_mode
	cp	2
	jr	nz,failure
set_mode:
	ld	(__pc88_mode),a
	call	generic_console_cls
	and	a
	ret
failure:
	scf
	ret
