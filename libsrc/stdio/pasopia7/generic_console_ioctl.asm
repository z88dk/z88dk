
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	generic_console_cls
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32
	EXTERN	__console_h
	EXTERN	__console_w

	INCLUDE	"target/pasopia7/def/pasopia7.def"

        PUBLIC          CLIB_GENCON_CAPS
        defc            CLIB_GENCON_CAPS = CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS | CAP_GENCON_FG_COLOUR | CAP_GENCON_INVERSE


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
	ld	e,40
	ld	d,@00000000
	ld	hl,mode40
	and	a
	jr	z,set_mode
	ld	e,80
	ld	d,@00100000
	ld	hl,mode80
	cp	1
	jr	nz,failure
set_mode:
	; e = number of columns
	; d = value to write to mode port
	; hl = 6845 registers to write
	ld	a,e
	ld	(__console_w),a
	ld	a,d
	out	(SCR_MODE),a
	; Values are written at 4dcd in bios.rom
        ld      c,0
        ld      b,16
vduloop:
        ld      a,c
        out     ($10),a
        ld      a,(hl)
        out     ($11),a
        inc     hl
        inc     c
        djnz    vduloop
        call    generic_console_cls
        jr      success
failure:
	scf
	ret


mode80:
	defb	$71, $50, $5c, $38, $1f, $06, $19, $1c
	defb	$40, $07, $20, $07, $00, $00, $00, $50

mode40:
	defb	$38, $28, $2f, $34, $1f, $06, $19, $1c
	defb	$40, $07, $20, $07, $00, $00, $00, $43

else:
	defb	$5d, $50, $52, $1e, $03, $00, $04, $00
