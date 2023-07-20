;
;


    SECTION		code_clib

    PUBLIC		generic_console_cls
    PUBLIC		generic_console_vpeek
    PUBLIC		generic_console_scrollup
    PUBLIC		generic_console_printc
    PUBLIC		generic_console_xypos

    EXTERN		generic_console_generic_console_xypos
    EXTERN		conio_map_colour
    EXTERN		__console_w
    EXTERN		__console_h
    EXTERN		__bee_custom_font
    EXTERN		__bee_attr

    defc		DISPLAY = 0xf000

generic_console_cls:
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc, 80 * 25 - 1
	ld	(hl),32
	ldir
	ld	a,64
	out	(8),a
	ld	hl, DISPLAY + $800 
	ld	de, DISPLAY + $800 + 1
	ld	bc, 80 * 25 - 1
	ld	a,(__bee_attr)
	ld	(hl),a
	ldir
	xor	a
	out	(8),a
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
    ld	a,e
    call    generic_console_xypos
    ld      d,(hl)
    rra
    call	nc,vpeek_unmap
    ld	a,d
    and     a
    ret

; Unmap characters:
; Need to handle 
vpeek_unmap:
	ld	a,d
	cp	128 + 16
	ret	c		; It's a block graphic
	sub	16
	ld	d,a
	cp	128 + 16
	ret	c		; First 16 UDGs
	ld	a,(__bee_custom_font)
	and	a
	ret	z		; It's all UDGs
	ld	a,d
	sub	128 - 16
	ld	d,a
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
	ld	a,d
	jr	z,no_custom_font
	cp	128
	ret	nc
	or	128
	ret

no_custom_font:	
	cp	128
	ret	c
	add	16		;UDGs are shifted by 16
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

construct_block_graphics:
	ld	hl,$f800
	ld	a,0
construct_loop_1:
	ld	b,a
	push	af
	call	do_block
	ld	b,4
construct_loop_2:
	ld	(hl),0
	inc	hl
	djnz	construct_loop_2
	pop	af
	inc	a
	and	15
	jr	nz,construct_loop_1
	ret


do_block:
	call	do_half_block
do_half_block:
	rr	b
	sbc	a
	and	$0f
	ld	c,a
	rr	b
	sbc	a
	and	$f0
	or	c
	ld	c,6
do_half_block_1:
	ld	(hl),a
	inc	hl
	dec	c
	jr	nz,do_half_block_1
	ret


	SECTION		code_crt_init

	EXTERN	copy_font_8x8
	EXTERN	CRT_FONT

        ld      hl,$f800 + (32 * 16)            ;PCG area
	ld	c,96
	ld	de,CRT_FONT
	ld	a,d
	or	e
	ld	(__bee_custom_font),a
	call	nz,copy_font_8x8
	; Build the block udgs we need
	call	construct_block_graphics


