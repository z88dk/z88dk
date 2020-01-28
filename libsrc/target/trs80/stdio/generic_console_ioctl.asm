
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	EXTERN	EG2000_ENABLED
	EXTERN	__eg2000_custom_font
	EXTERN	__eg2000_mode

	defc	CHAR_TABLE = 0xF400

	SECTION	code_clib
	INCLUDE	"ioctl.def"

        PUBLIC          CLIB_GENCON_CAPS
        defc            CLIB_GENCON_CAPS = CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS | CAP_GENCON_FG_COLOUR

; a = ioctl
; de = arg
generic_console_ioctl:
	ex	de,hl
	ld	c,(hl)	;hl = source
	inc	hl
	ld	h,(hl)
	ld	l,c
        cp      IOCTL_GENCON_SET_MODE
        jr      nz,check_font32
        ld      a,l
        and     a
        jr      z,set_mode
        ld      a,24            ;use ROM character set
set_mode:
        ld      (__eg2000_mode),a
        jr      success
check_font32:
	cp	IOCTL_GENCON_SET_FONT32
	jr	nz,check_set_udg
	ld	a,h
	or	l	
	jr	z,disable_custom_font
	ld	a,EG2000_ENABLED
	and	a
	jr	z,failure
	ld	de,CHAR_TABLE + 32 * 8
	ld	bc,768
	ldir
	ld	a,1
disable_custom_font:
	ld	(__eg2000_custom_font),a
success:
	and	a
	ret
check_set_udg:
	cp	IOCTL_GENCON_SET_UDGS
	jr	nz,failure
	ld	a,EG2000_ENABLED
	and	a
	jr	z,failure
	ld	a,(__eg2000_custom_font)
	ld	bc,128 * 8		;All of them
	and	a
	jr	z,full_udg_bank
	ld	bc,32 * 8		;Otherwise, just 32
full_udg_bank:
	ld	de,CHAR_TABLE 
	ldir
	jr	success
failure:
	scf
	ret
