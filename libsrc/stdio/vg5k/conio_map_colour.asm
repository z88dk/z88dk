; Platform specific colour transformation
;
; Entry: a = colour
; Exit:  a = colour to use on screen
; Used:  hl,bc,f
;

	MODULE	code_clib
	PUBLIC	conio_map_colour

	EXTERN	__CLIB_CONIO_NATIVE_COLOUR

conio_map_colour:
        ld      c,__CLIB_CONIO_NATIVE_COLOUR
        rr      c
        ret     c

        and     15
	ld	c,a
	ld	b,0
	ld	hl,colour_table
	add	hl,bc	
	ld	a,(hl)
	ret

	SECTION	rodata_clib

colour_table:
        defb    @00000000       ;BLACK -> GREEN
        defb    @00000100       ;BLUE -> BLUE
        defb    @00000010       ;GREEN -> GREEN
        defb    @00000110       ;CYAN -> CYAN
        defb    @00000001       ;RED -> RED
        defb    @00000101       ;MAGENTA -> MAGENTA
        defb    @00000001       ;BROWN -> RED
        defb    @00000111       ;LIGHTGRAY -> WHITE
        defb    @00000111       ;DARKGRAY -> WHITE
        defb    @00000100       ;LIGHTBLUE -> BLUE
        defb    @00000010       ;LIGHTGREEN -> GREEN
        defb    @00000110       ;LIGHTCYAN -> CYAN
        defb    @00000001       ;LIGHTRED -> RED
        defb    @00000101       ;LIGHTMAGENTA -> MAGENTA
        defb    @00000011       ;YELLOW -> YELLOW
        defb    @00000111       ;WHITE -> BUFF
