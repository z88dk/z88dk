
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	defc	CHAR_TABLE = 0x2C00

	SECTION	code_clib
	INCLUDE	"ioctl.def"

        PUBLIC          CLIB_GENCON_CAPS
        defc            CLIB_GENCON_CAPS = CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS


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
	ld	de,CHAR_TABLE + 256
	ld	bc,768
	ldir
success:
	and	a
	ret
check_set_udg:
	cp	IOCTL_GENCON_SET_UDGS
	jr	nz,failure
	ld	de,CHAR_TABLE
	ld	bc,32 * 8
	ldir
	jr	success
failure:
	scf
	ret
