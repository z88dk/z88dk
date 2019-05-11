
	MODULE	generic_consoel_vpeek
	
	PUBLIC	generic_console_pointxy
	PUBLIC  generic_console_vpeek

	EXTERN	__gal_mode
	EXTERN	vpeek_MODE1
	EXTERN	generic_console_text_xypos


generic_console_pointxy:
        call    generic_console_vpeek
        and     a
        ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        ld      a,(__gal_mode)
        cp      1
        jp      z,vpeek_MODE1
        call    generic_console_text_xypos
        ld      a,(hl)
        and     a
        ret
