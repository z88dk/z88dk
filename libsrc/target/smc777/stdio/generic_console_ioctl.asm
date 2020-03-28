
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	generic_console_cls
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32
	EXTERN	__smc777_mode
	EXTERN	__console_h
	EXTERN	__console_w
	EXTERN	copy_font_8x8

        PUBLIC  CLIB_GENCON_CAPS
        defc    CLIB_GENCON_CAPS = CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS | CAP_GENCON_FG_COLOUR 


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
	ld	l,c
	ld	h,b
	ld	bc, $1000 + (8 * 32)
	ld	e,96
	call	copy_font_8x8
success:
	and	a
	ret
check_set_udg:
	cp	IOCTL_GENCON_SET_UDGS
	jr	nz,check_mode
	ld	(generic_console_udg32),bc
	ld	l,c
	ld	h,b
	ld	bc, $1000 + (8 * 128)
	ld	e,128
	call	copy_font_8x8
	jr	success
check_mode:
	cp	IOCTL_GENCON_SET_MODE
	jr	nz,failure
	ld	a,c
	ld	d,80
	ld	l,@00000000	;Bit 7=0=80 column mode
	and	1
	jr	z,check_graphics
	ld	d,40
	ld	l,@10000000	;Bit 7=1=40 column
	cp	1
	jr	nz,failure
check_graphics:
	; Now, consider the graphics mode
	ld	a,c
	and	@00001100
	jr	z,set_mode	;No graphics mode configured (so lores)
	; 11 = 640x400x1
	; 10 = 640x200x2
	; 01 = 320x200x4
	or	l
	ld	l,a
set_mode:
	ld	a,c		;Full mode flag
	ld	(__smc777_mode),a
	ld	a,d
	ld	(__console_w),a
	in	a,($20)
	and	@00110011
	or	l
	out	($20),a
	call	generic_console_cls
	jr	success
failure:
	scf
	ret
