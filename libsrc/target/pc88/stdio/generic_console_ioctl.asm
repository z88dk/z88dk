
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib

	EXTERN	generic_console_cls
	EXTERN	__console_h
	EXTERN	__console_w
	EXTERN	__pc88_mode
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32
	EXTERN	generic_console_caps
	EXTERN	pc88bios

	INCLUDE	"ioctl.def"

	PUBLIC  CLIB_GENCON_CAPS
	defc    CLIB_GENCON_CAPS = 0

	defc    CLIB_GENCON_CAPS_MODE2 = CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR | CAP_GENCON_INVERSE | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS | CAP_GENCON_BOLD | CAP_GENCON_UNDERLINE

	EXTERN	__CLIB_PC8800_HAS_BASIC

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
	ld	l,CLIB_GENCON_CAPS
	and	a
	jr	z,set_mode
	ld	l,CLIB_GENCON_CAPS_MODE2
	cp	2
	jr	z,set_mode
	ld	l,CLIB_GENCON_CAPS
	cp	1
	ld	bc,$2819
	jr	nz,failure
set_mode:
	ld	(__pc88_mode),a
	ld	h,a		;Save mode
	ld	a,b
	ld	(__console_w),a
	ld	a,c
	ld	(__console_h),a
	ld	a,l
	ld	(generic_console_caps),a
	ld	a,__CLIB_PC8800_HAS_BASIC
	and	a
	push	af
	call	z,set_mode_direct
	pop	af
        ld      ix,$6f6b                ; CRTSET
        call    nz,pc88bios
	call	generic_console_cls
	and	a
	ret
failure:
	scf
	ret

; We're only considering the text resolution here
; h = mode
set_mode_direct:
	ld      c,%00000000     ; 40 column text mode + colour
	dec	h
	jr	z,out_mode
	ld	c,%00000001	; 80 column text mode + colour
out_mode:
	ld	a,c
        out     ($30),a
	ret

