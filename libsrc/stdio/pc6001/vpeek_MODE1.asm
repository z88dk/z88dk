
		SECTION		code_clib

		PUBLIC		vpeek_MODE1
		EXTERN		vpeek_screendollar

		INCLUDE		"target/pc6001/def/pc6001.def"

;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
vpeek_MODE1:
        ld      hl,-8
        add     hl,sp           
        ld      sp,hl
        push    hl              ;Save buffer
        ex      de,hl           ;get it into de
        ld      h,b             ; 32 * 8
        ld      l,c
        ld      bc,(SYSVAR_screen - 1)
	inc	h
	inc	h

        ld      c,0
        add     hl,bc           ;hl = screen

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
	jp	vpeek_screendollar
