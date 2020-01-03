
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	generic_console_cls
	EXTERN	__console_h
	EXTERN	__console_w
	EXTERN	__spc1000_mode
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32
        EXTERN  __tms9918_console_ioctl

	INCLUDE	"target/spc1000/def/spc1000.def"

        EXTERN          generic_console_caps
        PUBLIC          CLIB_GENCON_CAPS
        defc            CLIB_GENCON_CAPS = CAPS_MODE0

        ; Text
        defc    CAPS_MODE0 = CAP_GENCON_INVERSE | CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR
        ; Hires
        defc    CAPS_MODE1 = CAP_GENCON_INVERSE | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS
        ; Colour
        defc    CAPS_MODE2 = CAP_GENCON_INVERSE | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS | CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR


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
	ld	h,@00000000
	ld	l,16
	ld	c,32
	ld	d,CAPS_MODE0
	and	a
	jr	z,set_mode
	ld	h,MODE_1
	ld	l,24
	ld	c,32
	ld	d,CAPS_MODE1
	cp	1		;HIRES
	jr	z,set_mode
	ld	h,MODE_2
	ld	l,24
	ld	c,16
	ld	d,CAPS_MODE2
	cp	2		;COLOUR
	jr	z,set_mode
	cp	10		;Switch to VDP
        jr      c,failure
        ld      c,a
        ld      a,10
	ld	(__spc1000_mode),a
	ld	a,24
	ld	(__console_h),a
	ld	a,d
	ld	(generic_console_caps),a
        ld      a,c
        sub     10
        ld      l,a
        ld      h,0
        push    hl
        ld      hl,0
        add     hl,sp
        ex      de,hl
        ld      a,IOCTL_GENCON_SET_MODE
        call    __tms9918_console_ioctl
        pop     hl
	jr	success

set_mode:
	ld	(__spc1000_mode),a
	ld	a,c
	ld	(__console_w),a
	ld	bc,$2000
	out	(c),h
	ld	a,l
	ld	(__console_h),a
	call	generic_console_cls
	and	a
	ret
failure:
	scf
	ret
