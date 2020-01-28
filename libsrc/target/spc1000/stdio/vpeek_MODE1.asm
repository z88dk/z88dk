
		; code_driver to ensure we don't page ourselves out
		SECTION		code_clib

		PUBLIC		vpeek_MODE1

		EXTERN		vpeek_screendollar



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
	jp	vpeek_screendollar
