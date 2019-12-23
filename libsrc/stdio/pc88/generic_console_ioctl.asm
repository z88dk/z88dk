
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib

	EXTERN	generic_console_cls
	EXTERN	__console_h
	EXTERN	__console_w
	EXTERN	__pc88_mode
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32
	EXTERN	pc88bios

	INCLUDE	"ioctl.def"

	PUBLIC  CLIB_GENCON_CAPS
	defc    CLIB_GENCON_CAPS = CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR | CAP_GENCON_INVERSE | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS

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
	ld	bc,$5019
	and	a
	jr	z,set_mode
	cp	2
	jr	z,set_mode
	cp	1
	ld	bc,$2519
	jr	nz,failure
set_mode:
	ld	(__pc88_mode),a
	ld	a,b
	ld	(__console_w),a
	ld	a,c
	ld	(__console_h),a
        ld      ix,$6f6b                ; CRTSET
        call    pc88bios
	call	generic_console_cls
	and	a
	ret
failure:
	scf
	ret
