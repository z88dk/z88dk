;
;



		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		EXTERN		__console_w
		EXTERN		__console_h
		EXTERN		__x1_attr

		defc		DISPLAY = $3000


generic_console_set_inverse:
    ld      a,(__x1_attr)
    res     3,a
    bit     7,(hl)
    jr      z,not_inverse
    set     3,a
not_inverse:
    ld      (__x1_attr),a
    ret

generic_console_set_ink:
    and     7
    ld      e,a
    ld      a,(__x1_attr)
    and     @11111000
    or      e
    ld      (__x1_attr),a
    ret

	
generic_console_set_paper:
	ret

generic_console_cls:
    ld      bc,DISPLAY
    ld      hl,(__console_w)	;l = w, h = height
cls_1:
    ld      a,' '
    out     (c),a
    res     4,b
    ld      a,(__x1_attr)
    out     (c),a
    set     4,b
    inc     bc
    dec     l
    jr      nz,cls_1
    dec     h
    jr      nz,cls_1
    ret


; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
    call    xypos
    ld      c,l
    ld      b,h
    out     (c),a
    res     4,b
    ld      a,(__x1_attr)
    out     (c),a
    ret


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
    call    xypos
    ld      c,l
    ld      b,h
    in      a,(c)
    and     a
    ret


xypos:
    ld      hl,DISPLAY 
    ld      de,(__console_w)
    ld      d,0
    and     a
    sbc     hl,de
    inc     b
generic_console_printc_1:
    add     hl,de
    djnz    generic_console_printc_1
generic_console_printc_3:
    add     hl,bc			;hl now points to address in display
    ret


generic_console_scrollup:
    push    de
    push    bc
    ld      hl, DISPLAY
    ld      de,(__console_w)
    ld      d,0
    add     hl,de
    ld      c,l
    ld      b,h
    ld      a,(__console_h)
    dec     a
    ld      h,a
scroll_loop:
    ld      a,(__console_w)
    ld      l,a
scroll_loop1:
    push    hl
    in      e,(c)
    res     4,b
    in      d,(c)
    set     4,b

    ld      h,b
    ld      l,c
    ld      bc,(__console_w)
    ld      b,0
    and     a
    sbc     hl,bc
    ld      c,l
    ld      b,h

    out     (c),e
    res     4,b
    out     (c),d
    set     4,b
    ld      hl,(__console_w)
    ld      h,0
    inc     hl
    add     hl,bc
    ld      c,l
    ld      b,h
    pop     hl
    dec     l
    jr      nz,scroll_loop1
    dec     h
    jr      nz,scroll_loop

    ld      h,b
    ld      l,c
    ld      bc,(__console_w)
    ld      b,0
    and     a	
    sbc     hl,bc
    ld      e,c	;width
    ld      c,l
    ld      b,h
    ld      d,' '
    ld      a,(__x1_attr)
scroll_loop_2:
    out     (c),d
    res     4,b
    out     (c),a
    set     4,b
    inc     bc
    dec     e
    jr      nz,scroll_loop_2
    pop     bc
    pop     de
    ret

