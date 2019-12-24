
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	generic_console_cls
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32
	EXTERN	__multi8_mode
	EXTERN	__console_h
	EXTERN	__console_w
	EXTERN	__port29_copy
	EXTERN	__vram_in


        EXTERN          generic_console_caps
        PUBLIC          CLIB_GENCON_CAPS
        defc            CLIB_GENCON_CAPS = CAPS_MODE0

        defc    CAPS_MODE0 = CAP_GENCON_INVERSE | CAP_GENCON_FG_COLOUR 
        defc    CAPS_MODE1 = CAP_GENCON_INVERSE | CAP_GENCON_FG_COLOUR
        ; Colour
        defc    CAPS_MODE2 = CAP_GENCON_INVERSE | CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS | CAP_GENCON_FG_COLOUR 

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
	cp	1
	jr	z,set_mode_1
	and	a
	jr	z,set_mode_0
	cp	2
	jr	nz,failure
set_mode_2:		;Graphics
	in	a,($2a)
	and	@00100000		;Keep lower RAM page
	or	@00011000		;Page in all graphics pages
	ld	l,a
	ld	a,(__port29_copy)
	ld	h,80
	ld	d,CAPS_MODE2
	and	@10111111		;Bit 6 = 0 = 40 column
set_mode:
	ld	(__port29_copy),a
	out	($29),a
	ld	a,c
	ld	(__multi8_mode),a
	ld	a,h
	ld	(__console_w),a
	ld	a,l
	ld	(__vram_in),a
	ld	a,d
	ld	(generic_console_caps),a
	call	generic_console_cls
	jr	success
set_mode_1:		; 80 col text
	in	a,($2a)
	and	@00100111		;Keep lower RAM page
	or	@00010111		;Page in text page
	ld	l,a
	ld	a,(__port29_copy)
	and	@00111111		;Bit 6 = 1 = 80 column
	or	@01000000		
	ld	h,80
	ld	d,CAPS_MODE1
	jr	set_mode
set_mode_0:		; 40 col text
	in	a,($2a)
	and	@00100111		;Keep lower RAM page
	or	@00010111		;Page in all text page 
	ld	l,a
	ld	a,(__port29_copy)
	and	@00111111		;Bit 6 = 0 = 40 column
	ld	h,40
	ld	d,CAPS_MODE0
	jr	set_mode
failure:
	scf
	ret
