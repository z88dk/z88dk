
		SECTION		code_clib

		PUBLIC		generic_console_vpeek

		EXTERN		__pc6001_mode
		EXTERN		generic_console_text_xypos
		EXTERN		vpeek_MODE1
		EXTERN		vpeek_MODE2

		INCLUDE		"target/pc6001/def/pc6001.def"

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	ld	a,(__pc6001_mode)
	cp	MODE_1
	jp	z,vpeek_MODE1
	cp	MODE_2
	jp	z,vpeek_MODE2
	and	a
	ccf
	ret	nz
        call    generic_console_text_xypos
	ld	a,(hl)
	and	a
	ret
