
		SECTION		code_clib

		PUBLIC		generic_console_vpeek

		EXTERN		__sv8000_mode
		EXTERN		generic_console_text_xypos
		EXTERN		vpeek_MODE1

		INCLUDE		"target/sv8000/def/sv8000.def"

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	ld	a,(__sv8000_mode)
	cp	MODE_1
	jp	z,vpeek_MODE1
	and	a
	ccf
	ret	nz
        call    generic_console_text_xypos
	ld	a,(hl)
	and	a
	ret
