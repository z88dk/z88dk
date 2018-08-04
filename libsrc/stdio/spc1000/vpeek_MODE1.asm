
		; code_driver to ensure we don't page ourselves out
		SECTION		code_clib

		PUBLIC		vpeek_MODE1
		PUBLIC		vpeek_screendollar

		EXTERN		generic_console_font32
		EXTERN		generic_console_udg32
		EXTERN		screendollar	
		EXTERN		screendollar_with_count



;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
vpeek_MODE1:
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
vpeek_screendollar:
        pop     de              ;the buffer on the stack
        ld      hl,(generic_console_font32)
        call    screendollar
        jr      nc,gotit
        ld      hl,(generic_console_udg32)
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

