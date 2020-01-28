
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib

	EXTERN	generic_console_cls
	EXTERN	__console_h
	EXTERN	__console_w
	EXTERN	__sv8000_mode
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32

	INCLUDE	"target/sv8000/def/sv8000.def"
	INCLUDE	"ioctl.def"

	EXTERN	generic_console_caps
        PUBLIC  CLIB_GENCON_CAPS
	defc	CLIB_GENCON_CAPS = CAPS_MODE0
	
	defc	CAPS_MODE0 = 0
	defc	CAPS_MODE1 = CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS | CAP_GENCON_INVERSE


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
	ld	a,c		; The mode
	and	31
	ld	de,$1020	; rows, cols
	ld	h,MODE_0
	ld	b,CAPS_MODE0
	and	a
	jr	z,set_mode
	ld	h,MODE_1
	ld	b,CAPS_MODE1
	ld	de,$0c20	; rows, cols
	cp	1		;HIRES
	jr	nz,failure
set_mode:
	bit	5,c
	jr	z,not_css
	set	4,h
not_css:
	ld	a,e
	ld	(__console_w),a
	ld	a,d
	ld	(__console_h),a
	ld	a,b
	ld	(generic_console_caps),a
	ld	a,14
	out	($c1),a
	ld	a,h
	ld	(__sv8000_mode),a
	out	($c0),a
	call	generic_console_cls
	and	a
	ret
failure:
	scf
	ret
