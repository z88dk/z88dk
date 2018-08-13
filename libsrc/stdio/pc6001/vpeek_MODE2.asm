
		SECTION		code_clib

		PUBLIC		vpeek_MODE2
		EXTERN		vpeek_screendollar

		INCLUDE		"target/pc6001/def/pc6001.def"

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
vpeek_MODE2:
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

        ; b7   b6   b5   b4   b3   b2   b1   b0
         ; p0-1 p1-1 p2-1 p3-1 p0-0 p1-0 p2-0 p3-0
        ld      c,l
        add     hl,bc           ;hl = screen
	ex	de,hl
        ld      b,8
handle_MODE2_per_line:
        push    bc
        push    hl      ;save buffer
        ld      h,@10000000
        ld      c,0     ;resulting byte
        ld      a,2     ;we need to do this loop twice
handle_mode1_nibble:
        push    af
        ld      l,@11000000
        ld      b,4     ;4 pixels in a byte
handle_MODE2_0:
        ld      a,(de)
        and     l
        jr      z,not_set
        ld      a,c
        or      h
        ld      c,a
not_set:
        srl     h
        srl     l
        srl     l
        djnz    handle_MODE2_0
        inc     de
        pop     af
        dec     a
        jr      nz,handle_mode1_nibble
        pop     hl              ;buffer
        ld      (hl),c
        inc     hl
        dec     de
        dec     de
	ld	a,e
	add	32
	ld	e,a
	jr	nc,no_overflow_MODE2
	inc	d
no_overflow_MODE2:
        pop     bc
        djnz    handle_MODE2_per_line
	jp	vpeek_screendollar

