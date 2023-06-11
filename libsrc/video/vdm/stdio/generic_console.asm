

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute
                PUBLIC          generic_console_plotc
                PUBLIC          generic_console_pointxy
                EXTERN		generic_console_flags

		defc VDM_COLUMNS = 64
		defc VDM_ROWS = 16
		
		EXTERN		VDM_DISPLAY
                EXTERN          VDM_CAPS
                EXTERN          VDM_CAPS_MASK

		PUBLIC		GRAPHICS_CHAR_SET
		PUBLIC		GRAPHICS_CHAR_UNSET
		defc		GRAPHICS_CHAR_SET = $80 + 32
		defc		GRAPHICS_CHAR_UNSET = 32

		

		INCLUDE	"ioctl.def"
	        PUBLIC  CLIB_GENCON_CAPS
		defc	CLIB_GENCON_CAPS = VDM_CAPS

generic_console_ioctl:
	scf
generic_console_set_ink:
generic_console_set_paper:
generic_console_set_attribute:
	ret

generic_console_cls:
	ld	hl,VDM_DISPLAY
	ld	de,VDM_DISPLAY+1
	ld	bc,+(VDM_COLUMNS * VDM_ROWS) -1
	ld	(hl),32
	ldir
	ret


; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_plotc:
	call	xypos
	ld	(hl),d
	ret

generic_console_printc:
	call	xypos
	ld	a,(generic_console_flags)
        and     VDM_CAPS_MASK
        jp      z,add_bit
        scf
add_bit:
        ld      a,0
        rra
	or	d
	ld	(hl),a
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_pointxy:
	call	xypos
	ld	a,(hl)
	and	a
	ret

generic_console_vpeek:
        call    xypos
	ld	a,(hl)
	and	127
	ret


; b = row
; c = column
xypos:
	ld	l,b
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ld	b,+(VDM_DISPLAY / 256)
	add	hl,bc
	ret

; There's actually a scroll register that we could use instead
; (similar to the vector06c one)
generic_console_scrollup:
	push	de
	push	bc
	ld	hl, VDM_DISPLAY + VDM_COLUMNS
	ld	de, VDM_DISPLAY
	ld	bc,+ ((VDM_COLUMNS) * (VDM_ROWS-1))
	ldir
	ex	de,hl
	ld	b,VDM_COLUMNS
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	pop	bc
	pop	de
	ret

	SECTION code_crt_init

	EXTERN	__console_h
	EXTERN	__console_w

	xor	a
	out	(200),a		;Enable the board
	ld	a,VDM_ROWS
	ld	(__console_h),a
	ld	a,VDM_COLUMNS
	ld	(__console_w),a
