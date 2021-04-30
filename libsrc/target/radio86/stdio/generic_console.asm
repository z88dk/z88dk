;
; Generic console that maps into RK86 codes
;


		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		INCLUDE		"ioctl.def"
		PUBLIC          CLIB_GENCON_CAPS
		defc            CLIB_GENCON_CAPS = 0

		INCLUDE		"target/radio86/def/monitor.def"

generic_console_ioctl:
	scf
generic_console_set_attribute:
	ret

generic_console_set_ink:
	ret

generic_console_set_paper:
	ret

generic_console_cls:
        ld      c,$1f
        jp      PUTCHAR

generic_console_scrollup:
	push	de
	push	bc
	ld	hl,$2038
	ld	(printc_str+2),hl
	ld	a,10
	ld	(printc_str+4),a
	ld	hl,printc_str
	call	PRINTSTR
	pop	bc
	pop	hl
	ret



; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
        ld      h,c
        ld      l,b
	ld	de,$2020
	add	hl,de
	ld	(printc_str+2),hl
	ld	(printc_str+4),a
	ld	hl,printc_str
	jp	PRINTSTR

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        ld      h,c
        ld      l,b
	ld	de,$2020
	add	hl,de
	ld	(printc_str+2),hl
	xor	a
	ld	(printc_str+4),a
	ld	hl,printc_str
	call	PRINTSTR
	call	VPEEK
	and	a
	ret

	SECTION	data_clib

printc_str:
	defb	$1b, $59, $20, $20, $20, $00


