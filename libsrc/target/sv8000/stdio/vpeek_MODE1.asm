
		SECTION		code_clib

		PUBLIC		vpeek_MODE1
		EXTERN		vpeek_screendollar

		INCLUDE		"target/sv8000/def/sv8000.def"

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
        ld      bc,DISPLAY
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
