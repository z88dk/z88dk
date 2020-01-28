; Super-80 VDUEM generic console
;
; Nibble	Composite	RGB
;0	Black	Black
;1	Grey	Black
;2	Blue	Blue
;3	L.Yellow	L.Blue
;4	Green	Green
;5	L.Magenta	Bright Green
;6	Cyan	Cyan
;7	L.Red	Turquoise
;8	Red	Dark Red
;9	Dark Cyan	Red
;A	Magenta	Purple
;B	L.Green	Magenta
;C	Yellow	Lime
;D	Dark Blue	Yellow
;E	White	Off White
;F	Black	Bright White



		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute

		EXTERN		generic_console_flags
		EXTERN		conio_map_colour
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		__super80_attr
		EXTERN		__super80_custom_font
		EXTERN		PORT_F0_COPY

		defc		DISPLAY = $f000
		defc		COLOUR_MAP = $f000

generic_console_set_attribute:
	ret

generic_console_set_paper:
	call	conio_map_colour
	and	15
	rla
	rla
	rla
	rla	
	ld	e,a
	ld	a,(__super80_attr)
	and	@00001111
	or	e
	ld	(__super80_attr),a
	ret

	
generic_console_set_ink:
	call	conio_map_colour
	and	15
	ld	e,a
	ld	a,(__super80_attr)
	and	@11110000
	or	e
	ld	(__super80_attr),a
	ret

generic_console_cls:
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc, 80 * 25 - 1
	ld	(hl),32
	ldir
	ld	a,(PORT_F0_COPY)
	bit	2,a	; If bit 2 is reset, then we're on an r with no colour
	ret	z
	push	af
	res	2,a
	out	($F0),a
	ld	hl, COLOUR_MAP
	ld	de, COLOUR_MAP+1
	ld	bc, 80 * 25 - 1
	ld	a,(__super80_attr)
	ld	(hl),a
	ldir
	pop	af
	out	($F0),a
	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	rr	e
	call	nc,map_character
	call	xypos
	ld	(hl),a
	ld	a,(PORT_F0_COPY)
	bit	2,a
	ret	z
	push	af
	res	2,a
	out	($F0),a
	ld	a,(generic_console_flags)
	rlca
	ld	a,(__super80_attr)
	jr	nc,place
	; Do inverse by reversing attributes
	rlca
	rlca
	rlca
	rlca
place:
	ld	(hl),a
	pop	af
	out	($F0),a
	ret


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        ld      a,e
        call    xypos
        ld      d,(hl)
        rra
        call    nc,vpeek_unmap
        ld      a,d
        and     a
        ret

; Unmap characters:
; Need to handle
vpeek_unmap:
        ld      a,d
        cp      128 + 16
        ret     c               ; It's a block graphic
        sub     16
        ld      d,a
        cp      128 + 16
        ret     c               ; First 16 UDGs
        ld      a,(__super80_custom_font)
        and     a
        ret     z               ; It's all UDGs
        ld      a,d
        sub     128 - 16
        ld      d,a
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
        ld      a,(__super80_custom_font)
        and     a
        ld      a,d
        jr      z,no_custom_font
        cp      128
        ret     nc
        or      128
        ret
no_custom_font:
        cp      128
        ret     c
        add     16              ;UDGs are shifted by 16
        ret

xypos:
        ld      hl,DISPLAY
        ld      de,80
        ld      d,0
        and     a
        sbc     hl,de
        inc     b
xypos_1:
        add     hl,de
        djnz    xypos_1
        add     hl,bc                   ;hl is now offset in display
        ret


generic_console_scrollup:
	push	de
	push	bc
	ld	hl, DISPLAY + 80
	ld	de, DISPLAY
	ld	bc, 80 * 24
	ldir
	ex	de,hl
	ld	b,80
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	ld	a,(PORT_F0_COPY)
	bit	2,a	
	jr	z,no_scroll_colour
	push	af
	res	2,a
	out	($F0),a
	ld	hl, COLOUR_MAP + 80
	ld	de, COLOUR_MAP
	ld	bc, 80 * 24
	ldir
	ex	de,hl
	ld	b,80
	ld	a,(__super80_attr)
generic_console_scrollup_4:
	ld	(hl),a
	inc	hl
	djnz	generic_console_scrollup_4
	pop	af
	out	($F0),a
no_scroll_colour:
	pop	bc
	pop	de
	ret

construct_block_graphics:
        ld      hl,$f800
        ld      a,0
construct_loop_1:
        ld      b,a
        push    af
        call    do_block
	ld	(hl),a
	inc	hl
        ld      b,7
construct_loop_2:
        ld      (hl),0
        inc     hl
        djnz    construct_loop_2
        pop     af
        inc     a
        and     15
        jr      nz,construct_loop_1
        ret

do_block:
        call    do_half_block
do_half_block:
        rr      b
        sbc     a
        and     $0f
        ld      c,a
        rr      b
        sbc     a
        and     $f0
        or      c
        ld      c,4
do_half_block_1:
        ld      (hl),a
        inc     hl
        dec     c
        jr      nz,do_half_block_1
        ret

	SECTION data_clib

__super80_attr:	defb	0x0e		;white on black

__super80_custom_font:
                defb            0

        SECTION         code_crt_init

        EXTERN  copy_font_8x8
        EXTERN  CRT_FONT
	EXTERN	asm_set_cursor_state

	ld	l,20
	call	asm_set_cursor_state

        ld      hl,$f800 + (32 * 16)            ;PCG area
        ld      c,96
        ld      de,CRT_FONT
        ld      a,d
        or      e
        ld      (__super80_custom_font),a
        call    nz,copy_font_8x8
        ; Build the block udgs we need
        call    construct_block_graphics
