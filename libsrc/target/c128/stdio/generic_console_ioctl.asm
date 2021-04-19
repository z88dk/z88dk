
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	defc	CHAR_TABLE = 0x3000

	SECTION	code_clib
	INCLUDE	"ioctl.def"

        PUBLIC          CLIB_GENCON_CAPS
        defc            CLIB_GENCON_CAPS = CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS |CAP_GENCON_FG_COLOUR


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
        ld      a,$8c   ;Character generator to $3000
        ld      bc,$d018
        out     (c),a
	and	a
	ret
check_set_udg:
	cp	IOCTL_GENCON_SET_UDGS
	jr	nz,failure
	ld	de,CHAR_TABLE + 1024
	ld	bc,128 * 8
	ldir
	jr	success
failure:
	scf
	ret
