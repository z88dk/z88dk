
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	generic_console_cls
	EXTERN	__console_h
	EXTERN	__console_w

        PUBLIC          CLIB_GENCON_CAPS
        defc            CLIB_GENCON_CAPS = CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR | CAP_GENCON_INVERSE


; a = ioctl
; de = arg
generic_console_ioctl:
	ex	de,hl
	ld	c,(hl)	;bc = where we point to
	inc	hl
	ld	b,(hl)
check_mode:
	cp	IOCTL_GENCON_SET_MODE
	jr	nz,failure
	ld	a,c		; The mode
	ld	l,40		; columns
	ld	h,@01000000	; Flags for port 10 - TODO, rompack
	and	a
	jr	z,set_mode
	ld	l,80
	ld	h,@01000001	; Flags for port 10 - TODO, rompack
	cp	1
	jr	nz,failure
set_mode:
	ld	a,l
	ld	(__console_w),a
	ld	a,h
	out	($10),a
	call	generic_console_cls
	and	a
	ret
failure:
	scf
	ret
