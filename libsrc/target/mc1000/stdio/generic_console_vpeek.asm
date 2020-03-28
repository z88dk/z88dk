
		; code_driver to ensure we don't page ourselves out
		SECTION		code_driver

		PUBLIC		generic_console_vpeek

		EXTERN		generic_console_calc_xypos
		EXTERN		vpeek_MODE1
		EXTERN		vpeek_MODE2
		EXTERN		__mc1000_mode
		EXTERN		__mc1000_modeval

		defc		DISPLAY = 0x8000

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	ld	a,(__mc1000_mode)
	cp	1
	jp	z,vpeek_MODE1
	cp	2
	jp	z,vpeek_MODE2
        call    generic_console_calc_xypos
	ld	a,(__mc1000_modeval)
	out	($80),a
	ld	b,(hl)
	set	0,a
	out	($80),a
	ld	a,b
	and	a
	ret

