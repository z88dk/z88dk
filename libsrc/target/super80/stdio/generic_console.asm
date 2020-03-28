;
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
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute

		EXTERN		generic_console_flags
		EXTERN		conio_map_colour
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		__super80_attr
		EXTERN		__super80_custom_font

		defc		DISPLAY = $be00
		defc		COLOUR_MAP = $fe00

		INCLUDE		"ioctl.def"
		PUBLIC          CLIB_GENCON_CAPS
		defc            CLIB_GENCON_CAPS = CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR | CAP_GENCON_INVERSE


generic_console_ioctl:
	scf
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
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	(hl),32
	ldir
	ld	hl, COLOUR_MAP
	ld	de, COLOUR_MAP+1
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	a,(__super80_attr)
	ld	(hl),a
	ldir
	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
        rr      e
        call    nc,map_character
	call	xypos
	ld	(hl),a
	set	6,h
	ld	a,(generic_console_flags)
	rlca
	ld	a,(__super80_attr)
	jr	nc,place
	; Invert by inverting the colours
	rlca
	rlca
	rlca
	rlca
place:
	ld	(hl),a
	ret


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	ld	a,e
        call    xypos
	ld	d,(hl)
	rra
	call	nc,vpeek_unmap
	ld	a,d
	and	a
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
	ld	l,b
	ld	h,0
	add	hl,hl		;x32
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ld	b,$be
	add	hl,bc			;hl now points to address in display
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	hl, DISPLAY + CONSOLE_COLUMNS
	ld	de, DISPLAY
	ld	bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
	ldir
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	ld	hl, COLOUR_MAP + CONSOLE_COLUMNS
	ld	de, COLOUR_MAP
	ld	bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
	ldir
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
	ld	a,(__super80_attr)
generic_console_scrollup_4:
	ld	(hl),a
	inc	hl
	djnz	generic_console_scrollup_4
	pop	bc
	pop	de
	ret


	SECTION data_clib

__super80_attr:	defb	0x0e		;white on black

__super80_mode:     defb            0
                ; Mode 0 = 80 column
                ; Mode 1 = 64 column
                ; Mode 2 = 40 column

__super80_custom_font:
                defb            0
