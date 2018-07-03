
		; code_driver to ensure we don't page ourselves out
		SECTION		code_driver

		PUBLIC		generic_console_vpeek

		EXTERN		__spc1000_mode
		EXTERN		__spc1000_font
		EXTERN		__spc1000_udg
		EXTERN		screendollar	
		EXTERN		screendollar_with_count
		EXTERN		generic_console_calc_xypos



;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	ld	a,(__spc1000_mode)
	cp	1
	jr	z,vpeek_hires
        call    generic_console_calc_xypos
	ld	c,l
	ld	b,h
	in	a,(c)	;TODO, lower case
	and	a
	ret

vpeek_hires:
        ld      hl,-8
        add     hl,sp           ;de = screen, hl = buffer, bc = coords
        ld      sp,hl
        push    hl              ;Save buffer
        ld      a,8
vpeek_1:
	ex	af,af
	in	a,(c)
	ld	(hl),a
        ld      a,c
        add     32
        ld      c,a
        jr      nc,no_overflow
        inc     b
no_overflow:
        inc     hl
	ex	af,af
	dec	a
	jr	nz,vpeek_1
        pop     de              ;the buffer on the stack
        ld      hl,(__spc1000_font)
do_screendollar:
        call    screendollar
        jr      nc,gotit
        ld      hl,(__spc1000_udg)
        ld      b,128
        call    screendollar_with_count
        jr      c,gotit
        add     128
gotit:
        ex      af,af           ; Save those flags
        ld      hl,8            ; Dump our temporary buffer
        add     hl,sp
        ld      sp,hl
        ex      af,af           ; Flags and parameter back
        ret

