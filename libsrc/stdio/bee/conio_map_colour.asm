; Platform specific colour transformation
;
; Entry: a = colour
; Exit:  a = colour to use on screen
; Used:  hl,bc,f
;

	SECTION	code_clib
	PUBLIC	conio_map_colour

	EXTERN	__CLIB_CONIO_NATIVE_COLOUR

conio_map_colour:
        ld      c,__CLIB_CONIO_NATIVE_COLOUR
        rr      c
        ret     c
	and	15
	ld	c,a
	ld	b,0
	ld	hl,table
	add	hl,bc
	ld	a,(hl)
	ret

	SECTION	rodata_clib
table:
        defb    $0	;BLACK -> BLACK
	defb	$4	;BLUE -> BLUE
	defb	$2	;GREEN -> GREEN
	defb	$6	;CYAN -> CYAN
	defb	$1	;RED -> RED
	defb	$5	;MAGENTA -> MAGENTA
	defb	$3	;BROWN -> DARK YELLOW
	defb	$7	;LIGHTGRAY -> WHITE
	defb	$8	;DARKGRAY -> GRAY?
	defb	$c	;LIGHTBLUE -> BRIGHT BLUE
	defb	$a	;LIGHTGREEN -> BRIGHT GREEN
	defb	$e	;LIGHTCYAN -> BRIGHT CYAN
	defb	$9	;LIGHTRED -> BRIGHT RED
	defb	$d	;LIGHTMAGENTA -> BRIGHT MAGENTA
	defb	$b	;YELLOW -> BRIGHT YELLOW
	defb	$f	;WHITE -> BRIGHT WHITE

