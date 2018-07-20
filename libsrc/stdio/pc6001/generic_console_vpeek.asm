
		; code_driver to ensure we don't page ourselves out
		SECTION		code_clib

		PUBLIC		generic_console_vpeek

		EXTERN		__pc6001_mode
		EXTERN		generic_console_font32
		EXTERN		generic_console_udg32
		EXTERN		screendollar	
		EXTERN		screendollar_with_count
		EXTERN		generic_console_text_xypos

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
	jr	z,vpeek_hires
        call    generic_console_text_xypos
	ld	a,(hl)
	and	a
	ret


vpeek_hires:
        ld      hl,-8
        add     hl,sp           
        ld      sp,hl
        push    hl              ;Save buffer
        ex      de,hl           ;get it into de

        ld      h,b             ; 32 * 8
        ld      l,c
        ld      bc,(SYSVAR_screen - 1)
        ld      c,0
        add     hl,bc           ;hl = screen
	inc	h
	inc	h

        ld      b,8
vpeek_1:
	ld	a,(hl)
	ld	(de),a
	inc	de
	ld	a,l
	add	32
	ld	l,a
	jr	nc,no_overflow
	inc	h
no_overflow:
	djnz	vpeek_1
        pop     de              ;the buffer on the stack
        ld      hl,(generic_console_font32)
do_screendollar:
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

