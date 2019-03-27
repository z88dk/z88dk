
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	generic_console_cls
	EXTERN	__zx_32col_font
	EXTERN	__zx_64col_font
	EXTERN	__zx_32col_udgs
	EXTERN	__ts2068_hrgmode
	EXTERN	__console_w


; a = ioctl
; de = arg
generic_console_ioctl:
	ex	de,hl
	ld	c,(hl)	;bc = where we point to
	inc	hl
	ld	b,(hl)
	cp	IOCTL_GENCON_SET_FONT32
	jr	nz,check_set_font64
	ld	(__zx_32col_font),bc
success:
	and	a
	ret
check_set_font64:
	cp	IOCTL_GENCON_SET_FONT64
	jr	nz,check_set_udg
	ld	(__zx_64col_font),bc
	jr	success
check_set_udg:
	cp	IOCTL_GENCON_SET_UDGS
	jr	nz,check_mode
	ld	(__zx_32col_udgs),bc
	jr	success
check_mode:
IF FORts2068
	cp	IOCTL_GENCON_SET_MODE
	jr	nz,failure
	ld	a,c
	and	7
	; 0 = screen 0
	; 1 = screen 1
	; 2 = high colour
	; 6 = hires
	ld	l,64
	cp	0
	jr	z,set_mode
	cp	1
	jr	z,set_mode
	cp	2
	jr	z,set_mode
	cp	6
	jr	nz,failure
	ld	l,128
set_mode:
	ld	(__ts2068_hrgmode),a
	ld	a,l
	ld	(__console_w),a
	in	a,($ff)
	and	@1100000
	ld	b,a
	ld	a,c
	and	@00111111
	or	b
	out	($ff),a
	call	generic_console_cls
	jr	success
ENDIF
failure:
	scf
	ret
