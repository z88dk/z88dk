
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl


	EXTERN	__exidy_custom_font

	defc	CHAR_TABLE = 0xfc00

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
	ld	a,h
	or	l	
	jr	z,disable_custom_font
	ld	de,CHAR_TABLE + 32 * 8
	ld	bc,768
	ldir
	ld	a,1
disable_custom_font:
	ld	(__exidy_custom_font),a
success:
	and	a
	ret
check_set_udg:
	cp	IOCTL_GENCON_SET_UDGS
	jr	nz,failure
	ld	a,(__exidy_custom_font)
	ld	bc,128 * 8		;All of them
	and	a
	jr	z,full_udg_bank
	ld	bc,16 * 8		;Otherwise, just 16
full_udg_bank:
	ld	de,CHAR_TABLE 
	ldir
	jr	success
failure:
	scf
	ret
