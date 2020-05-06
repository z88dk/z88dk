; Platform specific colour transformation
;
; Entry: a = colour
; Exit:  a = colour to use on screen
; Used:  hl,bc,f
;

	MODULE	code_clib
	PUBLIC	conio_map_colour
	PUBLIC	conio_map_colour_mx

	EXTERN	__CLIB_CONIO_NATIVE_COLOUR


conio_map_colour_mx:
	ret

conio_map_colour:
	;No point not mapping on the Specialist
	and	15
	ld	c,a
	ld	b,0
	ld	hl,table
	add	hl,bc
	ld	a,(hl)
	ret

	SECTION	rodata_clib

table:
        defb    @11010000	;BLACK -> BLACK
	defb	@11000000	;BLUE -> BLUE
	defb	@10010000	;GREEN -> GREEN
	defb	@10000000	;CYAN -> CYAN
	defb	@01010000	;RED -> RED
	defb	@01010000	;MAGENTA -> MAGENTA
	defb	@01010000	;BROWN -> RED
	defb	@00000000	;LIGHTGRAY -> WHITE
	defb	@00000000	;DARKGRAY -> WHITE
	defb	@11000000	;LIGHTBLUE -> BLUE
	defb	@10010000	;LIGHTGREEN -> GREEN
	defb	@10000000	;LIGHTCYAN -> CYAN
	defb	@01010000	;LIGHTRED -> RED
	defb	@01010000	;LIGHTMAGENTA -> MAGENTA
	defb	@00010000	;YELLOW -> YELLOW
	defb	$00000000	;WHITE -> WHITE

