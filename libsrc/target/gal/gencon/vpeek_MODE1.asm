
		; code_driver to ensure we don't page ourselves out
		SECTION		code_driver

		PUBLIC		vpeek_MODE1
		EXTERN		vpeek_screendollar
		EXTERN		__gal_modeval


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
        ld      bc,($2a6a)
        add     hl,bc           ;hl = screen
	ld	bc,$20
	add	hl,bc

        ld      b,8
vpeek_1:
        ld      a,(hl)
	; Mirror the byte
        ld      c,a
        rlca
        rlca
        xor     c
        and     0xaa
        xor     c
        ld      c,a
        rlca
        rlca
        rlca
        rrc     c
        xor     c
        and     0x66
        xor     c
	ld	(de),a
        ld      a,l
        add     32
        ld      l,a
        jr      nc,no_overflow
        inc     h
no_overflow:
        inc     de
        djnz    vpeek_1
	jp	vpeek_screendollar

