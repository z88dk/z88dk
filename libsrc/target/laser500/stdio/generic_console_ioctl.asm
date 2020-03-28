
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	generic_console_cls
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32
	EXTERN	__laser500_mode
	EXTERN	__console_w

	INCLUDE	"target/laser500/def/laser500.def"

        EXTERN          generic_console_caps
        PUBLIC          CLIB_GENCON_CAPS
        defc            CLIB_GENCON_CAPS = CAPS_MODE0

        ; 40 column 
        defc    CAPS_MODE0 = CAP_GENCON_INVERSE | CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR
        ; 80 column
        defc    CAPS_MODE1 = 0
        ; Hires
        defc    CAPS_MODE2 = CAP_GENCON_INVERSE | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS | CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR | CAP_GENCON_BOLD | CAP_GENCON_UNDERLINE

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
	ld	d,0
	ld	e,80
	ld	b,CAPS_MODE1
	cp	1		;80 column mode
	jr	z,set_mode
	ld	e,40
	ld	b,CAPS_MODE0
	and	a		;40 column mode
	jr	z,set_mode
	cp	2
	jr	nz,failure
	ld	d,8
	ld	b,CAPS_MODE2
	; Value of 2 is GR4 - 320x192
set_mode:
	ld	(__laser500_mode),a
	ld	c,a
	ld	a,b
	ld	(generic_console_caps),a
	ld	a,(SYSVAR_port44)
	and	@11111000
	or	c
	ld	(SYSVAR_port44),a
	out	($44),a
	ld	a,e		;columns
	ld	(__console_w),a
	; Toggle graphics mode
	; We need to enable grpahi
not_graphics_mode:
	ld	a,(SYSVAR_bank1)
	push	af
	ld	a,2
	ld	(SYSVAR_bank1),a
	out	($41),a
	ld	hl,SYSVAR_mem6800
	ld	a,(hl)
	and	@11110111
	or	d
	ld	(hl),a	
	ld	($4000 + $2800),a	;Enable/disable graphics
	pop	af
	ld	(SYSVAR_bank1),a
	out	($41),a
	call	generic_console_cls
	and	a
	ret
failure:
	scf
	ret
