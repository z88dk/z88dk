
		; code_driver to ensure we don't page ourselves out
		SECTION		code_driver

		PUBLIC		generic_console_vpeek

		EXTERN		__mc1000_mode
		EXTERN		generic_console_font32
		EXTERN		__generic_console_udg32
		EXTERN		screendollar	
		EXTERN		screendollar_with_count
		EXTERN		generic_console_calc_xypos


		defc		DISPLAY = 0x8000

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	ld	a,(__mc1000_mode)
	cp	0x9e
	jr	z,vpeek_hires
        call    generic_console_calc_xypos
	out	($80),a
	ld	b,(hl)
	set	0,a
	out	($80),a
	ld	a,b
	and	a
	ret

vpeek_hires:
        ld      hl,-8
        add     hl,sp           ;de = screen, hl = buffer, bc = coords
        ld      sp,hl
        push    hl              ;Save buffer
        ex      de,hl           ;get it into de

        ld      h,b             ; 32 * 8
        ld      l,c
        ld      bc,DISPLAY
        add     hl,bc           ;hl = screen

	ld	a,0x9e
        ld      b,8
vpeek_1:
	res	0,a
	out	($80),a
        ld      c,(hl)
	set	0,a
	out	($80),a
	ex	de,hl
	ld	(hl),c
	ex	de,hl
        ld      a,l
        add     32
        ld      l,a
        jr      nc,no_overflow
        inc     h
no_overflow:
        inc     de
        djnz    vpeek_1
        pop     de              ;the buffer on the stack
        ld      hl,(generic_console_font32)
do_screendollar:
        call    screendollar
        jr      nc,gotit
        ld      hl,(__generic_console_udg32)
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

