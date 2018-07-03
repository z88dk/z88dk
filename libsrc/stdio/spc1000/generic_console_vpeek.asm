
		; code_driver to ensure we don't page ourselves out
		SECTION		code_driver

		PUBLIC		generic_console_vpeek

		EXTERN		__spc1000_mode
		EXTERN		generic_console_font32
		EXTERN		generic_console_udg32
		EXTERN		screendollar	
		EXTERN		screendollar_with_count
		EXTERN		generic_console_calc_xypos
		EXTERN		tms9918_console_vpeek



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
	cp	10
	jp	z,tms9918_console_vpeek
        call    generic_console_calc_xypos
	ld	c,l
	ld	b,h
	in	a,(c)
	set	3,b
	in	l,(c)
	bit	3,l
	jr	nz,lower_case
	bit	2,l
	jr	nz,high_chars
done:
	and	a
	ret
lower_case:
	cp	$60
	jr	nc,done
	or	128
	jr	done
high_chars:
	and	$0f
	or	$e0
	jr	done


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

