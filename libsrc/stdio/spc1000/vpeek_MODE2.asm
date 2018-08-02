
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


	ld	a,c
	add	c
	ld	c,a
	jr	nc,no_overflow
	inc	b
no_overflow:

        ; b7   b6   b5   b4   b3   b2   b1   b0
         ; p0-1 p1-1 p2-1 p3-1 p0-0 p1-0 p2-0 p3-0
        ld      a,8
handle_MODE2_per_line:
	ex	af,af
        push    hl      ;save buffer
        ld      h,@10000000
        ld      e,0     ;resulting byte
        ld      a,2     ;we need to do this loop twice
handle_mode1_nibble:
        push    af
        ld      l,@11000000
        ld      d,4     ;4 pixels in a byte
handle_MODE2_0:
	in	a,(c)
        and     l
        jr      z,not_set
        ld      a,e
        or      h
        ld      e,a
not_set:
        srl     h
        srl     l
        srl     l
	dec	d
	jr	nz, handle_MODE2_0
        inc     bc
        pop     af
        dec     a
        jr      nz,handle_mode1_nibble
        pop     hl              ;buffer
        ld      (hl),e
        inc     hl
	ld	a,c
	add	30
	ld	c,a
	jr	nc,no_overflow_MODE2
	inc	b
no_overflow_MODE2:
	ex	af,af
	dec	a
        jr	nz,handle_MODE2_per_line
	jp	vpeek_screendollar

