
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	generic_console_cls
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32
	EXTERN	__gal_mode
	EXTERN	__console_w

	EXTERN	__CLIB_DISABLE_MODE1

	; Set bit 1 for hires
	defc	LATCH = $2038

	EXTERN	generic_console_caps
        PUBLIC  CLIB_GENCON_CAPS
        defc    CLIB_GENCON_CAPS = CAPS_MODE0

	defc	CAPS_MODE0 = 0
	defc	CAPS_MODE1 = CAP_GENCON_INVERSE | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS | CAP_GENCON_BOLD | CAP_GENCON_UNDERLINE

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
	ld	a,__CLIB_DISABLE_MODE1
	and	a
	jr	nz,failure
	ld	hl,$1020
	ld	a,c
	and	a
	ld	c,$80
	ld	d,CAPS_MODE0
	jr	z,set_mode
	cp	1
	jr	nz,failure
	call	$e057
	ld	a,$ff
	ld	($2ba8),a
	ld	a,1
	ld	hl,$1a20
	ld	c,2
	halt
	im	2
	ld	d,CAPS_MODE1
set_mode:
	ld	(__gal_mode),a
	and	a
	jr	nz,not_mode0
 	ld	a,$c
	ld	($2ba8),a
	halt
	im	1
not_mode0:
	ld	(__console_w),hl
	ld	a,d
	ld	(generic_console_caps),a
	;ld	a,c
	;ld	(LATCH),a
	call	generic_console_cls
	jr	success
failure:
	scf
	ret
