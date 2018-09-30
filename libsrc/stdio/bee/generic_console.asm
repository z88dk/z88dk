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
		PUBLIC		generic_console_xypos

		EXTERN		generic_console_generic_console_xypos
		EXTERN		conio_map_colour
		EXTERN		__console_w
		EXTERN		__console_h
		EXTERN		__bee_custom_font
		EXTERN		__bee_attr

		defc		DISPLAY = 0xf000

generic_console_set_inverse:
	ret


generic_console_set_paper:
	call	conio_map_colour
	rlca
	rlca
	rlca
	rlca
	and	@11110000
	ld	c,a
	ld	b,15
set_attr:
	ld	hl,__bee_attr
	ld	a,(hl)
	and	b
	or	c
	ld	(hl),a
	ret
	
generic_console_set_ink:
	call	conio_map_colour
	and	15
	ld	c,a
	ld	b,240
	jr	set_attr

generic_console_cls:
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc, 80 * 24 - 1
	ld	(hl),32
	ldir
	ld	hl, DISPLAY + $800 
	ld	de, DISPLAY + $800 + 1
	ld	bc, 80 * 24 - 1
	ld	a,(__bee_attr)
	ld	(hl),a
	ldir
	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	rr	e
	call	nc,map_character
	call	generic_console_xypos
	ld	(hl),a
	ld	a,h
	add	8
	ld	h,a
	ld	a,64
	out	(8),a
	ld	a,(__bee_attr)
	ld	(hl),a
	xor	a
	out	(8),a
	ret


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        call    generic_console_xypos
        ld      d,(hl)
	call	nz,vpeek_unmap
	ld	a,d
        and     a
        ret

vpeek_unmap:
	ld	a,(__bee_custom_font)
	and	a
	ret	z
	ld	a,d
	cp	160
	ret	c
	res	7,d
	ret


; We use the PCG to hold both font/UDGs and block graphics
; Characters 128 -> 143 = block graphics
; Characters 144 -> 255 = udgs *OR* inverse text
;
; If we're input with 128 onwards then we need to add 16
; Entry: d = a = character
;        bc = coordinates
; Exit:   a = character to print
map_character:
	ld	a,(__bee_custom_font)
	and	a
	jr	z,no_custom_font
	ld	a,d
	cp	128
	ret	nc
	or	128
	ret

no_custom_font:	
	cp	128
	ret	c
	add	16
	ret


generic_console_scrollup:
        push    de
        push    bc
        ld      a,(__console_h)
        dec     a
        ld      bc,0
scroll_1:
        push    af
        push    bc
        call    generic_console_xypos
        pop     bc
        push    bc
        push    hl
        inc     b
        call    generic_console_xypos           ;hl = source
        pop     de              ;de = dest
        push    hl
        push    de
        ld      bc,(__console_w)
        ld      b,0
        ldir

        ; And now scroll the attributes
        pop     de
        pop     hl
        set     3,h
        set     3,d
        ld      a,64
        out     (8),a
        ld      bc,(__console_w)
        ld      b,0
        ldir
        xor     a
        out     (8),a
        pop     bc
        inc     b
        pop     af
        dec     a
        jr      nz,scroll_1

        ld      a,(__console_w)
scroll_2:
        push    af
        push    bc
        ld      a,32
        ld      d,a
        ld      e,0
        call    generic_console_printc
        pop     bc
        inc     c
        pop     af
        dec     a
        jr      nz,scroll_2
        pop     bc
        pop     de
        ret


generic_console_xypos:
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
        add     hl,bc                   ;hl now points to address in display
        ret
