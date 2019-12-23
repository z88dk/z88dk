
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	generic_console_cls
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32
	EXTERN	__mc1000_modeval
	EXTERN	__mc1000_mode
	EXTERN	__console_w

	INCLUDE	"target/mc1000/def/mc1000.def"


	EXTERN		generic_console_caps
        PUBLIC          CLIB_GENCON_CAPS
        defc            CLIB_GENCON_CAPS = CAPS_MODE0

	; Text
	defc	CAPS_MODE0 = 0
	; Hires
	defc	CAPS_MODE1 = CAP_GENCON_INVERSE | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS
	; Colour
	defc	CAPS_MODE2 = CAP_GENCON_INVERSE | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS | CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR


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
	and	31
	ld	e,MODE_1
	ld	d,CAPS_MODE1
	ld	hl,$1820		;rows cols
	cp	1
	jr	z,set_mode
	ld	hl,$1020
	ld	e,MODE_0
	ld	d,CAPS_MODE0
	and	a
	jr	z,set_mode
	ld	hl,$1810
	ld	e,MODE_2
	ld	d,CAPS_MODE2
	cp	2
	jr	nz,failure
set_mode:
	bit	5,c
	jr	z,not_css
	set	1,e
not_css:
	ld	(__mc1000_mode),a
	ld	(__console_w),hl
	ld	a,d
	ld	(generic_console_caps),a
	ld	a,e
	ld	(__mc1000_modeval),a
	out	($80),a
	ld      ($f5),a		;Keep basic up-to-date with mode
        ld      hl,dummy_return
        ld      ($f7),hl        ; cursor flashing and positioning routine
	call	generic_console_cls
	jr	success
failure:
	scf
dummy_return:
	ret
