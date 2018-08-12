
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib

	EXTERN	generic_console_cls
	EXTERN	__console_h
	EXTERN	__console_w
	EXTERN	__pc6001_mode
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32

	INCLUDE	"target/pc6001/def/pc6001.def"
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
        jr      nz,check_mode
        ld      (generic_console_udg32),bc
        jr      success
check_mode:
	cp	IOCTL_GENCON_SET_MODE
	jr	nz,failure
	ld	a,c		; The mode
	and	31
	ld	e,32		;columns
	ld	h,MODE_0
	ld	l,16
	and	a
	jr	z,set_mode
	ld	h,MODE_1
	ld	l,24
	cp	1		;HIRES
	jr	z,set_mode
	ld	e,16
	ld	h,MODE_2
	cp	2		;Half hires
	jr	nz,failure
set_mode:
	bit	5,c
	jr	z,not_css
	set	1,h
not_css:
	ld	a,e
	ld	(__console_w),a
	ld	a,h
	ld	(__pc6001_mode),a
	ld	a,l
	ld	(__console_h),a
	call	generic_console_cls
	and	a
	ret
failure:
	scf
	ret
