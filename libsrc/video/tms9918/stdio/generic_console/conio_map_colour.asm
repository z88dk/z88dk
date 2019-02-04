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

	and	15
	ld	c,a
	ld	b,0
	ld	hl,table
	add	hl,bc
	ld	a,(hl)
	ret

	SECTION	rodata_clib
table:
        defb    $1	;BLACK -> BLACK
	defb	$4	;BLUE -> DARK BLUE
	defb	$c	;GREEN -> MEDIUM GREEN
	defb	$7	;CYAN -> CYAN
	defb	$6	;RED -> DARK RED
	defb	$d	;MAGENTA -> MAGENTA
	defb	$8	;BROWN -> MEDIUM RED
	defb	$b	;LIGHTGRAY -> LIGHT YELLOW
	defb	$e	;DARKGRAY -> GRAY
	defb	$5	;LIGHTBLUE -> LIGHT BLUE
	defb	$3	;LIGHTGREEN -> LIGHT GREEN
	defb	$7	;LIGHTCYAN -> CYAN
	defb	$9	;LIGHTRED -> LIGHT RED
	defb	$d	;LIGHTMAGENTA -> MAGENTA
	defb	$a	;YELLOW -> DARK YELLOW
	defb	$f	;WHITE -> WHITE

