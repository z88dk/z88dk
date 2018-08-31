
	SECTION	rodata_clib
	PUBLIC	mc6847_map_colour


; Map conio colour to colours
; Entry:  a = colour
; Exit:   c = text colour
;         b = colour colour
; Uses:   dehl
mc6847_map_colour:
	and	15
	ld	l,a
	and	1
	ld	c,a
	ld	h,0
	ld	de,table
	add	hl,de
	ld	b,(hl)
	ret


table:
; Bit 7 = bit 2
; Graphics 3x2 + colour = @11 + attribute bit in 7
        defb    @00000000       ;BLACK -> GREEN
        defb    @00000010       ;BLUE -> BLUE
        defb    @00000000       ;GREEN -> GREEN
        defb    @10000101       ;CYAN -> CYAN
        defb    @00000011       ;RED -> RED
        defb    @10000110       ;MAGENTA -> MAGENTA
        defb    @10000111       ;BROWN -> ORANGE
        defb    @10000100       ;LIGHTGRAY -> BUFF
        defb    @10000100       ;DARKGRAY -> BUFF
        defb    @00000010       ;LIGHTBLUE -> BLUE
        defb    @00000000       ;LIGHTGREEN -> GREEN
        defb    @10000101       ;LIGHTCYAN -> CYAN
        defb    @00000011       ;LIGHTRED -> RED
        defb    @10000110       ;LIGHTMAGENTA -> MAGENTA
        defb    @00000001       ;YELLOW -> YELLOW
        defb    @10000100       ;WHITE -> BUFF
