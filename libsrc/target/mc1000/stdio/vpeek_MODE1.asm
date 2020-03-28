
		; code_driver to ensure we don't page ourselves out
		SECTION		code_driver

		PUBLIC		vpeek_MODE1
		EXTERN		vpeek_screendollar
		EXTERN		__mc1000_modeval

		defc		DISPLAY = 0x8000

;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
vpeek_MODE1:
        ld      hl,-8
        add     hl,sp           ;de = screen, hl = buffer, bc = coords
        ld      sp,hl
        push    hl              ;Save buffer
        ex      de,hl           ;get it into de

        ld      h,b             ; 32 * 8
        ld      l,c
        ld      bc,DISPLAY
        add     hl,bc           ;hl = screen

        ld      b,8
vpeek_1:
	ld	a,(__mc1000_modeval)
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
	jp	vpeek_screendollar

