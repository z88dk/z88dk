

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

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		

		INCLUDE	"ioctl.def"
	        PUBLIC  CLIB_GENCON_CAPS
		defc	CLIB_GENCON_CAPS = CAP_GENCON_UNDERLINE

generic_console_ioctl:
	scf
generic_console_set_ink:
generic_console_set_paper:
generic_console_set_attribute:
	ret

generic_console_cls:
        ld      a,(__pk8000_text)
        ld      h,a
	ld	l,0
	ld	bc,+(64 * CONSOLE_ROWS) -1
cls_1:
	ld	(hl),32
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jp	nz,cls_1
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
	ld	(hl),d
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_pointxy:
        call    xypos
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
        ld      a,(__pk8000_text) 
	ld	b,a
	add	hl,bc
	ret


generic_console_scrollup:
	push	de
	push	bc

	pop	bc
	pop	de
	ret

	SECTION bss_clib

__pk8000_text:	defb	0
