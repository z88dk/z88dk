
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib

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
        jr      nz,failure
        ld      (generic_console_udg32),bc
        jr      success
failure:
	scf
	ret
