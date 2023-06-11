;
;

	SECTION		code_clib
	PUBLIC		conio_map_colour_firmware
	PUBLIC		cpc_set_ansi_palette

	INCLUDE		"target/cpc/def/cpcfirm.def"

	EXTERN		__CLIB_CONIO_NATIVE_COLOUR

; Map ANSI colours to firmware colours
conio_map_colour_firmware:
	ld	hl,ansipalette
do_mapping:
        ld      c,__CLIB_CONIO_NATIVE_COLOUR
        rr      c
        ret     c
        and     15
        ld      c,a
        ld      b,0
        add     hl,bc
        ld      a,(hl)
        ret

; Set the CPC palette to the ANSI palette
cpc_set_ansi_palette:
        ld      c,__CLIB_CONIO_NATIVE_COLOUR
        rr      c
        ret     c
	ld	hl,ansipalette
	xor	a
loop:
	push	af
	push	hl
	ld	c,(hl)
	ld	b,c
	call	firmware
	defw	scr_set_ink
	pop	hl
	inc	hl
	pop	af
	inc	a
	cp	16
	jr	nz,loop	
	ret



	SECTION rodata_clib

; Mapping to firmware colours from ANSI colours

; Colours to map into ANSI colours onto the CPC palette

ansipalette:
        defb    0      ;BLACK -> BLACK
        defb    2      ;BLUE -> BRIGHT BLUE
        defb    18     ;GREEN -> BRIGHT GREEN
        defb    10     ;CYAN -> CYAN
        defb    6      ;RED -> BRIGHT RED
        defb    8      ;MAGENTA -> BRIGHT MAGENTA
        defb    3      ;BROWN -> RED
        defb    13     ;LIGHTGRAY -> WHITE
        defb    13     ;DARKGRAY -> WHITE
        defb    1      ;LIGHTBLUE -> BRIGHT BLUE
        defb    9      ;LIGHTGREEN -> GREEN
        defb    20     ;LIGHTCYAN -> BRIGHT CYAN
        defb    15     ;LIGHTRED -> ORANGE
        defb    4      ;LIGHTMAGENTA -> BRIGHT MAGENTA
        defb    24     ;YELLOW -> YELLOW
        defb    26     ;WHITE -> WHITE


