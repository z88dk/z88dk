
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32
	EXTERN	__cpc_mode
	EXTERN	__console_w
	EXTERN	cpc_setmode
	EXTERN  cpc_set_ansi_palette
	EXTERN  generic_console_cls

        PUBLIC  CLIB_GENCON_CAPS
        defc    CLIB_GENCON_CAPS = CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR | CAP_GENCON_INVERSE | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS


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
	and	a
	ld	h,20
	jr	z,set_mode
	cp	1
	ld	h,40
	jr	z,set_mode
	cp	2
	ld	h,80
	jr	nz,failure
set_mode:
	ld	(__cpc_mode),a
	ld	l,a
	ld	a,h
	ld	(__console_w),a
	ld	a,l
	call	cpc_setmode
	call	cpc_set_ansi_palette
	call	generic_console_cls
	jr	success
failure:
	scf
	ret
